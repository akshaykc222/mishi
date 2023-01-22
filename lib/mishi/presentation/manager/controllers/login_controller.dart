import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mishi/mishi/presentation/manager/bindings/login_binding.dart';
import 'package:mishi/mishi/presentation/pages/email_verification.dart';
import 'package:mishi/mishi/presentation/pages/music_detail.dart';
import 'package:mishi/mishi/presentation/pages/otp_page.dart';
import 'package:mishi/mishi/presentation/routes/app_pages.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import '../../../domain/entities/music_entity.dart';

class LoginController extends GetxController {
  final phoneNumber = Rxn<int>();
  final verificationID = "".obs;
  final email = "".obs;
  final otpController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final completePhoneNumber = "".obs;

  navigateToEmailVerificationScreen() {
    if (GetUtils.isEmail(emailController.text)) {
      verifyEmail();
      Get.to(
        () => EmailVerificationScreen(
          email: emailController.text,
        ),
        binding: LoginBinding(),
      );
    } else {
      Get.snackbar(
        "Invalid E-mail",
        "Please enter valid email",
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
      );
    }
  }

  bool checkLogin() {
    var box = GetStorage();
    return box.read("isLogin") as bool;
  }

  navigateToPhoneVerificationScreen() {
    if (GetUtils.isEmail(emailController.text)) {
      verifyEmail();
      Get.to(() => EmailVerificationScreen(email: emailController.text));
    } else {
      Get.snackbar(
        "Invalid E-mail",
        "Please enter valid email",
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
      );
    }
  }

  verifyPhoneNumber() async {
    Get.to(() => const OtpPage());
    final auth = FirebaseAuth.instance;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: completePhoneNumber.value,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        var box = GetStorage();
        box.write("isLogin", true);
        Get.until((route) => Get.currentRoute == AppPages.home);
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar("Error", "${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationID.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationID.value = verificationId;
      },
    );
  }

  final selectedMusicEntity = Rxn<MusicEntity>();
  changeSelectedMusicEntity(MusicEntity entity) {
    selectedMusicEntity.value = entity;
  }

  verifyOtp() async {
    final auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID.value, smsCode: otpController.text);
    await auth.signInWithCredential(credential);
    var box = GetStorage();
    box.write("isLogin", true);
    if (box.hasData('login_return')) {
      box.remove('login_return');

      // Get.back();
      Get.until((route) => Get.currentRoute == AppPages.home);
      if (selectedMusicEntity.value != null) {
        Get.to(() => MusicDetail(musicEntity: selectedMusicEntity.value!));
      }
    } else {
      Get.until((route) => Get.currentRoute == AppPages.home);
    }
  }

  logout() async {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {}
    await FirebaseAuth.instance.signOut();
    var box = GetStorage();
    box.write("isLogin", false);
    Get.until((route) => Get.currentRoute == AppPages.home);
  }

  verifyEmail() {
    final auth = FirebaseAuth.instance;
    auth
        .sendSignInLinkToEmail(
            email: emailController.text,
            actionCodeSettings: ActionCodeSettings(
                url:
                    "https://mishi.page.link/bjYi?email=${emailController.text}",
                handleCodeInApp: true,
                androidInstallApp: false,
                androidPackageName: "com.wolfpack.mishi.mishi",
                androidMinimumVersion: "19"))
        .catchError((onError) => debugPrint(onError.toString()))
        .then((value) => Get.snackbar("Mail sent successfully",
            "Please check your email for confirmation link"));
  }

  void handleLink(Uri link) async {
    prettyPrint(msg: link.toString());
    final auth = FirebaseAuth.instance;
    try {
      // The client SDK will parse the code from the link for you.
      bool validLink = auth.isSignInWithEmailLink(link.toString());
      if (validLink) {
        final continueUrl = link.queryParameters['continueUrl'] ?? "";
        final email = Uri.parse(continueUrl).queryParameters['email'] ?? "";
        prettyPrint(msg: "email $email");
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailLink(email: email, emailLink: link.toString());

        // You can access the new user via userCredential.user.

        print('Successfully signed in with email link!');
        Get.until((route) => Get.currentRoute == AppPages.home);
      }
    } catch (error) {
      print('Error signing in with email link.');
    }
  }

  static const operatingChain = 4;
  final currentAddress = "".obs;
  final chainId = -1.obs;

  // bool get isEnabled
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'My App',
          description: 'An app for converting pictures to NFT',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  final chainID = "".obs;

  changeChainId(String val) {
    chainID.value = val;
  }

  String getCurrentUser() {
    final auth = FirebaseAuth.instance;
    var box = GetStorage();
    if (auth.currentUser?.isAnonymous == true && box.hasData('account')) {
      return box.read('account');
    }
    if (auth.currentUser?.email != null) {
      return auth.currentUser?.email ?? "";
    } else if (auth.currentUser?.phoneNumber != null) {
      return auth.currentUser?.phoneNumber ?? "";
    } else {
      return chainID.value;
    }
  }

  skip({bool? first}) {
    var box = GetStorage();
    box.write("isLogin", false);
    box.remove('account');

    FirebaseAuth.instance.signInAnonymously();
    if (first == true) {
      Get.offAllNamed(AppPages.home);
    } else {
      Get.until((route) => Get.currentRoute == AppPages.home);
    }
  }

  final haveException = "".obs;
  Future<void> signInWithGoogle() async {
    try {
      haveException.value = "";
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      //
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      var auth = FirebaseAuth.instance;
      var authResult = await auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
      haveException.value = "Something went wrong please try again";
    }

    // Get.to(EmailVerificationScreen(email: authResult.user?.displayName ?? ""));
  }
}
