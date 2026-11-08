import 'package:OApp/data/repositories/referral_repository.dart';
import 'package:OApp/models/referral_overview_model.dart';
import 'package:OApp/utils/toast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteFriendsController extends GetxController {
  final ReferralRepository _referralRepo = Get.find<ReferralRepository>();

  final RxBool isLoading = false.obs;
  final Rxn<ReferralOverviewData> referralData = Rxn<ReferralOverviewData>();
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferralOverview();
  }

  Future<void> fetchReferralOverview() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final overview = await _referralRepo.fetchOverview();

      if (overview != null) {
        referralData.value = overview;
      } else {
        errorMessage.value = 'Failed to load referral details';
      }
    } catch (_) {
      errorMessage.value =
          'Something went wrong while loading referral details.';
    } finally {
      isLoading.value = false;
    }
  }

  String get referralCode => referralData.value?.referralCode ?? '';

  String get generatedReferralLink =>
      referralData.value?.shareableReferralLink ?? '';

  bool get canShareReferral => referralCode.isNotEmpty;

  String get shareMessage {
    final code = referralCode;
    final link = generatedReferralLink;
    if (code.isEmpty) {
      return 'Join me on Oapp';
    }

    if (link.isEmpty) {
      return 'Join me on Oapp with my referral code $code';
    }

    return 'Join me on Oapp with my referral code $code. Sign up here: $link';
  }

  Future<void> openShareUri(Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Toast.error('Unable to open share option');
    }
  }

  Future<void> shareWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(shareMessage)}',
    );
    await openShareUri(uri);
  }

  Future<void> shareFacebook() async {
    final link = generatedReferralLink;
    if (link.isEmpty) {
      Toast.error('Referral link is unavailable');
      return;
    }

    final uri = Uri.parse(
      'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(link)}',
    );
    await openShareUri(uri);
  }

  Future<void> shareTwitter() async {
    final link = generatedReferralLink;
    final uri = Uri.parse(
      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent('Join me on Oapp with my referral code $referralCode')}&url=${Uri.encodeComponent(link)}',
    );
    await openShareUri(uri);
  }
}
