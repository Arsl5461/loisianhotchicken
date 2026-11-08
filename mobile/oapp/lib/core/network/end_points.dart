import 'package:OApp/config/app_config.dart';

class EndPoints {
  // Base API path - use getter to always reflect current AppConfig.baseUrl
  static String get baseUrl => '${AppConfig.baseUrl}api/';
  // static const String signup = '${AppConfig.baseUrl}/auth/signup';
  static const String verifyPhone = 'auth/signup';
  static const String verifyUser = 'auth/verifyUser';
  static const String addProfile = 'user/addProfile';
  static const String getUser = 'user/getUser';
  static const String updateLoginMethods = 'user/updateLoginMethods';
  static const String getUsers = 'user/getUsersByIds';
  static const String getIceBreakers = "icebreaker";
  static const String createIceBreaker = "icebreaker/create";
  static const String updateLocation = 'user/updateLocation';
  static const String userPosts = 'user/findMatches';
  static const String userPostsV2 = 'user/findMatchesV2';
  static const String createPost = 'travel/createPost';
  static const String getPost = 'travel/posts';
  static const String getCitiesPost = 'travel/cities';
  static const String searchCities = 'travel/cities/search';
  static const String nearbyCities = 'travel/cities/nearby';
  static const String preferences = "preferences/";
  static const String searchDestinations = 'travel/destinations/search';
  static const String nearbyDestinations = 'travel/destinations/nearby';
  static String destination(String cityId) => 'travel/destinations/$cityId';
  static const String updateLocationTravel = 'user/updateLocationTravel';
  static const String toggleTravelMode = 'user/toggleTravelMode';
  static const String pauseAccount = 'user/pauseAccount';
  static const String deleteUser = 'user/deleteUser';
  static const String privacySettings = 'user/privacySettings';
  static const String notificationPreferences = 'user/notificationPreferences';
  static const String supportTickets = 'support/tickets';
  static const String helpContent = 'content/help';
  static const String legalDocument = 'content/legal';
  static const String blockedUsers = 'safety/blockedUsers';
  static const String blockUser = 'safety/blockUser';
  static const String unblockUser = 'safety/unblockUser';
  static const String reportUser = 'safety/reportUser';
  static const String requestPhoneChange = 'user/changePhone/request';
  static const String confirmPhoneChange = 'user/changePhone/confirm';
  static const String requestEmailChange = 'user/changeEmail/request';
  static const String confirmEmailChange = 'user/changeEmail/confirm';
  static const String recoveryEmail = 'user/recoveryEmail';
  static const String paymentMethods = 'payment/methods';
  static const String paymentPlans = 'payment/plans';
  static String paymentMethod(String id) => 'payment/methods/$id';
  static String defaultPaymentMethod(String id) =>
      'payment/methods/$id/default';
  static const String purchaseHistory = 'payment/history';
  static String purchaseDetail(String id) => 'payment/history/$id';
  static const String subscription = 'payment/subscription';
  static const String cancelSubscription = 'payment/subscription/cancel';
  static const String resumeSubscription = 'payment/subscription/resume';
  static String getCitiesPostCityID(String cityId) =>
      'travel/posts/city/$cityId';
  static String setLikeByUserId(String postId) => 'travel/posts/$postId/like';
  static String setViewByUserId(String postId) => 'travel/posts/$postId/view';
  static String setComments(String postId) => 'travel/posts/$postId/comments';
  static String getPostsByUserId(String userId) => 'travel/posts/user/$userId';
  static const String signIn = 'auth/signIn';
  static const String loginWithKeys = 'auth/loginWithKeys';
  static const String verifySignIn = 'auth/verifySignIn';
  static const String referralOverview = 'referrals/me';
  static const String referralStats = 'referrals/me/stats';
  static const String referralRewards = 'referrals/me/rewards';
  static String referralRewardsQuery({
    bool claimableOnly = false,
    String? status,
  }) {
    final query = <String, String>{};

    if (claimableOnly) {
      query['claimableOnly'] = 'true';
    }
    if (status != null && status.trim().isNotEmpty) {
      query['status'] = status.trim();
    }

    if (query.isEmpty) {
      return referralRewards;
    }

    return Uri(path: referralRewards, queryParameters: query).toString();
  }

  static String claimReferralReward(String rewardId) =>
      'referrals/me/rewards/$rewardId/claim';
  static const String like = 'match/like';
  static const String unlike = 'match/dislike';
  static const String matches = 'match/my-matches';
  static updateMatch(String matchId) => 'match/update/$matchId';
  static String matchesSingle(String userId) => 'match/my-matches/$userId';
  static const String pendingLikes = 'match/pending-likes';
  static const String likesBystatus = 'match/likes-by-status';
  static const String createMatch = 'match/create';
  static const String unMatch = 'match/unmatch';

  static const String chatHistory = 'chat/history';
  static String chatHistoryCursor(String targetUserId) =>
      'chat/history/$targetUserId/cursor';
  static const String updateProfile = 'user/updateProfile';
  static const String createCheckoutSession = 'payment/create-checkout-session';
  static const String createPaymentSheet = 'payment/create-payment-sheet';
  static const String confirmPaymentSheet = 'payment/confirm-payment-sheet';
}
