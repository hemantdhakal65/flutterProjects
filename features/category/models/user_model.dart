class User {
  final String id;
  final String name;
  final String imageUrl;
  final int age;
  final String gender;
  final double distance;
  final double rating;
  final List<String> categories;
  final String bio;
  final bool isOnline;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.age,
    required this.gender,
    required this.distance,
    this.rating = 4.5,
    required this.categories,
    required this.bio,
    this.isOnline = true,
  });
}