// ignore_for_file: prefer_const_constructors, dead_code, avoid_print, unused_local_variable, prefer_typing_uninitialized_variables, iterable_contains_unrelated_type

import 'package:flutter/material.dart';
import 'package:todoapp/services/database.dart';

import '../models/todo.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  TextEditingController todoTitleController = TextEditingController();
  List<TextEditingController> editToDoTitleController = [];
  var selectedEditIndex;
  bool showTextField = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xffEBEBEB),
        body: Container(
          margin: EdgeInsets.all(25),
          child: StreamBuilder<List<ToDoClass>>(
            stream: DatabaseService().listTodos(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                ));
              }
              List<ToDoClass>? todos = snapshot.data;

              return Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'TO DO App',
                      style:
                          TextStyle(fontSize: 42, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          elevation: 10.0,
                          shadowColor: Color.fromARGB(255, 82, 82, 82),
                          child: TextFormField(
                            controller: todoTitleController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Type Something here...',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 56, 56, 56)),
                                filled: true,
                                fillColor: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black),
                        // color: Colors.black,
                        child: IconButton(
                          iconSize: 40,
                          onPressed: () async {
                            if (todoTitleController.text.isNotEmpty) {
                              await DatabaseService().createNewTodo(
                                  todoTitleController.text.trim());
                            }
                            todoTitleController.clear();
                          },
                          color: Colors.white,
                          icon: Icon(
                            Icons.add,
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: todos!.length,
                        itemBuilder: (context, index) {
                          editToDoTitleController = [
                            for (int i = 0; i < todos.length; i++)
                              (TextEditingController())
                          ];

                          return Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Card(
                              color: Colors.white,
                              shadowColor: Color.fromARGB(255, 82, 82, 82),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide.none),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                          color: todos[index].isChecked!
                                              ? Colors.green
                                              : Colors.black,
                                          iconSize: 36,
                                          onPressed: () {
                                            DatabaseService()
                                                .completTask(todos[index].uid);
                                          },
                                          icon: Icon(
                                            Icons.check_circle_outline,
                                          )),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: showTextField
                                          ? TextField(
                                              onSubmitted: (value) {
                                                var title;

                                                showTextField = false;
                                                title = value;
                                                editToDoTitleController[index]
                                                    .text = title;
                                                DatabaseService().editToDo(
                                                    todos[index].uid, title);

                                                print(editToDoTitleController[
                                                        index]
                                                    .text);
                                              },
                                              // autofocus: true,
                                              controller:
                                                  editToDoTitleController[
                                                      index],
                                              decoration: InputDecoration(
                                                  isDense: true),
                                              style: TextStyle(fontSize: 18),
                                            )
                                          : Text(
                                              todos[index].title!,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        iconSize: 36,
                                        onPressed: () {
                                          setState(() {
                                            showTextField = true;
                                          });
                                        },
                                        icon: Icon(Icons.edit_note),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        iconSize: 36,
                                        onPressed: () {
                                          DatabaseService()
                                              .removeTodo(todos[index].uid);
                                        },
                                        icon: Icon(Icons.delete_outline),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
