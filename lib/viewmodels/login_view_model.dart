import 'package:fsproj/ui/shared/constants/route_names.dart';
import 'package:fsproj/locator.dart';
import 'package:fsproj/services/authentication_service.dart';
import 'package:fsproj/services/dialog_service.dart';
import 'package:fsproj/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fsproj/ui/shared/constants/strings.dart';
import 'package:fsproj/ui/shared/common_widgets/platform_exception_alert_dialog.dart';

import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future login({
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
  }

  Future signInWithGoogle() async {
    var result = await _authenticationService.signInWithGoogle();
    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      }
    }
  }

  Future signInWithFacebook() async {
    var result = await _authenticationService.signInWithFacebook();
    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      }
    }
  }

  Future signInWithTwitter() async {
    var result = await _authenticationService.signInWithTwitter();
    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      }
    }
  }

  Future<void> showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);
  }
}
