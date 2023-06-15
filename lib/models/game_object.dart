
enum ObjectType { rock, paper, scissors }

class GameObject {
  final int id;
  final ObjectType type;
  double x;
  double y;
  double dx;
  double dy;

  GameObject({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
  });
}