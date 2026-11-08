import 'package:OApp/view/profileSetting/EditProfile/Profile/set_location.dart';
import 'package:OApp/view/profileSetting/settings/bindings/premium_upgrade_bindings.dart';
import 'package:OApp/view/profileSetting/settings/bindings/settings_bindings.dart';
import 'package:OApp/view/profileSetting/settings/bindings/login_methods_bindings.dart';
import 'package:get/get.dart';
import '../../view/ProfileMaking/bindings/profile_making_bindings.dart';
import '../../view/SplashScreen/bindings/splash_screen_bindings.dart';
import '../../view/Travel/bindings/create_post_bindings.dart';
import '../../view/Travel/bindings/travel_posts_viewer_binding.dart';
import '../../view/auth/bindings/account_setup_bindings.dart';
import '../../view/messages/bindings/chat_bindings.dart';
import '../../view/preferences/choice_list_screens.dart';
import '../../view/preferences/choose_destination_screen.dart';
import '../../view/preferences/destination_sheet_screen.dart';
import '../../view/preferences/height_screens.dart';
import '../../view/preferences/map_screens.dart';
import '../../view/preferences/bubba_prefs_controller.dart';
import '../../view/preferences/prefs_hub_screen.dart';
import '../../view/preferences/range_screens.dart';
import '../../view/preferences/prefs_v2_hub_screen.dart';
import '../../view/preferences/welcome_city_screen.dart';
import '../../view/settings/accordion_screens.dart';
import '../../view/settings/apple_account_screens.dart';
import '../../view/settings/blocked_users_screen.dart';
import '../../view/settings/connected_accounts_screen.dart';
import '../../view/settings/face_id_screen.dart';
import '../../view/settings/hide_from_contacts_screen.dart';
import '../../view/settings/phone_number_screens.dart';
import '../../view/settings/privacy_choice_screens.dart';
import '../../view/settings/privacy_settings_screen.dart';
import '../../view/settings/read_receipts_screen.dart';
import '../../view/settings/recovery_email_screens.dart';
import '../../view/settings/security_privacy_hub_screen.dart';
import '../../view/settings/unblock_screens.dart';
import '../../view/settings/add_card_screen.dart';
import '../../view/settings/card_detail_screen.dart';
import '../../view/settings/delete_account_screen.dart';
import '../../view/settings/document_screens.dart';
import '../../view/settings/emergency_resources_screen.dart';
import '../../view/settings/invitation_link_screen.dart';
import '../../view/settings/invite_modal_screen.dart';
import '../../view/settings/landing_status_screens.dart';
import '../../view/settings/membership_screen.dart';
import '../../view/settings/notification_type_screen.dart';
import '../../view/settings/notifications_screen.dart';
import '../../view/settings/order_details_screen.dart';
import '../../view/settings/pause_account_screen.dart';
import '../../view/settings/payment_methods_screen.dart';
import '../../view/settings/plan_screens.dart';
import '../../view/settings/purchase_history_screen.dart';
import '../../view/settings/settings_hub_screen.dart';
import '../../view/settings/support_screens.dart';
import '../../view/settings/technical_issue_screens.dart';
import 'app_routes.dart';

// Bubba redesigned auth flow
import 'package:OApp/view/auth/create_account/bubba_splash_view.dart';
import 'package:OApp/view/auth/create_account/bubba_flow_pages.dart';
import 'package:OApp/view/auth/profile_setup/profile_setup_pages.dart';

// Auth Flow imports
import 'package:OApp/view/auth/signup/signup.dart';
import 'package:OApp/view/auth/login/views/login_screen.dart';
import 'package:OApp/view/auth/login/bindings/login_binding.dart';
import 'package:OApp/view/auth/phoneVerification/views/phone_verification_screen.dart';
import 'package:OApp/view/auth/phoneVerification/bindings/phone_verification_binding.dart';
import 'package:OApp/view/auth/otp_verification/views/otp_verification_screen.dart';
import 'package:OApp/view/auth/otp_verification/bindings/otp_verification_binding.dart';
import 'package:OApp/view/auth/signin_otp/views/otp_signin_screen.dart';
import 'package:OApp/view/auth/signin_otp/bindings/otp_signin_binding.dart';
import 'package:OApp/view/auth/account_setup/account_setup.dart';
import 'package:OApp/view/auth/loaction%20picker/loaction_setup.dart';
import 'package:OApp/view/auth/notification_setup/notification_setup.dart';
import 'package:OApp/view/auth/terms/terms_and_guidelines.dart';
import 'package:OApp/view/auth/signup/email_screen.dart';

// Profile Making Flow imports
import 'package:OApp/view/ProfileMaking/Name/name_asking.dart';
import 'package:OApp/view/ProfileMaking/GenderSpecification/GenderSelection.dart';
import 'package:OApp/view/ProfileMaking/AgePicker/agepicker.dart';
import 'package:OApp/view/ProfileMaking/Hometown/hometown_screen.dart';
import 'package:OApp/view/ProfileMaking/HeightPicker/height_picker.dart';
import 'package:OApp/view/ProfileMaking/AddressPicker/address_picker.dart';
import 'package:OApp/view/ProfileMaking/ReligiousViews/religious_views.dart';
import 'package:OApp/view/ProfileMaking/LanguageSelection/language_selection.dart';
import 'package:OApp/view/ProfileMaking/EthnicitySelection/ethnicity_selection.dart';
import 'package:OApp/view/ProfileMaking/EducationSelection/education_selection.dart';
import 'package:OApp/view/ProfileMaking/JobSelection/job_selection.dart';
import 'package:OApp/view/ProfileMaking/SocialMedia/social_media.dart';
import 'package:OApp/view/ProfileMaking/LifestyleHabits/lifestyle_habits.dart';
import 'package:OApp/view/ProfileMaking/Politics/politics_screen.dart';
import 'package:OApp/view/ProfileMaking/Icebreakers/icebreakers_screen.dart';
import 'package:OApp/view/ProfileMaking/PromptSelection/prompt_selection_screen.dart';
import 'package:OApp/view/ProfileMaking/PromptAnswer/prompt_answer_screen.dart';
import 'package:OApp/view/ProfileMaking/ImageSelection/ImageSelection.dart';
import 'package:OApp/view/ProfileMaking/ProfileComplete/profile_complete.dart';

// Edit Profile imports
import 'package:OApp/view/profileSetting/EditProfile/edit_profile_binding.dart';
import 'package:OApp/view/profileSetting/EditProfile/Editprofile.dart';

// Main App Screen imports
import 'package:OApp/view/Dashboard/dashboard_screen.dart';
import 'package:OApp/view/Dashboard/dashboard_binding.dart';
import 'package:OApp/view/HomeScreen/send_like_screen.dart';
import 'package:OApp/view/HomeScreen/reply_prompt_screen.dart';
import 'package:OApp/view/messages/Chat_list.dart';
import 'package:OApp/view/messages/hidden_chats_page.dart';

// Travel Screen imports
import 'package:OApp/view/Travel/travel_preferences_screen.dart';
import 'package:OApp/view/Travel/locations_modal_screen.dart';
import 'package:OApp/view/Travel/location_picker_screen.dart';
import 'package:OApp/view/Travel/stories/travel_story_picker_screen.dart';
import 'package:OApp/view/Travel/stories/travel_post_screen.dart';
import 'package:OApp/view/Travel/stories/viewer/story_profile_screen.dart';
import 'package:OApp/view/Travel/stories/Create_posts/create_post_screen.dart';
import 'package:OApp/view/Travel/stories/Create_posts/post_image_editor_screen.dart';
import 'package:OApp/view/Travel/stories/Create_posts/post_editor_screen.dart';
import 'package:OApp/view/Travel/travel_posts_viewer_screen.dart';

// Profile Setting imports
import 'package:OApp/view/profileSetting/DatingPrefernecs/datingprefererncemain.dart';
import 'package:OApp/view/profileSetting/DatingPrefernecs/bindings/dating_preferences_binding.dart';
import 'package:OApp/view/profileSetting/DatingPrefernecs/ethniccity-prefernces.dart';
import 'package:OApp/view/profileSetting/DatingPrefernecs/height-preference.dart';
import 'package:OApp/view/profileSetting/DatingPrefernecs/language-prefernces.dart';
import 'package:OApp/view/profileSetting/DatingPrefernecs/religious-preference.dart';
import 'package:OApp/view/profileSetting/DatingPrefernecs/education-preference.dart';
import 'package:OApp/view/profileSetting/DatingPrefernecs/gender_preference.dart';
import 'package:OApp/view/profileSetting/DatingPrefernecs/location_preference.dart';
import 'package:OApp/view/profileSetting/DatingPrefernecs/politics-preference.dart';
import 'package:OApp/view/profileSetting/EditProfile/Basics/EditNameScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Basics/EditHometownScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Basics/EditLanguagesScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Basics/EditLocationScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Basics/EditWorkScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Basics/EditBirthdayScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Basics/EditEducationScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Physical/EditEthnicityScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Physical/EditHeightScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Extra/EditPoliticsScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Extra/EditReligionScreen.dart';
import 'package:OApp/view/profileSetting/EditProfile/Physical/EditGenderScreen.dart';
import 'package:OApp/view/profileSetting/Invite/invite_friends.dart';
import 'package:OApp/view/profileSetting/Invite/bindings/invite_friends_binding.dart';
import 'package:OApp/view/profileSetting/Invite/bindings/referral_rewards_binding.dart';
import 'package:OApp/view/profileSetting/Invite/referral_rewards_screen.dart';
import 'package:OApp/view/profileSetting/Suggesstions/suggesstion.dart';

// Settings imports
import 'package:OApp/view/profileSetting/settings/ContactusFaq/contactus/contactUs.dart';
import 'package:OApp/view/profileSetting/settings/ContactusFaq/advertising_info.dart';
import 'package:OApp/view/profileSetting/settings/ask_general_question_screen.dart';
import 'package:OApp/view/profileSetting/settings/strictly_necessary.dart';
import 'package:OApp/view/profileSetting/settings/login_methods.dart';
import 'package:OApp/view/profileSetting/settings/privacy_settings.dart';
import 'package:OApp/view/profileSetting/settings/privacy_settings_detail.dart';
import 'package:OApp/view/profileSetting/settings/premium_upgrade.dart';
import 'package:OApp/view/profileSetting/settings/billing_screen.dart';
// Note: SecurityAndPrivacyScreen is likely in privacy_settings.dart or similar.

// Core imports

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // Message Routes
    GetPage(
      name: Routes.CHAT,
      page: () {
        return ChatScreen();
      },

      binding: ChatBinding(),
    ),
    GetPage(name: Routes.HIDDEN_CHATS, page: () => const HiddenChatsPage()),

    // Travel Routes
    GetPage(
      name: Routes.TRAVEL_PREFERENCES,
      page: () => const TravelPreferencesScreen(),
    ),
    GetPage(
      name: Routes.NEW_TRAVEL,
      page: () => DashboardScreen(),
      bindings: [DashboardBinding(), ChatBinding()],
    ),
    GetPage(name: Routes.LOCATIONS_MODAL, page: () => LocationsModalScreen()),

    GetPage(name: Routes.TRAVEL_POST, page: () => const TravelPostScreen()),
    GetPage(
      name: Routes.TRAVEL_POSTS_VIEWER,
      page: () => const TravelPostsViewerScreen(),
      binding: TravelPostsViewerBinding(),
    ),
    GetPage(
      name: Routes.TRAVEL_LOCATION_PICKER,
      page: () => const LocationPickerScreen(),
    ),
    GetPage(
      name: Routes.TRAVEL_STORY_PICKER,
      page: () => const TravelStoryPickerScreen(),
    ),
    GetPage(
      name: Routes.SET_LOCATION,
      page: () => const SetLocationScreen(),
      binding: ProfileMakingBindings(),
    ),
    GetPage(
      name: Routes.STORY_PROFILE,
      page: () => const TravelPostDetailScreen(),
    ),
    GetPage(
      name: Routes.CREATE_POST,
      page: () => const CreatePostScreen(),
      binding: CreatePostBindings(),
    ),
    GetPage(
      name: Routes.POST_EDITOR,
      binding: CreatePostBindings(),
      page: () {
        return PostEditorScreen();
      },
    ),
    GetPage(
      name: Routes.POST_IMAGE_EDITOR,
      binding: CreatePostBindings(),
      page: () => const PostImageEditorScreen(),
    ),

    // Edit Profile Routes
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => EditProfilePage(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_NAME,
      page: () {
        final currentValue = Get.arguments as String?;
        return EditNameScreen(currentValue: currentValue);
      },
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_HOMETOWN,
      page: () {
        return EditHometownScreen();
      },
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_LANGUAGES,
      page: () {
        return EditLanguagesScreen();
      },
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_ETHNICITY,
      page: () {
        return EditEthnicityScreen();
      },
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_LOCATION,
      page: () => EditLocationScreen(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_WORK,
      page: () {
        return EditWorkScreen();
      },
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_BIRTHDAY,
      page: () => EditBirthdayScreen(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_HEIGHT,
      page: () {
        return EditHeightScreen();
      },
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_EDUCATION,
      page: () {
        return EditEducationScreen();
      },
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.EDIT_RELIGION,
      page: () {
        return EditReligionScreen();
      },
    ),
    GetPage(
      name: Routes.EDIT_GENDER,
      page: () {
        return EditGenderScreen();
      },
    ),
    GetPage(
      name: Routes.EDIT_POLITICS,
      page: () {
        return EditPoliticsScreen();
      },
    ),

    // Preference Routes
    GetPage(
      name: Routes.PREFERENCE_MAIN,
      page: () => const DatingPreferencesMain(),
      binding: DatingPreferencesBinding(),
    ),
    GetPage(name: Routes.HEIGHT_PREFERENCE, page: () => HeightPreference()),
    GetPage(name: Routes.POLITICS_PREFERENCE, page: () => PoliticsPreference()),
    GetPage(
      name: Routes.RELIGIOUS_PREFERENCE,
      page: () => ReligiousPreference(),
    ),
    GetPage(
      name: Routes.LANGUAGE_PREFERENCE,
      page: () => LanguagePreferences(),
    ),
    GetPage(
      name: Routes.ETHNICITY_PREFERENCE,
      page: () => EthnicityPreferences(),
    ),
    GetPage(
      name: Routes.EDUCATION_PREFERENCE,
      page: () => EducationPreference(),
    ),
    GetPage(
      name: Routes.GENDER_PREFERENCE,
      page: () => const GenderPreferencePage(),
    ),
    GetPage(
      name: Routes.LOCATION_PREFERENCE,
      page: () => const LocationPreferencePage(),
    ),

    // Settings Routes

    // Bubba part 4 - Dating Preferences
    GetPage(
      name: Routes.BUBBA_PREFS_HUB,
      page: () => const BubbaPrefsHubScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_SUMMARY,
      page: () => const BubbaPrefsSummaryHubScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_CHOICE,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return BubbaPrefsChoiceScreen(
          title: args?['title'] as String? ?? 'Ethnicity',
          kind: (args?['kind'] as PrefsFilterKind?) ??
              PrefsFilterKind.ethnicity,
          options: (args?['options'] as List<String>?) ?? prefsEthnicityOptions,
        );
      },
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_MULTI,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return BubbaPrefsMultiChoiceScreen(
          title: args?['title'] as String? ?? 'Ethnicity',
          intro: args?['intro'] as String? ??
              'Select the ethnicities you’re\nopen to in a match.',
          options: (args?['options'] as List<String>?) ?? prefsEthnicityMulti,
          kind: (args?['kind'] as PrefsFilterKind?) ??
              PrefsFilterKind.ethnicity,
        );
      },
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_LOOKING_FOR,
      page: () => const BubbaPrefsLookingForScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_DISTANCE,
      page: () => const BubbaPrefsDistanceScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_ADJUST_DISTANCE,
      page: () => const BubbaPrefsAdjustDistanceScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_AGE_RANGE,
      page: () => const BubbaPrefsAgeRangeScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_AGE_SLIDER,
      page: () => const BubbaPrefsAgeSliderScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_HEIGHT,
      page: () => const BubbaPrefsHeightScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_DESTINATION_SHEET,
      page: () => const BubbaPrefsDestinationSheetScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_CHOOSE_DESTINATION,
      page: () => const BubbaPrefsChooseDestinationScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_CONFIRM_DESTINATION,
      page: () => const BubbaPrefsConfirmDestinationScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_CHOOSE_LOCATION,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return BubbaPrefsChooseLocationScreen(
          radius: args?['radius'] == true,
          pickDestination: args?['pickDestination'] == true,
        );
      },
    ),
    GetPage(
      name: Routes.BUBBA_PREFS_WELCOME_CITY,
      page: () => const BubbaPrefsWelcomeCityScreen(),
    ),

    // Bubba part 5 - Security and Privacy Settings
    GetPage(
      name: Routes.BUBBA_SECURITY_PRIVACY,
      page: () => const BubbaSecurityPrivacyScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_CONNECTED_ACCOUNTS,
      page: () => const BubbaConnectedAccountsScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_FACE_ID,
      page: () => const BubbaFaceIdScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_BLOCKED_USERS,
      page: () => const BubbaBlockedUsersScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_CONFIRM_UNBLOCK,
      page: () => const BubbaConfirmUnblockScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PHONE_NUMBER,
      page: () => const BubbaPhoneNumberScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_CHANGE_PHONE_NUMBER,
      page: () => const BubbaChangePhoneNumberScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_ADD_RECOVERY_EMAIL,
      page: () => const BubbaAddRecoveryEmailScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_RECOVERY_EMAIL,
      page: () => const BubbaRecoveryEmailScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_CHANGE_EMAIL,
      page: () => const BubbaChangeEmailScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_REMOVE_EMAIL,
      page: () => const BubbaRemoveEmailScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_CONNECT_APPLE,
      page: () => const BubbaConnectAppleScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_APPLE_ACCOUNT,
      page: () => const BubbaAppleAccountScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_DISCONNECT_APPLE,
      page: () => const BubbaDisconnectAppleScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PRIVACY_SETTINGS,
      page: () => const BubbaPrivacySettingsScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PROFILE_VISIBILITY,
      page: () => const BubbaProfileVisibilityScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_LAST_ACTIVE_STATUS,
      page: () => const BubbaLastActiveStatusScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_READ_RECEIPTS,
      page: () => const BubbaReadReceiptsScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_HIDE_FROM_CONTACTS,
      page: () => const BubbaHideFromContactsScreen(),
    ),

    // Bubba part 3 - Account Settings
    GetPage(
      name: Routes.BUBBA_MEMBERSHIP,
      page: () => const BubbaMembershipScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_CHANGE_PLAN,
      page: () => const BubbaChangePlanScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PLAN_CONFIRM,
      page: () {
        final extra = Get.arguments as Map<String, dynamic>?;
        return BubbaUpgradeConfirmScreen(
          planType: extra?['planType'] as String? ?? 'premium',
          planName: extra?['planName'] as String?,
          price: extra?['price'] as String?,
          downgrade: extra?['downgrade'] == true,
        );
      },
    ),
    GetPage(
      name: Routes.BUBBA_CANCEL_SUBSCRIPTION,
      page: () => BubbaCancelSubscriptionScreen(
        cancelled: (Get.arguments as Map<String, dynamic>?)?['cancelled'] == true,
      ),
    ),
    GetPage(
      name: Routes.BUBBA_PURCHASE_HISTORY,
      page: () => const BubbaPurchaseHistoryScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_ORDER_DETAILS,
      page: () => const BubbaOrderDetailsScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PAYMENT_METHODS,
      page: () => const BubbaPaymentMethodsScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_CARD_DETAIL,
      page: () => const BubbaCardDetailScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_ADD_CARD,
      page: () => const BubbaAddCardScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_BILLING_ADDRESS,
      page: () => const BubbaBillingAddressScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_INVITATION_LINK,
      page: () => const BubbaInvitationLinkScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_INVITE_MODAL,
      page: () => const BubbaInviteModalScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PAUSE_ACCOUNT,
      page: () => const BubbaPauseAccountScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PAUSE_CONFIRM,
      page: () => const BubbaPauseConfirmScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_DELETE_ACCOUNT,
      page: () => const BubbaDeleteAccountScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_DELETE_CONFIRM,
      page: () => const BubbaDeleteConfirmScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_LOGGED_OUT_LANDING,
      page: () => const BubbaLoggedOutLandingScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_DELETED_LANDING,
      page: () => const BubbaDeletedLandingScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PAUSED_LANDING,
      page: () => const BubbaPausedLandingScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_TECHNICAL_ISSUE,
      page: () => const BubbaTechnicalIssueScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_REPORT_SUBMITTED,
      page: () => const BubbaReportSubmittedScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_SAFETY_CENTRE,
      page: () => const BubbaSafetyCentreScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_SAFETY_TIPS,
      page: () => const BubbaSafetyTipsScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_PROTECT_INFORMATION,
      page: () => const BubbaProtectInformationScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_EMERGENCY_RESOURCES,
      page: () => const BubbaEmergencyResourcesScreen(),
    ),
    GetPage(name: Routes.BUBBA_LEGAL, page: () => const BubbaLegalScreen()),
    GetPage(
      name: Routes.BUBBA_COMMUNITY_GUIDELINES,
      page: () => const BubbaCommunityGuidelinesScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_COOKIE_POLICY,
      page: () => const BubbaCookiePolicyScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_LICENSES,
      page: () => const BubbaLicensesScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_FAQ_EXPANDED,
      page: () => const BubbaFaqExpandedScreen(),
    ),
    GetPage(
      name: Routes.BUBBA_CONTACT_SUPPORT,
      page: () => const BubbaContactSupportScreen(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS_PAGE,
      page: () => const BubbaNotificationsScreen(),
    ),
    GetPage(
      name: Routes.LOGIN_METHODS,
      page: () => const LoginMethodsScreen(),
      binding: LoginMethodsBindings(),
    ),
    GetPage(
      name: Routes.NOTIFICATION_IN_APP,
      page: () {
        final extra = Get.arguments as Map<String, dynamic>?;
        final category = extra?['category'] as String? ?? 'Notifications';
        return BubbaNotificationTypeScreen(category: category);
      },
    ),
    GetPage(name: Routes.CONTACT_US, page: () => ContactUsScreen()),
    GetPage(
      name: Routes.INVITE_FRIENDS,
      page: () => const InviteFriendsScreen(),
      binding: InviteFriendsBinding(),
    ),
    GetPage(
      name: Routes.REFERRAL_REWARDS,
      page: () => const ReferralRewardsScreen(),
      binding: ReferralRewardsBinding(),
    ),
    GetPage(
      name: Routes.STRICTLY_NECESSARY,
      page: () => const StrictlyNecessaryScreen(),
    ),
    GetPage(
      name: Routes.ASK_GENERAL_QUESTION,
      page: () => const AskGeneralQuestionScreen(),
    ),
    GetPage(
      name: Routes.CONTACT_AND_FAQ,
      page: () => const BubbaSupportScreen(),
    ),
    GetPage(name: Routes.FAQ, page: () => const BubbaFaqScreen()),
    GetPage(
      name: Routes.TERMS_OF_SERVICE,
      page: () => const BubbaTermsOfServiceScreen(),
    ),
    GetPage(
      name: Routes.PRIVACY_POLICY_PAGE,
      page: () => const BubbaPrivacyPolicyScreen(),
    ),
    GetPage(
      name: Routes.ADVERTISING_INFO,
      page: () => const AdvertisingInfoScreen(),
    ),
    GetPage(
      name: Routes.PRIVACY_SETTINGS,
      page: () => const PrivacySettingsScreen(),
    ),
    GetPage(
      name: Routes.PREMIUM_UPGRADE,
      page: () => const PremiumUpgradeScreen(),
      binding: PremiumUpgradeBindings(),
    ),

    GetPage(
      name: Routes.SECURITY_AND_PRIVACY,
      page: () => const SecurityAndPrivacyScreen(),
    ),
    GetPage(name: Routes.BILLING, page: () => const BillingScreen()),
    GetPage(name: Routes.SUGGESTIONS, page: () => const SuggestionsScreen()),
    GetPage(name: Routes.SUPPORT, page: () => const BubbaSupportScreen()),
    // GetPage(name: Routes.NOTIFICATION, page: () => NotificationsScreen()),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const BubbaSettingsScreen(),
      binding: SettingsBindings(),
    ),

    // Splash
    GetPage(
      name: Routes.SPLASH,
      page: () => const BubbaSplashView(),
      binding: OappSplashBinding(),
    ),

    // Auth Flow
    GetPage(
      name: Routes.OPTION_SCREEN,
      page: () => const BubbaLandingPage(),
    ),
    ...bubbaFlowPages,
    ...profileSetupPages,
    GetPage(
      name: Routes.SIGNUP,
      page: () => EmailInputPageEnhanced(),
      //binding: OappSplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.PHONE_VERIFICATION,
      page: () => const PhoneVerificationScreen(),
      binding: PhoneVerificationBinding(),
    ),
    GetPage(
      name: Routes.OTP_VERIFICATION,
      page: () => const OTPVerificationScreen(),
      binding: OTPVerificationBinding(),
    ),
    GetPage(
      name: Routes.SIGNIN_OTP,
      page: () => const OTPSignInScreen(),
      binding: OTPSignInBinding(),
    ),
    GetPage(
      name: Routes.ACCOUNT_SETUP,
      page: () => AccountSetupPage(),
      binding: AccountSetupBinding(),
    ),
    GetPage(
      name: Routes.LOCATION_SETUP,
      page: () => const LocationSetupPage(),
      binding: ProfileMakingBindings(),
    ),
    GetPage(
      name: Routes.NOTIFICATION_SETUP,
      page: () => const NotificationSetupPage(),
    ),
    GetPage(
      name: Routes.TERMS_AND_GUIDELINES,
      page: () => const TermsAndGuidelinesPage(),
    ),
    GetPage(
      name: Routes.EMAIL,
      page: () => EmailScreen(),
      binding: ProfileMakingBindings(),
    ),

    // Profile Making Flow
    GetPage(name: Routes.NAME_ASKING, page: () => NameAskingScreen()),
    GetPage(
      name: Routes.GENDER_SELECTION,
      page: () => const GenderSelectionPage(),
    ),
    GetPage(name: Routes.AGE_PICKER, page: () => const AgePickerPage()),
    GetPage(
      name: Routes.HOMETOWN,
      page: () => HometownScreen(),
      binding: ProfileMakingBindings(),
    ),
    GetPage(name: Routes.HEIGHT_PICKER, page: () => const HeightPickerPage()),
    GetPage(name: Routes.ADDRESS_PICKER, page: () => const AddressPickerPage()),
    GetPage(
      name: Routes.RELIGIOUS_VIEWS,
      page: () => ReligiousViewsScreen(),
      binding: ProfileMakingBindings(),
    ),
    GetPage(
      name: Routes.LANGUAGE_SELECTION,
      page: () => LanguageSelectionScreen(),
    ),
    GetPage(
      name: Routes.ETHNICITY_SELECTION,
      page: () => EthnicitySelectionScreen(),
    ),
    GetPage(
      name: Routes.EDUCATION_SELECTION,
      page: () => EducationSelectionScreen(),
    ),
    GetPage(name: Routes.JOB_SELECTION, page: () => JobSelectionScreen()),
    GetPage(name: Routes.SOCIAL_MEDIA, page: () => SocialMediaScreen()),
    GetPage(name: Routes.LIFESTYLE_HABITS, page: () => LifestyleHabitsScreen()),
    GetPage(name: Routes.POLITICS, page: () => PoliticsScreen()),
    GetPage(name: Routes.ICEBREAKERS, page: () => IcebreakersScreen()),
    GetPage(name: Routes.PROMPT_SELECTION, page: () => PromptSelectionScreen()),
    GetPage(
      name: Routes.PROMPT_ANSWER,
      page: () {
        final prompt = Get.arguments as String? ?? "This is prompt number 1";
        return PromptAnswerScreen(prompt: prompt);
      },
    ),
    GetPage(name: Routes.IMAGE_SELECTION, page: () => PhotoSelectionScreen()),
    GetPage(
      name: Routes.PROFILE_COMPLETE,
      page: () => ProfileCompleteScreen(),
      binding: DashboardBinding(),
    ),

    // Standalone
    GetPage(
      name: Routes.SEND_LIKE,
      page: () {
        final Map<String, String?>? extra =
            Get.arguments as Map<String, String?>?;
        return SendLikeScreen(
          profileName: extra?['profileName'] ?? '',
          imageUrl: extra?['imageUrl'] ?? '',
        );
      },
    ),
    GetPage(
      name: Routes.REPLY_PROMPT,
      page: () {
        final Map<String, String?>? extra =
            Get.arguments as Map<String, String?>?;
        return ReplyPromptScreen(
          profileName: extra?['profileName'] ?? '',
          promptLabel: extra?['promptLabel'] ?? '',
          promptText: extra?['promptText'] ?? '',
        );
      },
    ),

    // Main Shell Routes (Wrapped in DashboardScreen)
    GetPage(
      name: Routes.HOME,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.BUMBLE_HOME,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.MATCHES,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.TRAVEL,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.CHOOSE_LOCATION,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.MESSAGES,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
  ];
}
