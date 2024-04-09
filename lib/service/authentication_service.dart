import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkLogin(String username, String password) async {
  try {
    QuerySnapshot<Object?> querySnapshot =
        await FirebaseFirestore.instance.collection('User').get();

    for (var doc in querySnapshot.docs) {
      var userData = doc.data() as Map<String, dynamic>;
      if (userData['username'] == username) {
        if (userData['password'] == password) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  } catch (error) {
    return false;
  }
}
