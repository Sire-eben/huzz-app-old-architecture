import 'dart:convert';

class UserReferralModel {
  final String id;
  final String referralCode;
  final String userId;
  final int count;
  UserReferralModel({
    required this.id,
    required this.referralCode,
    required this.userId,
    required this.count,
  });

  

  factory UserReferralModel.fromMap(Map<String, dynamic> map) {
    return UserReferralModel(
      id: map['id'] ?? '',
      referralCode: map['referralCode'] ?? '',
      userId: map['userId'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }
}
