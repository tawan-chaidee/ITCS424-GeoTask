import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkLogin(String username, String password) async {
  try {
    QuerySnapshot<Object?> querySnapshot =
        await FirebaseFirestore.instance.collection('User').get();

    for (var doc in querySnapshot.docs) {
      var userData = doc.data() as Map<String, dynamic>;
      if (userData['username'] == username) {
        if (userData['password'] == password) {
          // print('Login successful');
          return true;
        } else {
          //print('Incorrect password');
          return false;
        }
      }
    }
    print('User not found');
    return false;
  } catch (error) {
    print('Error checking login: $error');
    return false;
  }
}
