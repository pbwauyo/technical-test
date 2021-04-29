import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:technical_task/screens/home_page.dart';
import 'package:technical_task/widgets/custom_input_field.dart';
import 'package:technical_task/widgets/custom_textview.dart';
import 'package:http/http.dart' as http;
import 'package:technical_task/utils/pref_manager.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameTxtController = TextEditingController();
  final _passwordTxtController = TextEditingController();
  final _greenTextColor = Colors.green;
  bool _isLogingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        children: [
          Center(
            child: Container(
              child: CustomTextView(
                text: "Login to your account",
                bold: true,
                fontSize: 25,
              ),
            ),
          ),

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, ),
                borderRadius: BorderRadius.circular(6.0)
              ),
              margin: const EdgeInsets.only(top: 30),
              child: CustomInputField(
                controller: _usernameTxtController, 
                hint: "Username or phone number",
                maxLines: 1,
              ),
            ),
          ),

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, ),
                borderRadius: BorderRadius.circular(6.0)
              ),
              margin: const EdgeInsets.only(top: 20),
              child: CustomInputField(
                controller: _passwordTxtController, 
                hint: "Password",
                maxLines: 1,
                obscureText: true,
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15.0)),
                backgroundColor: MaterialStateProperty.all(_greenTextColor)
              ),
              onPressed: _isLogingIn ? null : () async{
                setState(() {
                  _isLogingIn = true;
                });
                final loginResponse = await _loginUser();
                if(loginResponse){
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context){
                        return HomePage();
                      }
                    )
                  );
                }
                setState(() {
                  _isLogingIn = false;
                });
              },
              child: _isLogingIn ? Center(
                child: Container(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator()
                ),
              ) :
              CustomTextView(
                text: "Login",
                textColor: Colors.white,
              ),
            ),
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: CustomTextView(
              bold: true,
              textColor: _greenTextColor,
                text: "Forgot your password?"
              ),
            ),
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 40),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                    ),
                    TextSpan(
                      text: "Register",
                      style: TextStyle(
                        color: _greenTextColor,
                      )
                    )
                  ]
                ),
              )
            )
          )
        ],
      ),
    );
  }

  Future<bool> _loginUser() async{
    final username = _usernameTxtController.text.trim();
    final password = _passwordTxtController.text.trim();

    if(username.isNotEmpty && password.isNotEmpty){
      final url = "http://52.66.224.226/wp-json/wp/v2/signin";
      final body = {
        "phone" : username,
        "password" : password,
        "device_os" : "Android",
        "device_token" : "123456",
        "device_id" : "123456"
      };
      final jsonBody = json.encode(body);

      final headers = {
        "Content-Type" : "application/json"
      };

      final response = await http.post(Uri.parse(url), body: jsonBody, headers: headers);
      final parsedResponse = Map<String, dynamic>.from(json.decode(response.body));
      if(parsedResponse["status"]){
        await PrefManager.saveUserToken(parsedResponse["user_token"]);
        await PrefManager.saveUserId(parsedResponse["result"]["ID"]);
        await PrefManager.saveUserImageUrl(parsedResponse["result"]["data"]["image"]);
      }
      return parsedResponse["status"];
      
    }else{
      Fluttertoast.showToast(
        msg: "All fields are required"
      );
      return false;
    }
  }

  

  @override
  void dispose() {
    _passwordTxtController.dispose();
    _usernameTxtController.dispose();
    super.dispose();
  }
}