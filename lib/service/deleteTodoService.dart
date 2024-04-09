import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> deleteTodo(String todoId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    await _firestore.collection('Todo').doc(todoId).delete();
    return true;
  } catch (error) {
    print('Error deleting todo: $error');
    return false;
  }
}
