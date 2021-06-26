import 'package:firebase_firestore/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/quote.dart';

final quotesProvider = StreamProvider<List<Quote>>((ref) {
  return DatabaseService().quotes;
});

class Quotes extends ConsumerWidget {
  const Quotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final quotes = watch(quotesProvider);

    return quotes.when(
        loading: () => CircularProgressIndicator(),
        error: (err, stack) => Text(err.toString()),
        data: (data) => ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(height: 4.0,);
          },
          itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  // decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //         colors: [Color(0xFFEEEEEE), Color(0xFFDDDDDD)],
                  //         begin: Alignment.topLeft,
                  //         end: Alignment.bottomRight
                  //     )
                  // ),
                  child: ListTile(
                    trailing: Icon(Icons.book_outlined, color: Colors.blue,),
                    title: Text('Author: ${data[index].author}'),
                    subtitle: Text(data[index].quote),
                  ),
                ),
              );
            }
        )
    );
  }
}
