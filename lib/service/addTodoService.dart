import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geotask/model/todo_model.dart';

Future<bool> addTodo(String todoId, Todo todo) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    await _firestore.collection('Todo').doc(todoId).set(todo.toMap());
    return true;
  } catch (error) {
    print('Error adding todo: $error');
    return false;
  }
}
