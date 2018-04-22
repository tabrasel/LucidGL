public class Camera {

   private PVector pos;
   private PVector angle;
   private PVector viewDirection;
   
   PVector[] orientationAxis;
   private PVector fov, focalLength;
   private PImage view;
   private float[][] depthBuffer;
   private float nearPlane;
   private int drawnFaces;
   private PImage texture;


   public Camera() {
      pos = new PVector(0, 0, 0);
      view = createImage(320, 240, RGB);
      nearPlane = 0.3;
      fov = new PVector(PI * 0.42, PI * 0.32);
      focalLength = new PVector((view.width / 2) / tan(fov.x / 2), (view.height / 2) / tan(fov.y / 2));
      depthBuffer = new float[view.height][view.width];
      texture = loadImage("Texture 3.png");
      angle = new PVector(0, 0, 0);
      viewDirection = new PVector(0, 0, 1);
      resetView();
   }

   public void update() {
      viewDirection = new PVector(0, 0, 1);

      PVector yawAxis = new PVector(0, 1, 0);
      PVector pitchAxis = new PVector(1, 0, 0);

      Quaternion yawRotation = new Quaternion(new PVector(0, 1, 0), angle.y);
      viewDirection = yawRotation.rotateVector(viewDirection);
      pitchAxis = yawRotation.rotateVector(pitchAxis);
      
      Quaternion pitchRotation = new Quaternion(pitchAxis, angle.x);
      viewDirection = pitchRotation.rotateVector(viewDirection);
      yawAxis = pitchRotation.rotateVector(yawAxis);

      if (keyPressed && key == ' ') {
         pos.add(viewDirection.mult(0.1));
      }
      
      if (keyPressed) {
         if (keyCode == LEFT) {
            angle.y -= 0.04;
         } else if (keyCode == RIGHT) {
            angle.y += 0.04;
         } else if (keyCode == UP) {
            angle.x -= 0.04;
         } else if (keyCode == DOWN) {
            angle.x += 0.04;
         }
      }
   }

   public PImage getTexture() {
      return texture;
   }

   private void resetView() {
      for (int y = 0; y < view.height; y++) {
         for (int x = 0; x < view.width; x++) {
            view.set(x, y, color(255, 200, 220));
            depthBuffer[y][x] = Float.MAX_VALUE;
         }
      }
   }

   public void viewScene(Scene scene) {
      resetView();
      drawnFaces = 0;
      for (Object object : scene.getObjects()) {
         Mesh mesh = object.getMesh();
         for (Face face : mesh.getFaces()) {
            drawnFaces += viewFace(face);
         }
      }
   }

   private int viewFace(Face face) {
      Vertex top = face.getVertices()[0];
      Vertex middle = face.getVertices()[1];
      Vertex bottom = face.getVertices()[2];

      top.setTextureUV(face.getTextureVertices()[0]);
      middle.setTextureUV(face.getTextureVertices()[1]);
      bottom.setTextureUV(face.getTextureVertices()[2]);

      top.viewByCamera(this);
      middle.viewByCamera(this);
      bottom.viewByCamera(this);

      boolean isInView = true;
      
      if (top.getScreenPos().x < 0 && middle.getScreenPos().x < 0 && bottom.getScreenPos().x < 0) {
         isInView = false;
      }
      if (top.getScreenPos().x >= camera.getView().width && middle.getScreenPos().x >= camera.getView().width && bottom.getScreenPos().x >= camera.getView().width) {
         isInView = false;
      }
      if (top.getScreenPos().y < 0 && middle.getScreenPos().y < 0 && bottom.getScreenPos().y < 0) {
         isInView = false;
      }
      if (top.getScreenPos().y >= camera.getView().height && middle.getScreenPos().y >= camera.getView().height && bottom.getScreenPos().y >= camera.getView().height) {
         isInView = false;
      }
      if (top.getCameraPos().z < 0 || middle.getCameraPos().z < 0 || bottom.getCameraPos().z < 0) {
         isInView = false;
      }

      if (isInView) {
         // Backface culling
         PVector legOne = middle.getCameraPos().sub(top.getCameraPos());
         PVector legTwo = bottom.getCameraPos().sub(middle.getCameraPos());
         PVector faceNormal = legOne.cross(legTwo);

         float midFaceX = (top.getCameraPos().x + middle.getCameraPos().x + bottom.getCameraPos().x) / 3.0;
         float midFaceY = (top.getCameraPos().y + middle.getCameraPos().y + bottom.getCameraPos().y) / 3.0;
         float midFaceZ = (top.getCameraPos().z + middle.getCameraPos().z + bottom.getCameraPos().z) / 3.0;

         PVector cameraToFace = new PVector(midFaceX, midFaceY, midFaceZ);
         boolean facingTowards = (faceNormal.dot(cameraToFace) < 0);
         float diff = faceNormal.normalize().dot(cameraToFace.normalize());

         if (facingTowards) {
            if (top.getCameraPos().z > nearPlane ||
               middle.getCameraPos().z > nearPlane ||
               bottom.getCameraPos().z > nearPlane) {

               // Order vertices from top to bottom
               if (bottom.getScreenPos().y < middle.getScreenPos().y) {
                  Vertex temp = middle;
                  middle = bottom;
                  bottom = temp;
               }
               if (middle.getScreenPos().y < top.getScreenPos().y) {
                  Vertex temp = top;
                  top = middle;
                  middle = temp;
               }
               if (bottom.getScreenPos().y < middle.getScreenPos().y) {
                  Vertex temp = middle;
                  middle = bottom;
                  bottom = temp;
               }

               Vertex[] vertices = {top, middle, bottom};
               Gradient g = new Gradient(face, vertices);
               g.viewByCamera(this, diff);
               return 1;
            }
         }
      }
      return 0;
   }

   public PVector getPos() {
      return pos.copy();
   }

   public PImage getView() {
      return view;
   }

   public PVector getAngle() {
      return angle.copy();
   }

   public int getDrawnFaces() {
      return drawnFaces;
   }

   public PVector getFocalLength() {
      return focalLength.copy();
   }

   public float getNearPlane() {
      return nearPlane;
   }

   public float[][] getDepthBuffer() {
      return depthBuffer;
   }
}