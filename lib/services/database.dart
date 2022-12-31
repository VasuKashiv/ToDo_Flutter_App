// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/todo.dart';

class DatabaseService {
  CollectionReference todosCollection =
      FirebaseFirestore.instance.collection("Todos");

  Future createNewTodo(String title) async {
    return await todosCollection.add({
      "title": title,
      "isComplet": false,
    });
  }

  Future completTask(uid) async {
    await todosCollection.doc(uid).update({"isComplet": true});
  }

  Future removeTodo(uid) async {
    await todosCollection.doc(uid).delete();
  }

  Future editToDo(uid, newtext) async {
    await todosCollection.doc(uid).update({
      'title': newtext,
    });
  }

  List<ToDoClass> todoFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs.map((e) {
        return ToDoClass(
          isChecked: e['isComplet'],
          title: e['title'],
          uid: e.id,
        );
      }).toList();
    } else {
      return List.empty();
    }
  }

  Stream<List<ToDoClass>> listTodos() {
    return todosCollection.snapshots().map(todoFromFirestore);
  }
}
