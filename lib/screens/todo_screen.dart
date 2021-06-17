import 'package:demo_appbar/models/todo.dart';
import 'package:demo_appbar/services/category_service.dart';
import 'package:demo_appbar/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo_appbar/helpers/snackbar.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoService = TodoService();
  var todoObj = Todo();
  var _todoTitle = TextEditingController();

  var _todoDescription = TextEditingController();

  var _todoDate = TextEditingController();

  var _categories = <DropdownMenuItem>[];

  var _selectedValue;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _date = DateTime.now();

  _selectTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2099));
    if (_pickedDate != null) {
      setState(() {
        _date = _pickedDate;
        _todoDate.text = DateFormat('dd-MM-yyyy').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _todoTitle,
            decoration:
                InputDecoration(hintText: 'Todo Title', labelText: 'Cook Food'),
          ),
          TextField(
            controller: _todoDescription,
            decoration: InputDecoration(
                hintText: 'Todo Description', labelText: 'Cook rice and curry'),
          ),
          TextField(
              controller: _todoDate,
              decoration: InputDecoration(
                  hintText: 'DD-MM-YY',
                  labelText: 'DD-MM-YY',
                  prefixIcon: InkWell(
                      onTap: () {
                        _selectTodoDate(context);
                      },
                      child: Icon(Icons.calendar_today)))),
          DropdownButtonFormField(
            value: _selectedValue,
            items: _categories,
            hint: Text('Select one category'),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
          RaisedButton(
            onPressed: () async {

              todoObj.title = _todoTitle.text;
              todoObj.description = _todoDescription.text;
              todoObj.todoDate = _todoDate.text;
              todoObj.category = _selectedValue.toString();
              todoObj.isFinished = 0;


              var result = await _todoService.insertTodo(todoObj);
              print(result);
              if (result > 0) {
                showSnackBar(Text('Success'));
              }
            },
            child: Text('Save'),
          )
        ],
      ),
    );
  }
}
