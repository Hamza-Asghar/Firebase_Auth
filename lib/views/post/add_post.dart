import 'package:firebase_authn/base/rounded_button.dart';
import 'package:firebase_authn/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController =TextEditingController();
  bool loading = false;
  final databaseRef=FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 30,),
             TextFormField(
               controller: postController,
               maxLines: 3,
               decoration: const InputDecoration(
                 hintText:  "What's in your mind",
                 border: OutlineInputBorder(),
               ),
             ),
            const SizedBox(height: 30,),
            RoundedButton(
                text: 'Add',
                loading:loading,
                onTap: (){
                  setState(() {
                    loading=false;
                  });
               String id=DateTime.now().millisecond.toString();
              databaseRef.child(id).child('Comments').set({
                'id':id,
                'title':postController.text.toString()
              }).then((value){
                Utils().toastMessage('Post Added');
                loading=false;
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
                loading=false;
              });
            }),
          ],
        ),
      ),
    );
  }
}
