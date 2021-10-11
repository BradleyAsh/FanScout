import 'package:flutter/cupertino.dart';
import 'package:fsproj/ui/shared/ui_helpers.dart';
import 'package:fsproj/ui/widgets/busy_button.dart';
import 'package:fsproj/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:fsproj/viewmodels/signup_view_model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final teamController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 10, 22, 40),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 10, 22, 40),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40,
                child: Image.asset('assets/fanscoutlogo.png'),
              ),
              SizedBox(height: 5),
              Text(
                'Registration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 255, 255, 255),
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 6.0,
                      color: Color.fromARGB(255, 44, 179, 163),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              InputField(
                placeholder: 'Full Name',
                controller: fullNameController,
              ),
              SizedBox(height: 5),
              InputField(placeholder: 'Email', controller: emailController),
              SizedBox(height: 5),
              InputField(
                placeholder: 'Password',
                password: true,
                controller: passwordController,
                additionalNote: 'Password has to be a minimum of 6 characters.',
              ),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    controller: this._typeAheadController,
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
                    dense: true,
                  );
                },
                suggestionsBoxDecoration:
                    SuggestionsBoxDecoration(hasScrollbar: true),
                onSuggestionSelected: (suggestion) {
                  this._typeAheadController.text = suggestion;
                },
              ),
              verticalSpaceTiny,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BusyButton(
                    title: 'Sign Up',
                    busy: model.busy,
                    onPressed: () {
                      model.signUp(
                          email: emailController.text,
                          password: passwordController.text,
                          fullName: fullNameController.text,
                          team: _typeAheadController.text);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
