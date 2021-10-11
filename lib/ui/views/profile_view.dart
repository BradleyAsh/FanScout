import 'package:flutter/material.dart';
import 'package:fsproj/ui/shared/constants/strings.dart';
import 'package:fsproj/ui/shared/ui_helpers.dart';
import 'package:fsproj/ui/widgets/busy_button.dart';
import 'package:fsproj/ui/widgets/input_field.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fsproj/viewmodels/profile_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../locator.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';
import '../../services/navigation_service.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = locator<AuthenticationService>();
    final NavigationService _navigationService = locator<NavigationService>();
    final user = authService.currentUser; //Provider.of<User>(context);

    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 10, 22, 40),
              ),
              resizeToAvoidBottomInset: false,
              backgroundColor: Color.fromARGB(255, 10, 22, 40),
              body: _buildUserInfo(model, user),
            ));
  }

  Widget _buildUserInfo(model, AUser user) {
    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final TextEditingController _typeAheadController = TextEditingController();

    emailController.text = user.email;
    fullNameController.text = user.fullname;
    _typeAheadController.text = user.team;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          verticalSpaceMedium,
          Text("Profile"),
          verticalSpaceMedium,
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 60,
              backgroundColor: Colors.black54,
            ),
            // if (user.fullname != null && user.team != null)
            //  Text(
            //  "Hello " + user.fullname + ", " + user.team + " supporter",
            //  style: TextStyle(color: Colors.black),
            // ),
          ]),
          verticalSpaceLarge,
          InputField(
            placeholder: 'Full Name',
            controller: fullNameController,
          ),
          verticalSpaceSmall,
          InputField(
            placeholder: 'Email',
            controller: emailController,
          ),
          verticalSpaceSmall,
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                autofocus: false,
                textAlign: TextAlign.justify,
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.local_police,
                        color: Color.fromARGB(255, 44, 179, 163)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter Your Team Here',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    labelStyle: TextStyle(
                        //  color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10))),
            suggestionsCallback: (pattern) async {
              return await model.getSuggestions(pattern: pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              _typeAheadController.text = suggestion;
            },
          ),
          verticalSpaceSmall,
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BusyButton(
                title: 'Save',
                busy: model.busy,
                onPressed: () {
                  model.save(
                      useruid: user.id,
                      email: emailController.text,
                      photoUrl: user.photoUrl,
                      fullName: fullNameController.text,
                      team: _typeAheadController.text);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
