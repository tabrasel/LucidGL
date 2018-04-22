public class Face {
   
   private Vertex[] vertices;
   private PVector[] textureVertices;
   
   public Face(Vertex[] vertices, PVector[] textureVertices) {
      this.vertices = vertices;
      this.textureVertices = textureVertices;
   }
   
   public Vertex[] getVertices() {
      return vertices;
   }
   
   public PVector[] getTextureVertices() {
      return textureVertices;
   }
}