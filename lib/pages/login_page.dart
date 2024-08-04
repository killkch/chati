// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:chati/pages/signup_page.dart';
import 'package:chati/providers/auth_provider.dart';
import 'package:chati/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //?
  final AuthService authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //?
    final authProvider = Provider.of<AuthProvider1>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                //?
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                //?
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 55,
                /**
                 * 버튼을 만듭니다.
                 */
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    try {
                      await authProvider.signIn(
                        _emailController.text,
                        _passwordController.text,
                      );

                      /**
                       * 로그이이 성공하면 스트림 빌더에 의하여 자동으로 홈페이지로 이동하게됩니다. 
                       * 마찬가지로 로그 아웃이 될 경우 자동으로 로그인 페이지로 이동을 하게 됩니다. 
                       */
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("OR"),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.to(() => SignupPage());
                },
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                height: 55,
                child: SignInButton(
                  Buttons.google,
                  onPressed: () async {
                    var tmp = await authService.signInWithGoogle();
                    print("tmp.....${tmp.toString()}");

                    if (tmp?.user!.email != null) {
                      if (tmp?.additionalUserInfo!.isNewUser == true) {
                        print("99919...................google first login ");
                        await authService.addGoogleUSerToFireStore(tmp);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
