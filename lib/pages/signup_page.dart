// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, unused_field, unused_element, unnecessary_string_interpolations, slash_for_doc_comments

import 'dart:io';

import 'package:chati/providers/auth_provider.dart';
import 'package:chati/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //?
  final AuthService authService = AuthService();

  /**
   * 정보를 사용하기 위하여 컨트롤러를 정의한다. 
   */

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  /**
   * 이미지 picker에서 사용될 이미지 파일을 선언해 준다. 
   */
  File? _image;
  /**
   * 파이어베이스 를 사용하기 위하여 인스턴스를 정의해준다. 
   */
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  Future<String> _uploadImage(File image) async {
    final ref = _storage
        .ref()
        .child('user_images')
        .child('${_auth.currentUser!.uid}.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _signUp() async {
    /**
     * 에러가 발생할 수도 있는 코드를 처리하기 위하여 사용합니다. 
     * 예외처리 즉 에러를 처리한다는 말입니다. 
     * 에러가 나더라도 그부분을 건너뛰어 정상적으로 작동할 수 있게 하기 위하여 사용된다. 
     * 일부분의 에러때문에 애 전체가 먹통이 나는 상황을 미연에 방지한다는 의미이다. 
     */
    try {
      /**
       * 파이어베이스에서 제공하는 메뉴얼 대로 그대로 사용하면 된다. 
       */
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      /**
       * 사용자의 이미지를 저장하고 주소(유알엘)를 받아서 저장한다. 
       */
      final imageUrl = await _uploadImage(_image!);
      /**
       * 입력 받ㄱ은 사용자 정보를 파이어베이스에 저장을 한다. 
       * 각각의 컨트롤러에서 입력받은 정보를 파이어베이스에 저장을 한다. 
       */
      await _fireStore.collection('users').doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "imageUrl": imageUrl,
      });

      Get.offAll(() => HomePage());

      Fluttertoast.showToast(
        msg: "Sign Up 성공 !!!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      /**
       * 예외 처리를 위해 사용한다. 
       */
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //?
    // final authProvider = Provider.of<AuthProvider1>(context);
    //?

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
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
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                  ),
                  child: _image == null
                      ? Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 50,
                            color: Colors.blue,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                //?
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _signUp,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
