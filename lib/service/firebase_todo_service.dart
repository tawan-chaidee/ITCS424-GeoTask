import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geotask/model/todo_model.dart';
import 'package:geotask/provider/user_provider.dart';

Future<bool> addTodo(String todoId, Todo todo) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    await User.init();
    final String userId = User.getUserId();
    print("test: ${userId}");

    if (userId.isEmpty) {
      print('User ID not available');
      return false;
    }

    final userRef = _firestore.collection('User').doc(userId);
    final todoRef = userRef.collection('Todo').doc(todoId);

    await todoRef.set(todo.toMap());

    print('Todo added successfully');
    return true;
  } catch (error) {
    print('Error adding todo: $error');
    return false;
  }
}

Future<bool> editTodo(String todoId, Todo todo) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    await User.init();
    final String userId = User.getUserId();
    print("test: ${userId}");

    if (userId.isEmpty) {
      print('User ID not available');
      return false;
    }

    final userRef = _firestore.collection('User').doc(userId);
    final todoRef = userRef.collection('Todo').doc(todoId);
  
    // make sure id is matching
    var newTodo = todo.toMap();
    newTodo['id'] = todoId;

    await todoRef.update(todo.toMap());

    print('Todo updated successfully');
    return true;
  } catch (error) {
    print('Error updating todo: $error');
    return false;
  }
}