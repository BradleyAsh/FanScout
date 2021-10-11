import 'package:fsproj/ui/shared/ui_helpers.dart';
import 'package:fsproj/ui/widgets/busy_button.dart';
import 'package:fsproj/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:fsproj/viewmodels/login_view_model.dart';
import 'package:fsproj/ui/shared/common_widgets/social_sign_in_button.dart';
import 'package:fsproj/ui/shared/constants/strings.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bool isLoading = false;

  static const Key googleButtonKey = Key('google');
  static const Key facebookButtonKey = Key('facebook');
  static const Key twitterButtonKey = Key('twitter');
  static const Key emailPasswordButtonKey = Key('email-password');
  static const Key emailLinkButtonKey = Key('email-link');

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromARGB(255, 10, 22, 40),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: Image.asset('assets/fanscoutlogo.png'),
                ),
                InputField(
                  placeholder: 'Email',
                  controller: emailController,
                ),
                verticalSpaceTiny,
                InputField(
                  placeholder: 'Password',
                  password: true,
                  controller: passwordController,
                ),
                verticalSpaceTiny,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BusyButton(
                      title: 'Login',
                      busy: model.busy,
                      onPressed: () {
                        model.login(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      },
                    ),
                    horizontalSpaceSmall,
                    BusyButton(
                      title: 'Register',
                      busy: model.busy,
                      onPressed: () {
                        model.navigateToSignUp();
                      },
                    )
                  ],
                ),
                verticalSpaceMedium,
                SocialSignInButton(
                  key: googleButtonKey,
                  assetName: 'assets/go-logo.png',
                  text: Strings.signInWithGoogle,
                  onPressed: isLoading
                      ? null
                      : () {
                          try {
                            model.signInWithGoogle();
                          } on PlatformException catch (e) {
                            if (e.code != 'ERROR_ABORTED_BY_USER') {
                              model.showSignInError(context, e);
                            }
                          }
                        },
                  color: Colors.white,
                ),
                verticalSpaceSmall,
                SocialSignInButton(
                  key: facebookButtonKey,
                  assetName: 'assets/fb-logo.png',
                  text: Strings.signInWithFacebook,
                  textColor: Colors.white,
                  onPressed: isLoading
                      ? null
                      : () {
                          try {
                            model.signInWithFacebook();
                          } on PlatformException catch (e) {
                            if (e.code != 'ERROR_ABORTED_BY_USER') {
                              model.showSignInError(context, e);
                            }
                          }
                        },
                  color: Color(0xFF334D92),
                ),
                verticalSpaceSmall,
                SocialSignInButton(
                  key: twitterButtonKey,
                  assetName: 'assets/tw-logo-white.png',
                  text: Strings.signInWithTwitter,
                  textColor: Colors.white,
                  onPressed: isLoading
                      ? null
                      : () {
                          try {
                            model.signInWithTwitter();
                          } on PlatformException catch (e) {
                            if (e.code != 'ERROR_ABORTED_BY_USER') {
                              model.showSignInError(context, e);
                            }
                          }
                        },
                  color: Color.fromARGB(255, 29, 161, 242),
                ),
              ],
            ),
          )),
    );
  }
}
