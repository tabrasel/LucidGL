public class Scene {
   
   private ArrayList<Object> objects;
   
   public Scene() {
      objects = new ArrayList<Object>();      
      //objects.add(new Object("fem_teen.txt", new PVector(0, -13, 5)));
      //objects.add(new Object("rose.txt", new PVector(0, -50, 40)));
      //objects.add(new Object("Taxi.txt", new PVector(0, -1, 6)));
      //objects.add(new Object("Cube.txt", new PVector(0, 0, 5)));
      //objects.add(new Object("Poly.txt", new PVector(0, 0, 3)));
      //objects.add(new Object("Table.txt", new PVector(0, 0, 17)));
      
      /*
      for (int z = 3; z < 10; z++) {
         for (int x = -5; x < 5; x++) {
            if (random(1) < 0.1) {
               objects.add(new Object("Cube.txt", new PVector(x * 2, 0, z * 2)));
            }
         }
      }
      */
      ///*
      for (int z = -3; z <= 3; z++) {
         for (int x = -3; x <= 3; x++) {
            objects.add(new Object("Cube.txt", new PVector(x * 2, -2, z * 2)));
            objects.add(new Object("Cube.txt", new PVector(x * 2, 4, z * 2)));
            if (z == -3 || z == 3 || x == -3 || x == 3) {
               objects.add(new Object("Cube.txt", new PVector(x * 2, 0, z * 2)));
            }
         }
      }
      //*/
   }
   
   public void update() {
      for (Object object : objects) {
         object.update();
      }
   }
   
   public ArrayList<Object> getObjects() {
      return objects;
   }
}