class VerificationModel {
  final String message;
  final String userId;
  final String token;
  final bool isProfileCompleted;

  VerificationModel({
    required this.message,
    required this.userId,
    required this.token,
    this.isProfileCompleted = false,
  });

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      message: json['message'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      token: json['token'] as String? ?? '',
      isProfileCompleted: json['isProfileCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'token': token,
      'isProfileCompleted': isProfileCompleted,
    };
  }
}
