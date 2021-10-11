import 'package:fsproj/ui/shared/constants/route_names.dart';
import 'package:fsproj/locator.dart';
import 'package:fsproj/services/authentication_service.dart';
import 'package:fsproj/services/navigation_service.dart';
import 'package:fsproj/viewmodels/base_model.dart';
import 'package:fsproj/services/firestore_service.dart';
import 'package:fsproj/models/fixtures.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Future navigateToProfilePage() async {
    
      _navigationService.navigateTo(LoginViewRoute);
    
  }

  Future getFixtures () async
  {
      return _firestoreService.getFixtures();
  }
  
}
