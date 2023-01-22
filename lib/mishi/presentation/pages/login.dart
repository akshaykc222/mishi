import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mishi/mishi/presentation/manager/bindings/login_binding.dart';
import 'package:mishi/mishi/presentation/manager/controllers/login_controller.dart';
import 'package:mishi/mishi/presentation/pages/email_verification.dart';
import 'package:mishi/mishi/presentation/pages/phone_login.dart';
import 'package:mishi/mishi/presentation/routes/app_pages.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:mishi/mishi/presentation/utils/pretty_print.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'music_detail.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final controller = Get.find<LoginController>();
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'My App',
          description: 'An app for converting pictures to NFT',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  var _session, _uri, _signature;

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          if (await canLaunchUrl(Uri.parse(uri))) {
            await launchUrlString(uri, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Application not found.")));
          }
        });
        print(session.accounts[0]);
        print(session.chainId);
        setState(() {
          _session = session;
        });
      } catch (exp) {
        print(exp);
        Get.snackbar("Error",
            "No application found please install metamask application to use this feature");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      // if (connector.connected) {
      prettyPrint(msg: connector.bridgeConnected.toString());
      prettyPrint(msg: connector.session.clientId);
      if (connector.bridgeConnected) {
        // var box = GetStorage();
        // box.write("isLogin", true);
        // Get.offAndToNamed(AppPages.home);
      }
      // Get.offAndToNamed(AppPages.home);
      // }

      // FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      //   final Uri deepLink = dynamicLink.link;
      //   controller.handleLink(deepLink);
      // });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    connector.on(
        'connect',
        (session) => setState(
              () {
                prettyPrint(msg: "session created");
                prettyPrint(msg: "session created");
                _session = session;

                print(_session.accounts[0]);
                print(_session.chainId);
                // print("navigating");
                // final jwt = JWT(
                //   {
                //     'id': 123,
                //     'iss': "mishi@gmail.com",
                //     'sub': "mishi@gmail.com",
                //     'aud':
                //         "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit",
                //     "iat": DateTime.now().toString(),
                //     "exp": DateTime.now()
                //         .add(const Duration(days: 360))
                //         .toString(),
                //     "uid": _session.accounts[0],
                //   },
                //   issuer: 'https://www.getmishi.com/',
                // );
                //
                // var token = jwt.sign(
                //   SecretKey(AppConstants.rsaPrivateKey),
                // );

                // prettyPrint(msg: 'Signed token: $token\n');
                var box = GetStorage();
                box.write("account", _session.accounts[0]);
                FirebaseAuth.instance.signInAnonymously();
                box.write("isLogin", true);
                if (box.hasData('login_return')) {
                  box.remove('login_return');

                  // Get.back();
                  Get.until((route) => Get.currentRoute == AppPages.home);
                  if (controller.selectedMusicEntity.value != null) {
                    Get.to(() => MusicDetail(
                        musicEntity: controller.selectedMusicEntity.value!));
                  }
                } else {
                  Get.offAndToNamed(AppPages.home);
                }
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
              print(_session.accounts[0]);
              print(_session.chainId);
              print("navigating");
              // Create a json web token
              // final jwt = JWT(
              //   {
              //     'id': 123,
              //     'server': {
              //       'id': '3e4fc296',
              //       'loc': 'euw-2',
              //     }
              //   },
              //   issuer: 'https://www.getmishi.com/',
              // );
              //
              // var token = jwt.sign(SecretKey(_session.accounts[0]));
              //
              // prettyPrint(msg: 'Signed token: $token\n');
              var box = GetStorage();
              // var auth=AuthCredential(providerId: providerId, signInMethod: signInMethod)
              // FirebaseAuth.instance.
              // FirebaseAuth.instance.signInWithCustomToken(token);
              box.write("isLogin", true);
              if (box.hasData('login_return')) {
                box.remove('login_return');

                // Get.back();
                Get.until((route) => Get.currentRoute == AppPages.home);

                if (controller.selectedMusicEntity.value != null) {
                  Get.to(() => MusicDetail(
                      musicEntity: controller.selectedMusicEntity.value!));
                }
              } else {
                Get.offAndToNamed(AppPages.home);
              }
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.png"), fit: BoxFit.fill)),
      child: Scaffold(
        // body: ,
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                    ),
                    child: SizedBox(
                      // width: 150,
                      height: 90,
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                        // width: 50,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Row(
                  children: const [
                    Text(
                      "Login",
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const PhoneLogin());
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.phone_android),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Login with Phone Number")
                      ],
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      Get.to(
                        () => EmailVerificationScreen(
                          email: "",
                          entity: controller.selectedMusicEntity.value,
                        ),
                        binding: LoginBinding(),
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/google.png",
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Login with Gmail")
                      ],
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      loginUsingMetamask(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/fox.png",
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Login with MetaMask")
                      ],
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () => controller.skip(),
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
