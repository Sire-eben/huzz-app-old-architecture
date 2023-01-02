class UserTeamInviteModel {
  final String id;
  final String referralCode;
  final String userId;
  final int count;
  UserTeamInviteModel({
    required this.id,
    required this.referralCode,
    required this.userId,
    required this.count,
  });

  factory UserTeamInviteModel.fromMap(Map<String, dynamic> map) {
    return UserTeamInviteModel(
      id: map['id'] ?? '',
      referralCode: map['referralCode'] ?? '',
      userId: map['userId'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }
}
