class BookingService {
  static Future<bool> createBooking({
    required String userId,
    required String expertId,
    required String date,
    required String time,
    required int people,
    String? specialRequests,
  }) async {
    // In real app, this would call your backend API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}