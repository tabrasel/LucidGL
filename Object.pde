public class Object {

   private PVector pos;
   private PVector angle;
   private PVector[] originAxis;
   private Mesh mesh;

   public Object(String objFile) {
      pos = new PVector();
      angle = new PVector(0, 0, 0);
      originAxis = new PVector[3];
      originAxis[0] = new PVector(1, 0, 0);
      originAxis[1] = new PVector(0, 1, 0);
      originAxis[2] = new PVector(0, 0, 1);
      mesh = new Mesh(objFile);
   }
   
   public Object(String objFile, PVector pos) {
      this(objFile);
      this.pos = pos;
      rotateYaw();
   }

   public void update() {
      if (keyPressed) {
         if (keyCode == LEFT) {
            //changeAngle(new PVector(0, -0.04, 0));
         } else if (keyCode == RIGHT) {
            //changeAngle(new PVector(0, 0.04, 0));
         } else if (keyCode == UP) {
            changePos(new PVector(originAxis[2].x * 0.01, originAxis[0].y, originAxis[2].z * 0.01));
         }
      }
   }

   public void changePos(PVector change) {
      pos.add(change);
   }

   public void changeAngle(PVector change) {
      angle.add(change);
   }

   public void rotateYaw() {
      Quaternion yawRotation = new Quaternion(originAxis[1], angle.y);
      originAxis[0] = yawRotation.rotateVector(new PVector(1, 0, 0));
      originAxis[2] = yawRotation.rotateVector(new PVector(0, 0, 1));
      for (Vertex vertex : mesh.getVertices()) {
         PVector rotatedVertex = yawRotation.rotateVector(vertex.getModelPos());
         rotatedVertex.add(pos);
         vertex.setWorldPos(rotatedVertex);
      }
   }

   public PVector getAngle() {
      return angle;
   }

   public Mesh getMesh() {
      return mesh;
   }
}