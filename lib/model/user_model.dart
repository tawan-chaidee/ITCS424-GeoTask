import 'package:geotask/model/todo_model.dart';

class User {
  final String username;
  final String password;
  final Todo todo;

  User({required this.username, required this.password, required this.todo});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      todo: Todo.fromMap(map['todo']),
    );
  }
}
