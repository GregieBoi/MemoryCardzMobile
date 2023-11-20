import 'package:flutter/material.dart';
import 'package:mobile_project/screens/LoginScreen.dart';
import 'package:mobile_project/screens/HubScreen.dart';
import 'package:mobile_project/screens/RegisterScreen.dart';
import 'package:mobile_project/screens/GamesScreen.dart';
import 'package:mobile_project/screens/ShelfScreen.dart';
import 'package:mobile_project/screens/FollowerScreen.dart';
import 'package:mobile_project/screens/FollowingScreen.dart';
import 'package:mobile_project/screens/GameScreen.dart';
import 'package:mobile_project/screens/ReviewsScreen.dart';
import 'package:mobile_project/screens/ReviewScreen.dart';
import 'package:mobile_project/screens/UserScreen.dart';
import 'package:mobile_project/screens/DiaryScreen.dart';
import 'package:mobile_project/screens/ListsScreen.dart';

class Routes {
  static const String LOGINSCREEN = '/login';
  static const String HUBSCREEN = '/hub';
  static const String REGISTERSCREEN = '/register';
  static const String GAMESSCREEN = '/games';
  static const String SHELFSCREEN = '/shelf';
  static const String FOLLOWERSCREEN = '/follower';
  static const String FOLLOWINGSCREEN = '/following';
  static const String GAMESCREEN = '/game';
  static const String REVIEWSSCREEN = '/reviews';
  static const String REVIEWSCREEN = '/review';
  static const String USERSCREEN = '/user';
  static const String DIARYSCREEN = '/diary';
  static const String LISTSSCREEN = '/lists';


  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
        '/': (context) => LoginScreen(),
        LOGINSCREEN: (context) => LoginScreen(),
        HUBSCREEN: (context) => HubScreen(),
        REGISTERSCREEN: (context) => RegisterScreen(),
        GAMESSCREEN: (context) => GamesScreen(),
        SHELFSCREEN: (context) => ShelfScreen(),
        FOLLOWERSCREEN: (context) => FollowerScreen(),
        FOLLOWINGSCREEN: (context) => FollowingScreen(),
        GAMESCREEN: (context) => GameScreen(),
        REVIEWSSCREEN: (context) => ReviewsScreen(),
        REVIEWSCREEN: (context) => ReviewScreen(),
        USERSCREEN: (context) => UserScreen(),
        DIARYSCREEN: (context) => DiaryScreen(),
        LISTSSCREEN: (context) => ListsScreen(),
      };
}
