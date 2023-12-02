import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:mobile_project/utils/getAPI.dart';
import 'package:mobile_project/utils/emailAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

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
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87))),
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
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87))),
              onChanged: (text) {
                setState(() {
                  password = text;
                });
              },
            ),
            Container(
              margin: EdgeInsets.all(10),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                )
            ),
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
                  //print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}
                  jsonObject = json.decode(ret);
                  userId = jsonObject["id"];
                } catch (e) {
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
                  GlobalData.userId = userId;
                  GlobalData.firstName = jsonObject["firstName"];
                  GlobalData.lastName = jsonObject["lastName"];
                  GlobalData.username = username;
                  GlobalData.password = password;
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
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(bottom: 0),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(text: "Don't have an account? "),
                TextSpan(
                    text: "Sign Up",
                    style: TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        Navigator.pushNamed(context, '/register');
                      })
              ])),
            ),
            Container(
              margin: EdgeInsets.all(0),
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet<dynamic>(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: backColor,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return emailWidget();
                    }
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class emailWidget extends StatefulWidget {

  _emailState createState() => _emailState();

}

class _emailState extends State<emailWidget> {

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height * 2 / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Enter Email...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: fieldColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    emailAPI.verifyReset(emailController.text);
                    showModalBottomSheet<bool>(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      backgroundColor: backColor,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return verifyWidget(email: emailController.text);
                      }
                    );
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: NESred, fontSize: 16, fontWeight: FontWeight.bold),
                  )
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: textColor, width: .25)
              )
            ),
            child: TextField(
              controller: emailController,
              maxLines: 1,
              style: const TextStyle(
                color: textColor,
                fontSize: 16
              ),
              decoration: const InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.transparent),
                labelText: 'Email...',
                labelStyle: TextStyle(color: textColor, fontSize: 16),
                border: OutlineInputBorder(borderSide: BorderSide.none)
              ),
            ),
          )
        ]
      )
    );

  }

}

class verifyWidget extends StatefulWidget {

  final String email;

  verifyWidget({
    required this.email
  });

  _verifyState createState() => _verifyState(email: email);

}

class _verifyState extends State<verifyWidget> {

  final String email;

  _verifyState({
    required this.email
  });

  String pin1 = '';
  String pin2 = '';
  String pin3 = '';
  String pin4 = '';
  String pin5 = '';
  String pin6 = '';
  String message = '';

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height * 2 / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.of(context)
                      ..pop()
                      ..pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Verify Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: fieldColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    if (pin1+pin2+pin3+pin4+pin5+pin6 == verificationToken) {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: backColor,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return passwordWidget(email: email);
                        }
                      );
                    }
                    else {
                      setState(() {
                        message = 'Incorrect Code';
                      });
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: NESred, fontSize: 16, fontWeight: FontWeight.bold),
                  )
                )
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.black87),
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              children: [
                Text(
                  'Verification code sent to ' + email,
                  style: const TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Form(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin1 = value;
                      });
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(right: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin2 = value;
                      });
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(right: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin3 = value;
                      });
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(right: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin4 = value;
                      });
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(right: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin5 = value;
                      });
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
                Container(
                  height: (MediaQuery.sizeOf(context).width - 45) / 6,
                  width: (MediaQuery.sizeOf(context).width - 45) / 6,
                  margin: EdgeInsets.only(right: 10),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        pin6 = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: fieldColor,
                      focusColor: backColor,
                      hoverColor: backColor,
                      hintText: '0'
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              message,
              style: const TextStyle(
                color: NESred,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          )
        ]
      ),
    );

  }

}

class passwordWidget extends StatefulWidget {

  final String email;

  passwordWidget({
    required this.email
  });

  _passwordState createState() => _passwordState(email: email);

}

class _passwordState extends State<passwordWidget> {

  final String email;

  _passwordState({
    required this.email
  });

  String message = '';
  RegExp passExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height * 2 / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Enter New Password...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: fieldColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    bool complex = passExp.hasMatch(passwordController.text);
                    if (complex) {
                      emailAPI.changePassword(email, passwordController.text);
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pop();
                    }
                    else {
                      setState(() {
                        message = 'Password must be at least 8 characters long, contain upper and lower case characters, a number, and special character';
                      });
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: NESred, fontSize: 16, fontWeight: FontWeight.bold),
                  )
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: textColor, width: .25)
              )
            ),
            child: TextField(
              controller: passwordController,
              maxLines: 1,
              obscureText: true,
              style: const TextStyle(
                color: textColor,
                fontSize: 16
              ),
              decoration: const InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.transparent),
                labelText: 'New Password...',
                labelStyle: TextStyle(color: textColor, fontSize: 16),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              message,
              style: TextStyle(
                color: NESred,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          )
        ]
      )
    );

  }

}