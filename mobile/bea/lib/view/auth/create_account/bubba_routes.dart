class BubbaRoutes {
  BubbaRoutes._();

  static const String splash = '/bubba/splash';
  static const String landing = '/bubba/landing';
  static const String signingIn = '/bubba/signing-in';
  static const String phone = '/bubba/phone';
  static const String signInPhone = '/bubba/sign-in/phone';
  static const String verifyPhone = '/bubba/verify/phone';
  static const String email = '/bubba/email';
  static const String signInEmail = '/bubba/sign-in/email';
  static const String verifyEmail = '/bubba/verify/email';
  static const String existingAccount = '/bubba/existing-account';
  static const String location = '/bubba/location';
  static const String notifications = '/bubba/notifications';
  static const String accountReady = '/bubba/account-ready';

  static const List<String> all = [
    splash,
    landing,
    signingIn,
    phone,
    signInPhone,
    verifyPhone,
    email,
    signInEmail,
    verifyEmail,
    existingAccount,
    location,
    notifications,
    accountReady,
  ];
}
