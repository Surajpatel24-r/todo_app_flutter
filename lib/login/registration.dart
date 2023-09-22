import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../api/config.dart';
import 'login_screen.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print("SomeThing Went Wrong");
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
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
                        "CREATE YOUR ACCOUNT",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(color: Colors.white),
                            errorText:
                                _isNotValidate ? "Enter Proper Info" : null,
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(),
                      child: TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.copy),
                              onPressed: () {
                                final data = ClipboardData(
                                    text: passwordController.text);
                                Clipboard.setData(data);
                              },
                            ),
                            prefixIcon: IconButton(
                              icon: Icon(Icons.password),
                              onPressed: () {
                                String passGen = generatePassword();
                                passwordController.text = passGen;
                                setState(() {});
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(color: Colors.white),
                            errorText:
                                _isNotValidate ? "Enter Proper Info" : null,
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                      child: SizedBox(
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            registerUser();
                          },
                          child: Center(
                            child: Text(
                              "Register",
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
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: HStack([
                        "Already Registered?".text.make(),
                        " Sign In".text.red700.make()
                      ]).centered(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String generatePassword() {
  String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String numbers = '1234567890';
  String symbols = '!@#\$%^&*()<>,./';

  String password = '';

  int passLength = 20;

  String seed = upper + lower + numbers + symbols;

  List<String> list = seed.split('').toList();

  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    password += list[index];
  }
  return password;
}
