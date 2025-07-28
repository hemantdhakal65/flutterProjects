class UserModel {
  final String uid;
  final String? email;
  final String? phone;
  final String? username;
  final DateTime? dob;
  final String? reason;
  final String? customReason;
  final bool isAnonymous;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    this.email,
    this.phone,
    this.username,
    this.dob,
    this.reason,
    this.customReason,
    this.isAnonymous = false,
    this.createdAt,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? phone,
    String? username,
    DateTime? dob,
    String? reason,
    String? customReason,
    bool? isAnonymous,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      dob: dob ?? this.dob,
      reason: reason ?? this.reason,
      customReason: customReason ?? this.customReason,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'phone': phone,
    'username': username,
    'dob': dob?.millisecondsSinceEpoch,
    'reason': reason,
    'customReason': customReason,
    'isAnonymous': isAnonymous,
    'createdAt': createdAt?.millisecondsSinceEpoch,
  };

  static UserModel fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] ?? '',
    email: map['email'],
    phone: map['phone'],
    username: map['username'],
    dob: map['dob'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['dob'])
        : null,
    reason: map['reason'],
    customReason: map['customReason'],
    isAnonymous: map['isAnonymous'] ?? false,
    createdAt: map['createdAt'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
        : null,
  );
}