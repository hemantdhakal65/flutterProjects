import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String postId;
  final String bookerId;
  final String bookedUserId;
  final String category;
  final DateTime bookingTime;
  final DateTime? meetingTime;
  final String status; // Requested, Accepted, Completed, Cancelled

  Booking({
    required this.id,
    required this.postId,
    required this.bookerId,
    required this.bookedUserId,
    required this.category,
    required this.bookingTime,
    this.meetingTime,
    this.status = 'Requested',
  });

  factory Booking.fromMap(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      postId: data['postId'],
      bookerId: data['bookerId'],
      bookedUserId: data['bookedUserId'],
      category: data['category'],
      bookingTime: (data['bookingTime'] as Timestamp).toDate(),
      meetingTime: data['meetingTime'] != null
          ? (data['meetingTime'] as Timestamp).toDate()
          : null,
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'bookerId': bookerId,
      'bookedUserId': bookedUserId,
      'category': category,
      'bookingTime': Timestamp.fromDate(bookingTime),
      'meetingTime': meetingTime != null ? Timestamp.fromDate(meetingTime!) : null,
      'status': status,
    };
  }
}