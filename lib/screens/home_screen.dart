import 'package:demo_appbar/Helpers/drawer_navigation.dart';
import 'package:demo_appbar/models/todo.dart';
import 'package:demo_appbar/screens/todo_screen.dart';
import 'package:demo_appbar/services/todo_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService? _todoService;
  var _todoList = <Todo>[];

  // @override
  // void initState() {
  //   super.initState();
  //   getAllTodos();
  // }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = <Todo>[];
    var todos = await _todoService?.getTodos();
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Todo"),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_todoList[index].title ?? "No Title")
                  ],
                ),
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TodoScreen()));
      },
      child: Icon(Icons.add),),
    );
  }
}
