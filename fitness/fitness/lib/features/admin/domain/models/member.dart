import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String id; // Firestore document ID
  final String memberId; // Custom ID: Pin-2026-000
  final String name;
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String membershipPlan; // Basic, Pro, Elite
  final String status; // Active, Inactive, Suspended
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastCheckIn;
  final int totalWorkouts;

  Member({
    required this.id,
    required this.memberId,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.membershipPlan,
    required this.status,
    this.avatarUrl,
    required this.createdAt,
    this.lastCheckIn,
    this.totalWorkouts = 0,
  });

  Member copyWith({
    String? id,
    String? memberId,
    String? name,
    String? username,
    String? email,
    String? password,
    String? phoneNumber,
    String? membershipPlan,
    String? status,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastCheckIn,
    int? totalWorkouts,
  }) {
    return Member(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      membershipPlan: membershipPlan ?? this.membershipPlan,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memberId': memberId,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'membershipPlan': membershipPlan,
      'status': status,
      'avatarUrl': avatarUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastCheckIn': lastCheckIn != null ? Timestamp.fromDate(lastCheckIn!) : null,
      'totalWorkouts': totalWorkouts,
    };
  }

  factory Member.fromMap(String id, Map<String, dynamic> map) {
    return Member(
      id: id,
      memberId: map['memberId'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      membershipPlan: map['membershipPlan'] ?? 'Basic',
      status: map['status'] ?? 'Active',
      avatarUrl: map['avatarUrl'],
      createdAt: (map['createdAt'] is Timestamp) 
          ? (map['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
      lastCheckIn: map['lastCheckIn'] != null && map['lastCheckIn'] is Timestamp
          ? (map['lastCheckIn'] as Timestamp).toDate() 
          : null,
      totalWorkouts: map['totalWorkouts'] ?? 0,
    );
  }
}
