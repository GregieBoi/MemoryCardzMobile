import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/utils/ListsAPI.dart';
import 'dart:convert';
import 'package:mobile_project/utils/getAPI.dart';
import 'package:mobile_project/utils/emailAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

class MyRegisterButton extends StatefulWidget {
  @override
  _MyRegisterButtonState createState() => _MyRegisterButtonState();
}

class _MyRegisterButtonState extends State<MyRegisterButton> {
  String message = ""; // initialize message, starts as blank field
  String newMessageText = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String firstName = '';
  String lastName = '';
  String email = '';
  String username = '';
  String password = '';
  String confirmPassword = '';

  void changeText() {
    setState(() {
      message = newMessageText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: const Text(
            "MEMORYCARDS",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ),
        body: Center(
          child: Container(
              margin: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: contColor,
              ),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    margin: const EdgeInsets.all(20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: fieldColor,
                        labelText: 'First Name',
                        hintText: 'Enter First Name',
                        labelStyle: TextStyle(color: Colors.black87),
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                      ),
                      onChanged: (text) {
                        setState(() {
                          firstName = text;
                        });
                      },
                      cursorColor: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: fieldColor,
                        labelText: 'Last Name',
                        hintText: 'Enter Last Name',
                        labelStyle: TextStyle(color: Colors.black87),
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                      ),
                      onChanged: (text) {
                        setState(() {
                          lastName = text;
                        });
                      },
                      cursorColor: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: fieldColor,
                        labelText: 'Username',
                        hintText: 'Enter Username',
                        labelStyle: TextStyle(color: Colors.black87),
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                      ),
                      onChanged: (text) {
                        setState(() {
                          username = text;
                        });
                      },
                      cursorColor: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: fieldColor,
                        labelText: 'Email',
                        hintText: 'Enter Email',
                        labelStyle: TextStyle(color: Colors.black87),
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                      ),
                      onChanged: (text) {
                        setState(() {
                          email = text;
                        });
                      },
                      cursorColor: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: fieldColor,
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        labelStyle: TextStyle(color: Colors.black87),
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                      ),
                      onChanged: (text) {
                        setState(() {
                          password = text;
                        });
                      },
                      cursorColor: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: fieldColor,
                        labelText: 'Confirm Password',
                        hintText: 'Please Confirm Password',
                        labelStyle: TextStyle(color: Colors.black87),
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                      ),
                      onChanged: (text) {
                        setState(() {
                          confirmPassword = text;
                        });
                      },
                      cursorColor: Colors.black87,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Text(
                      newMessageText,
                      style: TextStyle(
                        color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),
                  ElevatedButton(
                      onPressed: () async {

                        String emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                        RegExp emailExp = new RegExp(emailPattern);
                        bool isEmail = emailExp.hasMatch(email);
                        
                        String  passPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                        RegExp passExp = new RegExp(passPattern);
                        bool complex =  passExp.hasMatch(password);

                        if (username == '') {
                          newMessageText = 'Username is required';
                        }
                        else if (firstName == '') {
                          newMessageText = 'First Name is required';
                        }
                        else if (lastName == '') {
                          newMessageText = 'Last Name is required';
                        }
                        else if (email == '') {
                          newMessageText = 'Email is required';
                        }

                        else if (!isEmail) {
                          newMessageText = 'Invalid Email';
                        }

                        else if (password == '') {
                          newMessageText = 'Password is required';
                        }
                        else if (!complex) { 
                          print(password);
                          newMessageText = 'Password must be at least 8 characters long and contain uppercase characters, lowercase characters, a number, and special character';
                        }
                        else if (password != confirmPassword) {
                          newMessageText = 'Passwords do not match';
                        }

                        else {

                          emailAPI.verify(email);

                          bool? verified = false;

                          verified = await showModalBottomSheet<bool>(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            backgroundColor: backColor,
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return verifyWidget(email: email);
                            }
                          );

                          newMessageText = "";
                          changeText();

                          if (verified!) {

                            String payload = '{"firstName":"' +
                                firstName.trim() +
                                '", "lastName":"' +
                                lastName.trim() +
                                '", "username":"' +
                                username.trim() +
                                '", "password":"' +
                                password.trim() +
                                '", "email":"' +
                                email.trim() +
                                '"}';
                            //String userId = '-1';
                            var jsonObject;

                            print("the payload is: " + payload);

                            try {
                              String url = 'https://cop4331-25-c433f0fd0594.herokuapp.com/api/register';
                              String ret = await CardsData.getJson(url, payload);
                              print("The ret is: " + ret); // ret is {"accessToken":"blahblahblahblah"}

                              jsonObject = json.decode(ret);
                              username = jsonObject["username"];

                              if (jsonObject['id'] != null) {
                                print("IN HERE 3 !!!!!!!!!!!!!!!!!!!!!!!");
                                GlobalData.userId = jsonObject['id'];
                                GlobalData.firstName = jsonObject["firstName"];
                                GlobalData.lastName = jsonObject["lastName"];
                                GlobalData.username = username;
                                GlobalData.password = password;
                                getListsAPI.createList(GlobalData.userId!, 'Shelf');
                                Navigator.pushNamed(context, '/hub');
                              }

                              //print("in here 1");
                            } catch (e) {
                              print("in here 2");
                              newMessageText = e.toString();
                              print(newMessageText); // prints the error message in console

                              //newMessageText = "Fatal error";
                              changeText(); // changes the text on the application screen
                              return;
                            }
                          }
                        }

                        changeText();

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NESred,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      child: Text("Register", style: TextStyle(fontSize: 14, color: Colors.white),)),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer() .. onTap = () async {
                              Navigator.pushNamed(context, '/login');
                            }
                          )
                        ]
                      )
                    ),
                  )
                ],
              ))),
        ),
        backgroundColor: backColor);
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter Your Username',
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
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Your Password',
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

                String payload = '{"username":"' +
                    username.trim() +
                    '","password":"' +
                    password.trim() +
                    '"}';
                String userId = '-1';
                var jsonObject;

                try {
                  String url =
                      'https://cop4331-25-c433f0fd0594.herokuapp.com/api/login';
                  String ret = await CardsData.getJson(url, payload);
                  print("The ret is: " +
                      ret); // ret is {"accessToken":"blahblahblahblah"}

                  jsonObject = json.decode(ret);
                  //print("the jsonObject is:" + jsonObject);
                  userId = jsonObject["id"];

                  //print("in here 1");
                } catch (e) {
                  //print("in here 2");
                  newMessageText = e.toString();
                  print(newMessageText); // prints the error message in console

                  newMessageText = "Fatal error";
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
                  Navigator.pushNamed(context, '/cards');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[50],
                foregroundColor: Colors.black,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Do Login',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text(
                  '$message',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  */
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
                    onPressed: () => Navigator.pop(context, false),
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
                      Navigator.pop(context, true);
                    }
                    else {
                      Navigator.pop(context, false);
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
                )
              ],
            ),
          )
        ]
      ),
    );

  }

}