import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterException implements Exception {
  String cause;
  RegisterException(this.cause);
}

Future<bool> registerUser(
    String username, String password, String email) async {
  if (username.isEmpty || password.isEmpty || email.isEmpty) {
    // return "Please fill in the username, password, and email fields.";
    throw RegisterException("Please fill in the username, password, and email fields.");
  }

  // Check if the username already exists
  QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
      .collection('User')
      .where('username', isEqualTo: username)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // return "Username already exists.";
    throw RegisterException("Username already exists.");
  } else {
    try {
      await FirebaseFirestore.instance.collection('User').add({
        'username': username,
        'password': password,
      });
    } catch (error) {
      print('Error registering user: $error');
      // return "An error occurred. Please try again later.";
      throw RegisterException("An error occurred. Please try again later.");
    }

    return true;
  }
}
