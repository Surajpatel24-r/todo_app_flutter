import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/login/registration.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../api/config.dart';
import '../dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Dashboard(token: myToken)));
      } else {
        print('Something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        height: 190.h,
                        width: 190.w,
                        child: Image(
                            image: NetworkImage(
                                "https://img.freepik.com/free-vector/login-concept-illustration_114360-739.jpg?w=2000")),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.h),
                      child: Text(
                        "Email Sign-In",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Email",
                            errorText:
                                _isNotValidate ? "Enter Proper Info" : null,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Password",
                            errorText:
                                _isNotValidate ? "Enter Proper Info" : null,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          loginUser();
                        },
                        child: Center(
                          child: Text(
                            "Login",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 23, 219, 225),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Registration()));
          },
          child: Container(
              height: 25,
              color: Colors.lightBlue,
              child: Center(
                  child: "Create a new Account..! Sign Up"
                      .text
                      .white
                      .makeCentered())),
        ),
      ),
    );
  }
}
