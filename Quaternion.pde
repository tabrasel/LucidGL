public class Quaternion {
   float x, y, z, w;
   
   public Quaternion(PVector axis, float radians) {
      w = cos(radians / 2);
      x = axis.x * sin(radians / 2);
      y = axis.y * sin(radians / 2);
      z = axis.z * sin(radians / 2);
   }
   
   public PVector rotateVector(PVector v) {
      PVector u = new PVector();
      u.x = v.x * (x * x + w * w - y * y - z * z) + v.y * (2 * x * y - 2 * w * z) + v.z * (2 * x * z + 2 * w * y);
      u.y = v.x * (2 * w * z + 2 * x * y) + v.y * (w * w - x * x + y * y - z * z)+ v.z * (-2 * w * x + 2 * y * z);
      u.z = v.x * (-2 * w * y + 2 * x * z) + v.y * (2 * w * x + 2 * y * z) + v.z * (w * w - x * x - y * y + z * z);
      return u;
   }
}