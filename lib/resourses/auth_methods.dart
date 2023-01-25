import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/resourses/storage_methods.dart';

class AuthMethods {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //signup user
  static Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some Error';
    try {
      //register user
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String profilePhotoUrl = await StorageMethods.uploadImageToStorage(childName: 'profilePics', file: file, isPost: false);

      //add user to database
      await firestore.collection('users').doc(credential.user!.uid).set({
        'username': username,
        'uid': credential.user!.uid,
        'email': email,
        'bio': bio,
        'followers': [],
        'following': [],
        'profilePhotoUrl': profilePhotoUrl,
      });

      res = 'User Created Successfully';

    } catch (error) {
      res = error.toString();
    }
    return res;
  }
  //end of signup user method

  //login user
  static Future<void> loginUser({required String email, required String password,}) async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password).then((value) => print('Success'));
    } on FirebaseAuthException catch(error){
      print(error.code);
    }
  }

}
