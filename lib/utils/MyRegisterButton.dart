import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:convert';
import 'package:mobile_project/utils/getAPI.dart';

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
            "MemoryCardZ",
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
                  ElevatedButton(
                      onPressed: () async {

                        newMessageText = "";
                        changeText();

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

                          //print("in here 1");
                        } catch (e) {
                          print("in here 2");
                          newMessageText = e.toString();
                          print(newMessageText); // prints the error message in console

                          newMessageText = "Fatal error";
                          changeText(); // changes the text on the application screen
                          return;
                        }

                        if (username == '') {
                          newMessageText = "Error, userID is no good!";
                          print("in hereeeeeeeeeeeeeeeeeeeee");
                          changeText();
                        } else {
                          print("IN HERE 3 !!!!!!!!!!!!!!!!!!!!!!!");
                          //GlobalData.userId = userId;
                          //GlobalData.firstName = jsonObject["firstName"];
                          //GlobalData.lastName = jsonObject["lastName"];
                          //GlobalData.username = username;
                          //GlobalData.password = password;
                          Navigator.pushNamed(context, '/games');
                        }
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
