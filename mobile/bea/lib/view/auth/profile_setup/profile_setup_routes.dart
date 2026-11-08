/// Route names for the "building your profile" flow (part 2).
class ProfileSetupRoutes {
  ProfileSetupRoutes._();

  static const String name = '/bubba/profile/name';
  static const String gender = '/bubba/profile/gender';
  static const String birthday = '/bubba/profile/birthday';
  static const String hometown = '/bubba/profile/hometown';
  static const String height = '/bubba/profile/height';
  static const String religion = '/bubba/profile/religion';
  static const String languages = '/bubba/profile/languages';
  static const String ethnicity = '/bubba/profile/ethnicity';
  static const String education = '/bubba/profile/education';
  static const String work = '/bubba/profile/work';
  static const String lookingFor = '/bubba/profile/looking-for';
  static const String political = '/bubba/profile/political';
  static const String bio = '/bubba/profile/bio';

  static const String icebreakers = '/bubba/profile/icebreakers';
  static const String icebreakerFormat = '/bubba/profile/icebreakers/format';
  static const String icebreakerBrowse = '/bubba/profile/icebreakers/browse';
  static const String icebreakerAnswer = '/bubba/profile/icebreakers/answer';

  static const String photos = '/bubba/profile/photos';
  static const String photoEdit = '/bubba/profile/photos/edit';
  static const String ready = '/bubba/profile/ready';
  static const String editProfile = '/bubba/profile/edit';

  /// The order the flow walks. "Continue" moves one forward, "Go back" pops,
  /// and "Skip" is the same move as Continue without writing an answer.
  static const List<String> order = [
    name,
    gender,
    birthday,
    hometown,
    height,
    religion,
    languages,
    ethnicity,
    education,
    work,
    lookingFor,
    political,
    bio,
    icebreakers,
    photos,
    ready,
  ];

  static String? after(String route) {
    final i = order.indexOf(route);
    if (i == -1 || i + 1 >= order.length) return null;
    return order[i + 1];
  }
}
