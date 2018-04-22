public class Vertex {
   
   private PVector modelPos;
   private PVector worldPos;
   private PVector cameraPos;
   private PVector screenPos;
   private PVector intensity;
   private PVector textureUV;
   
   public Vertex(PVector modelPos) {
      this.modelPos = modelPos;
      intensity = new PVector(random(255), random(255), random(255));
      textureUV = new PVector(random(1), random(1));
   }
   
   public void setWorldPos(PVector worldPos) {
      this.worldPos = worldPos;
   }
   
   public void setTextureUV(PVector textureUV) {
      this.textureUV = textureUV;
   }
   
   public void viewByCamera(Camera camera) {
      cameraPos = new PVector(worldPos.x - camera.getPos().x, worldPos.y - camera.getPos().y, worldPos.z - camera.getPos().z);
      
      Quaternion yawRotation = new Quaternion(new PVector(0, 1, 0), -camera.getAngle().y);
      cameraPos = yawRotation.rotateVector(cameraPos);
      
      Quaternion pitchRotation = new Quaternion(new PVector(1, 0, 0), -camera.getAngle().x);
      cameraPos = pitchRotation.rotateVector(cameraPos);
      
      screenPos = new PVector(camera.getView().width / 2 + ((cameraPos.x * camera.getFocalLength().x) / cameraPos.z), 
                              camera.getView().height / 2 - ((cameraPos.y * camera.getFocalLength().y) / cameraPos.z));
   }
   
   public float doubleArea(Vertex b, Vertex c) {
      PVector bCanvasPos = b.getScreenPos();
      PVector cCanvasPos = c.getScreenPos();
      float x1 = bCanvasPos.x - screenPos.x;
      float y1 = bCanvasPos.y - screenPos.y;
      float x2 = cCanvasPos.x - screenPos.x;
      float y2 = cCanvasPos.y - screenPos.y;   
      return (x1 * y2 - x2 * y1);
   }
   
   public PVector getModelPos() {
      return modelPos.copy();
   }
   
   public PVector getCameraPos() {
      return cameraPos.copy();
   }
   
   public PVector getScreenPos() {
      return screenPos.copy();
   }
   
   public PVector getIntensity() {
      return intensity.copy();
   }
   
   public PVector getInvTextureUV() {
      return new PVector(textureUV.x / cameraPos.z, textureUV.y / cameraPos.z);
   }
}