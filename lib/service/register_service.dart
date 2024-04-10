import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> registerUser(String username, String password, String email) async {
  try {
    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      return false;
    }

    // Check if the username already exists
    DocumentSnapshot<Object?> documentSnapshot = await FirebaseFirestore.instance
        .collection('User')
        .doc(username) 
        .get();

    if (documentSnapshot.exists) {
      return false; 
    } else {
      await FirebaseFirestore.instance.collection('User').doc(username).set({
        'username': username,
        'password': password,
      });
      return true;
    }
  } catch (error) {
    print('Error registering user: $error');
    return false;
  }
}
