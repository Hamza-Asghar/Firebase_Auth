import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authn/auth/login_screen/loginscreen.dart';
import 'package:firebase_authn/utils/utils.dart';
import 'package:firebase_authn/views/post/add_post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Post'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInScreen())).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
          ),

          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: const Text('Loading'),
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                Map <dynamic  , dynamic> post = snapshot.value as Map;
                Map <dynamic  , dynamic> comments = post['Comments'];
                final title=comments['title'].toString();
                if(searchFilter.text.isEmpty){
                  return ListTile(
                    title: Text(comments['title'].toString()),
                    subtitle: Text(comments['id'].toString()),
                    trailing: PopupMenuButton(
                        itemBuilder: (context)=>[
                           PopupMenuItem(
                            value:1,
                              child: ListTile(
                                 onTap: (){
                                   Navigator.pop(context);
                                   showMyDialogue(title , comments['id'].toString());
                                 },
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),

                              ),
                          ),
                           PopupMenuItem(
                            onTap: (){
                              ref.child(comments['id'].toString()).remove();
                            },
                            value:1,
                            child: const ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),

                            ),
                          ),
                        ]
                    ),
                  );
                }
                else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())){
                  return ListTile(
                    title: Text(comments['title'].toString()),
                    subtitle: Text(comments['id'].toString()),
                  );
                }
                else{
                  return Container();
                }

              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showMyDialogue (String title, String id)async{
    editController.text=title;

    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(

              controller: editController,
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    ref.child(id).child('Comments').update({
                      'title':editController.text.toString(),
                    }).then((value){
                      Utils().toastMessage('Post Updated');
                    }).onError((error, stackTrace){
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')
              ),
            ],
          );
        }
    );
  }
}
















///Stream builder data fetching from firebase
// Expanded(
// child: StreamBuilder(
// stream: ref.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
// if (!snapshot.hasData) {
// return const CircularProgressIndicator();
// } else {
// Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = map.values.toList();
//
// return ListView.builder(
// itemCount: list.length,
// itemBuilder: (context, index) {
//
// Map<dynamic, dynamic> post = list[index] as Map;
// Map<dynamic, dynamic> comments = post['Comments'] as Map;
// return ListTile(
// title: Text(comments['title'].toString()),
// subtitle: Text(comments['id'].toString()),
// );
// },
// );
// }
// },
// ),
// ),
