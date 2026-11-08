import 'package:OApp/view/messages/controller/chat_controller.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController(), permanent: false);
  }
}
