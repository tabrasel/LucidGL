public class Edge {
   
   private float startY, endY;
   private float x, xStep;
   private float invZ, invZStep;
   private PVector invTextureUV, invTextureUVStep;
   
   public Edge(Vertex top, Vertex bottom) {
      startY = ceil(top.getScreenPos().y - 0.5) + 0.5;
      endY = ceil(bottom.getScreenPos().y - 0.5) + 0.5;
      
      xStep = (bottom.getScreenPos().x - top.getScreenPos().x) / (bottom.getScreenPos().y - top.getScreenPos().y);
      x = top.getScreenPos().x + xStep * (startY - top.getScreenPos().y);
      
      invZStep = ((1.0 / bottom.getCameraPos().z) - (1.0 / top.getCameraPos().z)) / (bottom.getScreenPos().y - top.getScreenPos().y);
      invZ = (1.0 / top.getCameraPos().z) + invZStep * (startY - top.getScreenPos().y);
      
      invTextureUVStep = bottom.getInvTextureUV().sub(top.getInvTextureUV()).div(bottom.getScreenPos().y - top.getScreenPos().y);
      invTextureUV = top.getInvTextureUV().add(invTextureUVStep.copy().mult(startY - top.getScreenPos().y));
   }
   
   public void step() {
      x += xStep;
      invZ += invZStep;
      invTextureUV.add(invTextureUVStep);
   }
   
   public float getX() {
      return x;
   }
   
   public float getInvZ() {
      return invZ;
   }
   
   public PVector getInvTextureUV() {
      return invTextureUV.copy();
   }
   
   public float getStartY() {
      return startY;
   }
   
   public float getEndY() {
      return endY;
   }
}