import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authn/auth/login_with_phone_number/login_with_phone_number.dart';
import 'package:firebase_authn/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../base/rounded_button.dart';
import '../../views/post/post.dart';
import '../signup_screen/signupscreen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool loading=false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login(){
    setState(() {
      loading=true;
    });
    _auth.signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value){
      setState(() {
        loading=false;
      });
          Utils().toastMessage(value.user!.email.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Post()));

    }).onError((error, stackTrace) {
      setState(() {
        loading=false;
      });
      Utils().toastMessage(error.toString());

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('LogIn'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:18.0),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "email",
                      //helperText: 'enter email e.g john@gmail.com',
                      prefixIcon: Icon(Icons.alternate_email_sharp),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "password",
                      //helperText: 'enter password e.g arch12.khan',
                      prefixIcon: Icon(Icons.password_sharp),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Center(
            child: RoundedButton(
              text: 'Login',
              loading: loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  login();
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 15,
              ),
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>const SignUpScreen(),
                  )
                  );
                },
                child: const Text('signUp'),
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginWithPhoneNumber()));

            },
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.black45,
                )
              ),
              child: const Center(child: Text('Login with phone number'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
