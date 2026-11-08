class ContactModel {
  final String id;
  final String name;
  String message;
  String time;
  final String imagePath;
  final Duration? timeRemainingMatch;
  final String heroTag;
  final bool hasOnlineIndicator;
  final String timeLeft;
  bool isHidden;
  bool isReported;
  int unreadCount;
  bool isMessagesEmpty;

  ContactModel({
    this.isReported = false,
    this.timeRemainingMatch,
    this.isMessagesEmpty = true,
    required this.id,
    required this.name,
    required this.message,
    required this.time,
    required this.imagePath,
    required this.heroTag,
    required this.hasOnlineIndicator,
    required this.timeLeft,
    this.isHidden = false,
    this.unreadCount = 0,
  });

  ContactModel copyWith({
    bool? isReported,
    bool? isMessagesEmpty,
    String? id,
    String? name,
    String? message,
    String? time,
    Duration? timeRemainingMatch,
    bool? isHidden,
    int? unreadCount,
    String? imagePath,
    String? heroTag,
    bool? hasOnlineIndicator,
    String? timeLeft,
  }) {
    return ContactModel(
      isReported: isReported ?? this.isReported,
      isMessagesEmpty: isMessagesEmpty ?? this.isMessagesEmpty,
      id: id ?? this.id,
      name: name ?? this.name,
      message: message ?? this.message,
      time: time ?? this.time,
      timeRemainingMatch: timeRemainingMatch ?? this.timeRemainingMatch,
      isHidden: isHidden ?? this.isHidden,
      unreadCount: unreadCount ?? this.unreadCount,
      imagePath: imagePath ?? this.imagePath,
      heroTag: heroTag ?? this.heroTag,
      hasOnlineIndicator: hasOnlineIndicator ?? this.hasOnlineIndicator,
      timeLeft: timeLeft ?? this.timeLeft,
    );
  }
}
