import 'package:firebase_firestore/database.dart';
import 'package:firebase_firestore/main.dart';
import 'package:firebase_firestore/screens/quotes_future.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddQuote extends ConsumerWidget {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _quoteController = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isDarkMode = watch(isDarkThemeProvider).state;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            isDarkMode ? ColorFiltered(
              // colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              colorFilter: ColorFilter.matrix([
                //R  G   B    A  Const
                -1, 0, 0, 0, 303, //
                0, -1, 0, 0, 303, //
                0, 0, -1, 0, 303, //
                0, 0, 0, 1, 0, //
              ]),
              child: Image.asset('assets/background.png'),
            ) : Image.asset('assets/background.png'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30.0,),
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
                        context.refresh(quotesFutureProvider);
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                      child: Text('Add quote'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

