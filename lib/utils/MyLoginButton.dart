import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mobile_project/utils/getAPI.dart';

const NESred = Color(0xFFFF0000);
const fieldColor = Color(0xFFD9D9D9);

class MyLoginButton extends StatefulWidget {
  @override
  _MyLoginButtonState createState() => _MyLoginButtonState();
}

class _MyLoginButtonState extends State<MyLoginButton> {
  String message = ""; // initalizes message, starts as blank field
  String newMessageText = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String username = '';
  String password = '';

  void changeText() {
    setState(() {
      message = newMessageText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            
            Container(

              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              margin: EdgeInsets.all(20.0),

            ),

            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter Your Username',
                labelStyle: TextStyle(color: Colors.black87),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87))
              ),
              onChanged: (text) {
                setState(() {
                  username = text;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Your Password',
                labelStyle: TextStyle(color: Colors.black87),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87))
              ),
              onChanged: (text) {
                setState(() {
                  password = text;
                });
              },
            ),

            

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                newMessageText = "";
                changeText();

                String payload = '{"username":"' + username.trim() + '","password":"' + password.trim() + '"}';
                String userId = '-1';
                var jsonObject;

                try {
                  String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/login';
                  String ret = await CardsData.getJson(url, payload);
                  print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

                  jsonObject = json.decode(ret);
                  //print("the jsonObject is:" + jsonObject);
                  userId = jsonObject["id"];

                  //print("in here 1");
                } catch (e) {
                  //print("in here 2");
                  newMessageText = e.toString();
                  print(newMessageText); // prints the error message in console

                  newMessageText = "Incorrect Login/Password";
                  changeText(); // changes the text on the application screen
                  return;
                }

                if (userId == -1) {
                  newMessageText = "Incorrect Login/Password";
                  changeText();
                } else {
                  //print("in here 3");
                  //GlobalData.userId = userId;
                  //GlobalData.firstName = jsonObject["firstName"];
                  //GlobalData.lastName = jsonObject["lastName"];
                  //GlobalData.username = username;
                  //GlobalData.password = password;
                  Navigator.pushNamed(context, '/hub');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NESred,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            SizedBox(height: 0),
            Row(
              children: <Widget>[
                Text(
                  '$message',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer() .. onTap = () async {
                        Navigator.pushNamed(context, '/register');
                      }
                    )
                  ]
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
