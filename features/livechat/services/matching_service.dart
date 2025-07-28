import 'geolocation_service.dart';

class MatchingService {
  static Future<Map<String, dynamic>?> findMatch(
      double currentLat, double currentLon, List<String>? interests) async {
    final List<Map<String, dynamic>> mockUsers = [
      {
        'id': 'user1',
        'name': 'Alex',
        'image': 'https://example.com/alex.jpg',
        'lat': currentLat + 0.001,
        'lon': currentLon + 0.001,
        'interests': ['sports', 'music'],
      },
      {
        'id': 'user2',
        'name': 'Taylor',
        'image': 'https://example.com/taylor.jpg',
        'lat': currentLat + 0.002,
        'lon': currentLon - 0.001,
        'interests': ['books', 'travel'],
      },
    ];

    final nearbyUsers = mockUsers.where((user) {
      final userLat = (user['lat'] as num).toDouble();
      final userLon = (user['lon'] as num).toDouble();

      final distance = GeolocationService.calculateDistance(
        currentLat,
        currentLon,
        userLat,
        userLon,
      );
      return distance <= 5;
    }).toList();

    final filteredUsers = (interests?.isNotEmpty ?? false)
        ? nearbyUsers.where((user) {
      final userInterests = (user['interests'] as List).cast<String>();
      return userInterests.any(interests!.contains);
    }).toList()
        : nearbyUsers;

    return filteredUsers.isNotEmpty ? filteredUsers.first : null;
  }
}