public class Gradient {
   
   Face face;
   Vertex[] vertices;
   
   public Gradient(Face face, Vertex[] vertices) {
      this.face = face;
      this.vertices = vertices;
   }
   
   public void viewByCamera(Camera camera, float diff) {
      Vertex top = vertices[0];
      Vertex middle = vertices[1];
      Vertex bottom = vertices[2];
      
      // Is the long side on the right?
      boolean rightHanded = (top.doubleArea(bottom, middle) >= 0);
      Edge topToMiddle = new Edge(top, middle);
      Edge middleToBottom = new Edge(middle, bottom);
      Edge topToBottom = new Edge(top, bottom);

      Edge leftEdge = topToBottom;
      Edge rightEdge = topToMiddle;
      if (rightHanded) {
         Edge temp = leftEdge;
         leftEdge = rightEdge;
         rightEdge = temp;
      }

      // Draw top half of triangle
      for (int y = int(topToMiddle.getStartY()); y < int(topToMiddle.getEndY()); y++) {
         if (y >= 0 && y < camera.getView().height) {
            drawScanLine(camera, leftEdge, rightEdge, y, diff);
         }
         topToMiddle.step();
         topToBottom.step();
      }

      leftEdge = topToBottom;
      rightEdge = middleToBottom;
      if (rightHanded) {
         Edge temp = leftEdge;
         leftEdge = rightEdge;
         rightEdge = temp;
      }

      // Draw bottom half of triangle
      for (int y = int(middleToBottom.getStartY()); y < int(middleToBottom.getEndY()); y++) {
         if (y >= 0 && y < camera.getView().height) {
            drawScanLine(camera, leftEdge, rightEdge, y, diff);
         }
         middleToBottom.step();
         topToBottom.step();
      }
   }
   
   private void drawScanLine(Camera camera, Edge left, Edge right, int y, float diff) {
      int startX = ceil(left.getX() - 0.5);
      int endX = ceil(right.getX() - 1.5);
      
      float invZStep = (right.getInvZ() - left.getInvZ()) / (right.getX() - left.getX());
      float invZ = left.getInvZ() + ((ceil(left.getX() - 0.5) + 0.5) - left.getX()) * invZStep;
      
      PVector invTextureUVStep = right.getInvTextureUV().sub(left.getInvTextureUV()).div(right.getX() - left.getX());
      PVector invTextureUV = left.getInvTextureUV().add(invTextureUVStep.copy().mult((ceil(left.getX() - 0.5) + 0.5) - left.getX()));
      
      for (int x = startX; x <= endX; x++) {
         if (x >= 0 && x < camera.getView().width) {
            float z = 1.0 / invZ;
            if (z > camera.getNearPlane() && z < camera.getDepthBuffer()[y][x]) {
               camera.getDepthBuffer()[y][x] = z;
               
               color textel = color(camera.getTexture().get(int((invTextureUV.x / invZ) * camera.getTexture().width), int((invTextureUV.y / invZ) * camera.getTexture().height)));  
               diff = -constrain(-diff, 0.3, 1);
               textel = color(red(textel) * -diff, green(textel) * -diff, blue(textel) * -diff);
             
               camera.getView().set(x, y, textel);
            }
         } 
         invZ += invZStep;
         invTextureUV.add(invTextureUVStep);
      }
   }
}