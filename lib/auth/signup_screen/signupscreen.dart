
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authn/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base/rounded_button.dart';
import '../login_screen/loginscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

   bool loading=false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

   final FirebaseAuth _auth =FirebaseAuth.instance;
  //
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signup(){
      setState(() {
        loading=true;
      });
      _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      ).then((value) {
        setState(() {
          loading=false;
        });

      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        setState(() {
          loading=false;
        });
      });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Signup'),
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
                       // helperText: 'enter email e.g john@gmail.com',
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
              height: 50,
            ),
            Center(
              child: RoundedButton(
                text: 'SignUp',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                       signup();
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 15 ,
                ),
                const Text("Already have an account"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>const LogInScreen(),
                    )
                    );
                  },
                  child: const Text('LogIn'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


