import 'package:firebase_firestore/database.dart';
import 'package:flutter/material.dart';

class AddQuote extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _quoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _authorController,
              decoration: InputDecoration(
                hintText: 'Author'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Author is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _quoteController,
              decoration: InputDecoration(
                  hintText: 'Quote'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Quote is required';
                }
                return null;
              },
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  DatabaseService().addQuote(_authorController.value.text, _quoteController.value.text);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Adding quote'), duration: Duration(seconds: 2),));
                  _authorController.clear();
                  _quoteController.clear();
                }
              },
              child: Text('Submit quote'),
            ),
          ],
        ),
      ),
    );
  }
}

