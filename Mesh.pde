public class Mesh {

   private Vertex[] vertices;
   private Face[] faces;
   
   public Mesh(String objFile) {
      String[] lines = loadStrings(objFile);
      ArrayList<Vertex> vertices = new ArrayList<Vertex>();
      ArrayList<PVector> textureVertices = new ArrayList<PVector>();
      ArrayList<Face> faces = new ArrayList<Face>();

      for (int i = 0; i < lines.length; i++) {
         String line = lines[i].trim().toLowerCase();
         String[] parts = line.split(" ");

         if (parts.length > 0) {
            if (parts[0].equals("v")) {
               float x = float(parts[1]);
               float y = float(parts[2]);
               float z = float(parts[3]);
               vertices.add(new Vertex(new PVector(x, y, z)));
            }
            
            if (parts[0].equals("vt")) {
               float u = float(parts[1]);
               float v = float(parts[2]);
               textureVertices.add(new PVector(u, v));
            }

            if (parts[0].equals("f")) {
               int numVertices = parts.length - 1;
               ArrayList<Vertex> faceVertices = new ArrayList<Vertex>();
               ArrayList<PVector> faceTextureVertices = new ArrayList<PVector>();
               
               for (int j = 1; j <= numVertices; j++) {
                  String[] vertexInfo = parts[j].split("/");
                  int vertexIndex = int(vertexInfo[0]);
                  int textureVertexIndex = int(vertexInfo[1]);
                  
                  faceVertices.add(vertices.get(vertexIndex - 1));
                  faceTextureVertices.add(textureVertices.get(textureVertexIndex - 1));
               }
                  
               for (int j = 1; j <= numVertices - 2; j++) {
                  Vertex[] faceVertexList = {faceVertices.get(0), faceVertices.get(j), faceVertices.get(j + 1)};
                  PVector[] faceTextureVertexList = {faceTextureVertices.get(0), faceTextureVertices.get(j), faceTextureVertices.get(j + 1)};
                  faces.add(new Face(faceVertexList, faceTextureVertexList));
               }
            }
         }
      }
      
      this.vertices = new Vertex[vertices.size()];
      this.faces = new Face[faces.size()];
      
      for (int i = 0; i < vertices.size(); i++) {
         this.vertices[i] = vertices.get(i);
      }
      for (int i = 0; i < faces.size(); i++) {
         this.faces[i] = faces.get(i);
      }
   }
   
   public Vertex[] getVertices() {
      return vertices;
   }
   
   public Face[] getFaces() {
      return faces;
   }
}