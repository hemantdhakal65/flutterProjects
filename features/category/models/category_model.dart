class Category {
  final String id;
  final String name;
  final String icon;
  final String description;
  final bool isPopular;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.isPopular = false,
  });

  @override
  String toString() => name;
}