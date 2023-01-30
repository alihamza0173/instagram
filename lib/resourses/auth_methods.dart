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
    Uint8List? file,
  }) async {
    String res = 'Some Error';
    try {
      //register user
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      late String profilePhotoUrl;
      if(file != null ) {
        await StorageMethods.uploadImageToStorage(childName: 'profilePics', file: file, isPost: false);
      }
      else{
        profilePhotoUrl = 'https://firebasestorage.googleapis.com/v0/b/instagram-b849d.appspot.com/o/profilePics%2Fdp0zmTNZfdTnQwFt9e1o1HyAPXu1?alt=media&token=1b938f6d-d683-4d00-8a71-0cd23ef80cd1'; 
      }

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

    } on FirebaseAuthException catch (error) {
      res = error.toString();
    }
    return res;
  }
  //end of signup user method

  //login user
  static Future<String> loginUser({required String email, required String password,}) async{
    String res = 'Some Error';
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'Logged in Successfully';
    } on FirebaseAuthException catch(error){
      return(error.toString());
    }
    return res;
  }

}
