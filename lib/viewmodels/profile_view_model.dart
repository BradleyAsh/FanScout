import 'package:fsproj/services/firestore_service.dart';
import 'package:fsproj/ui/shared/constants/route_names.dart';
import 'package:fsproj/locator.dart';
import 'package:fsproj/services/authentication_service.dart';
import 'package:fsproj/services/dialog_service.dart';
import 'package:fsproj/services/navigation_service.dart';
import 'package:flutter/foundation.dart';

import 'base_model.dart';

class ProfileViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  String _selectedRole = 'My team';
  String get selectedRole => _selectedRole;

  void setSelectedRole(dynamic role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future getSuggestions( {@required String pattern}) async {
     
    return _firestoreService.getTeams(pattern);

  }


  Future save({
    @required String useruid,
    @required String email,
    @required String fullName,
    @required String team,
    @required String photoUrl,
  }) async {
    setBusy(true);

    var result = await _authenticationService.SaveProfile(
        useruid: useruid,
        email: email,
        fullname: fullName,
        team: team,
        photoUrl: photoUrl,
        );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Save Failure',
          description: 'General save failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Save Failure',
        description: result,
      );
    }
  }
}
