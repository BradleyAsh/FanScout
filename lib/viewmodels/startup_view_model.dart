import 'package:fsproj/ui/shared/constants/route_names.dart';
import 'package:fsproj/locator.dart';
import 'package:fsproj/services/authentication_service.dart';
import 'package:fsproj/services/navigation_service.dart';
import 'package:fsproj/viewmodels/base_model.dart';
import 'dart:async';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    if (hasLoggedInUser) {
      //_navigationService.navigateTo(HomeViewRoute);
      Future.delayed(Duration(seconds: 2), () {
        _navigationService.navigateTo(LoginViewRoute);
      });
    } else {
      Future.delayed(Duration(seconds: 2), () {
        _navigationService.navigateTo(LoginViewRoute);
      });
    }
  }
}
