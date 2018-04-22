Scene scene;
Camera camera;
int scale = 2;

void setup() {
   size(640, 480);
   noSmooth();

   scene = new Scene();
   camera = new Camera();

   scene.update();
   camera.viewScene(scene);
}

void draw() {
   background(255, 0, 255);

   scene.update();

   camera.update();
   camera.viewScene(scene);

   image(camera.getView(), 
      width / 2 - camera.getView().width / 2 * scale, height / 2 - camera.getView().height / 2 * scale, 
      camera.getView().width * scale, camera.getView().height * scale);

   fill(255);
   textAlign(LEFT, TOP);
   text("FPS: " + int(frameRate) + "\nDrawn faces: " + camera.getDrawnFaces(), 0, 0);
}