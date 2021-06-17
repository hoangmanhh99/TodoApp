import 'package:demo_appbar/models/category.dart';
import 'package:demo_appbar/screens/home_screen.dart';
import 'package:demo_appbar/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:demo_appbar/helpers/snackbar.dart';

class CategoriesScreen extends StatefulWidget {
  // const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryName = TextEditingController();
  var _categoryDescription = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();
  var _categoryList = <Category>[];

  var _editCategoryName = TextEditingController();

  var _editCategoryDescription = TextEditingController();

  var category;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = <Category>[];
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        var model = Category();
        model.id = category['id'];
        model.name = category['name'];
        model.description = category['description'];
        _categoryList.add(model);
      });
    });
  }

  _showFormInDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () async {
                    _category.name = _categoryName.text;
                    _category.description = _categoryDescription.text;
                    var result = await _categoryService.saveCategory(_category);
                    print(result);
                    Navigator.pop(context);
                    getAllCategories();
                    showSnackBar(Text('Success'));
                  },
                  child: Text('Save'))
            ],
            title: Text('Category form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryName,
                    decoration: InputDecoration(
                        labelText: 'Category Name',
                        hintText: 'Write category name'),
                  ),
                  TextField(
                    controller: _categoryDescription,
                    decoration: InputDecoration(
                        labelText: 'Category Description',
                        hintText: 'Write category description'),
                  )
                ],
              ),
            ),
          );
        });
  }

  _editCategoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () async {
                    _category.id = category[0]['id'];
                    _category.name = _editCategoryName.text;
                    _category.description = _editCategoryDescription.text;
                    var result =
                        await _categoryService.updateCategory(_category);
                    print(result);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllCategories();
                      showSnackBar(Text('Success'));
                    }
                  },
                  child: Text('Update'))
            ],
            title: Text('Category Edit form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editCategoryName,
                    decoration: InputDecoration(
                        labelText: 'Category Name',
                        hintText: 'Write category name'),
                  ),
                  TextField(
                    controller: _editCategoryDescription,
                    decoration: InputDecoration(
                        labelText: 'Category Description',
                        hintText: 'Write category description'),
                  )
                ],
              ),
            ),
          );
        });
  }

  _deleteCategoryDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.green,
                  child: Text('Cancel', style: TextStyle(color: Colors.white),)),
              FlatButton(
                  onPressed: () async {
                    await _categoryService.deleteCategory(categoryId);
                    Navigator.pop(context);
                    getAllCategories();
                    showSnackBar(Text('Success'));
                  },
                  color: Colors.red,
                  child: Text('Delete', style: TextStyle(color: Colors.white),))
            ],
            title: Text('Are you sure, You want to delete?'),
          );
        });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.getCategoryById(categoryId);
    setState(() {
      _editCategoryName.text = category[0]['name'] ?? "No Name";
      _editCategoryDescription.text =
          category[0]['description'] ?? "No description";
    });

    _editCategoryDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: RaisedButton(
          elevation: 0.0,
          color: Colors.red,
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => new HomeScreen()));
          },
        ),
        title: Text('App Todo'),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editCategory(context, _categoryList[index].id);
                      },
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_categoryList[index].name!),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            _deleteCategoryDialog(context, _categoryList[index].id);
                          },
                        )
                      ],
                    )));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormInDialog(context);
          _categoryName.text = "";
          _categoryDescription.text = "";
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
