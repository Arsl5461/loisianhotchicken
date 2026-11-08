import 'package:OApp/view/Travel/controller/create_post_controller.dart';
import 'package:OApp/view/messages/controller/chat_controller.dart';
import 'package:OApp/view/profileSetting/EditProfile/edit_controller.dart';
import 'package:OApp/view/profileSetting/Invite/controller/invite_friends_controller.dart';
import 'package:get/get.dart';
import '../Travel/choose_location_controller.dart';
import '../auth/signin_otp/controllers/otp_signin_controller.dart';
import 'dashboard_controller.dart';
import 'package:OApp/controller/home_controller.dart';
import 'package:OApp/controller/your_likes_controller.dart';
import 'package:OApp/view/messages/controller/chat_list_controller.dart';
import 'package:OApp/view/profileSetting/controller/profile_display_controller.dart';
import 'package:OApp/core/dio_service/dio_service.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // NetworkManager dependency
    Get.put<NetworkManager>(NetworkManager(), permanent: true);

    // Use Put instead of lazyPut to ensure singleton behavior
    if (!Get.isRegistered<DashboardController>()) {
      Get.put<DashboardController>(DashboardController(), permanent: true);
    }
    Get.lazyPut<OTPSignInController>(() => OTPSignInController());
    Get.lazyPut<ChatController>(() => ChatController());

    Get.lazyPut<ChooseLocationController>(() => ChooseLocationController());
    Get.lazyPut<CreatePostController>(() => CreatePostController());

    Get.lazyPut<EditController>(() => EditController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<InviteFriendsController>(() => InviteFriendsController());
    Get.lazyPut<YourLikesController>(() => YourLikesController());
    Get.lazyPut<ChatListController>(() => ChatListController());
    Get.lazyPut<ProfileDisplayController>(() => ProfileDisplayController());
  }
}
