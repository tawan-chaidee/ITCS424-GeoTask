import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> registerUser(String username, String password, String email) async {
  try {
    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      return false;
    }

    // Check if the username already exists
    QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return false;
    } else {
      await FirebaseFirestore.instance.collection('User').add({
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
