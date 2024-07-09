import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authn/auth/login_screen/loginscreen.dart';
import 'package:firebase_authn/utils/utils.dart';
import 'package:flutter/material.dart';

import '../views/post/post.dart';

class SplashServices{
  void isLogin (BuildContext context){

    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;

    if(user!=null){
      Timer(const Duration(seconds: 3),()=>
          Navigator.push(context , MaterialPageRoute(builder: (context)=>
          const Post()))

      );
    }else{
      Timer(const Duration(seconds: 3),()=>
          Navigator.push(context , MaterialPageRoute(builder: (context)=>
          const LogInScreen()))

      );
    }


  }
}