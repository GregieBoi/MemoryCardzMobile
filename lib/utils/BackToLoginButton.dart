import 'package:flutter/material.dart';

/*
class BackToLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/login');
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.brown[50]),
          textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14, color: Colors.black),
          ),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          padding: MaterialStateProperty.all(EdgeInsets.all(2.0)),
          overlayColor: MaterialStateProperty.all(Colors.grey[100]),
        ),
        child: Text('Back to login'),
      ),
    );
  }
}
*/

class BackToLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                      hintText: 'Search for a Game',
                    ),
                  ),
                ),
                SizedBox(
                    width:
                        8), // Add some space between the input field and button
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your search functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[50],
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Add some space between rows
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'Add',
                      hintText: 'Add a Game',
                    ),
                  ),
                ),
                SizedBox(
                    width:
                        8), // Add some space between the input field and button
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your add functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[50],
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Add some space between rows
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[50],
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.all(16),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
