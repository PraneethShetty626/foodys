import 'package:flutter/material.dart';
import 'package:foodyrest/domain/HttpClient/http_client.dart';
import 'package:foodyrest/domain/entities/current_section.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/form_title_and_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? username;
  String? password;

  TextEditingController usernameController =
      TextEditingController(text: "Admin");
  TextEditingController passwordController =
      TextEditingController(text: "Admin@123");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bool loggedIn = Provider.of<LoggedIn>(context, listen: true).loggedIn;

    return Scaffold(
      body: loggedIn
          ? Center(
              child: CustomTextButton(
                text: "Logout",
                onTap: () {
                  Provider.of<LoggedIn>(context, listen: false).logout();
                },
              ),
            )
          : Form(
              key: formKey,
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Container(
                  color: Colors.white,
                  width: size.width,
                  height: size.height,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: 600,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green.withOpacity(0.5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Sign in",
                                style: largestText,
                              ),
                              const SizedBox(height: 50),
                              FormTitleAndField(
                                title: "Username",
                                textEditingController: usernameController,
                                onChanged: (value) {
                                  setState(() {
                                    username = value;
                                  });
                                },
                                onSaved: (value) {
                                  setState(() {
                                    username = value;
                                  });
                                },
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                              ),
                              FormTitleAndField(
                                title: "Password",
                                textEditingController: passwordController,
                                obscure: true,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                onSaved: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              CustomTextButton(
                                  text: "Sign In",
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState?.save();
                                      HttpClient()
                                          .login(username!, password!)
                                          .then((value) {
                                        if (value.body.isNotEmpty) {
                                          Provider.of<LoggedIn>(context,
                                                  listen: false)
                                              .setTrue(value.body);
                                        } else {
                                          print("Wron gpass");
                                        }
                                      });
                                    } else {
                                      print("Username/password incorrect");
                                    }
                                  }),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
