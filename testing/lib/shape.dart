class Rectangle {
  final int width, height;
  
  Rectangle(this.width, this.height);
    
  int get area => width * height;

   // Use a private variable to 
   // expose the value with a getter; 
   Point _center;
   Point get center => _center;
   set center(Point origin) {
     _center = Point(
       origin.x + width / 2,
       origin.y + height / 2,
     );
   } 
}

void main() {
  var rectangle = Rectangle(12,6);
  print(rectangle.area);
  // The setter will calculate the center based on what we tell it is the
  // _origin_ (top left corner) of the rectangle on a plot.
  // in this case, we're setting the origin at (4,4). 
  rectangle.center = Point(4,4);  
  print(rectangle.cernter);
}