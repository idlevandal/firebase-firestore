import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/quote.dart';

class DatabaseService {
  // collection reference
  final CollectionReference quotesCollection = FirebaseFirestore.instance.collection('quotes');

  Future updateQuote(String author, String quote, String id) async {
    return await quotesCollection.doc(id).set({
      'quote': quote,
      'author': author
    });
  }

  Future<void> addQuote(String author, String quote) async {
    final DocumentReference res = await quotesCollection.add({
      'author': author,
      'quote': quote,
    });
    print('$res has been added.');
  }

  Future<void> deleteQuote(String id) async {
    await quotesCollection.doc(id).delete();
    print('Quote with id $id has been deleted.');
  }

  Future<List<Quote>> getQuotes() async {
    final a = await quotesCollection.get();
    return a.docs.map((e) => Quote(author: e['author'], quote: e['quote'], id: e.id)).toList();
  }

  // get quotes stream
  Stream<List<Quote>> get quotes {
    return quotesCollection.snapshots()
      .map((snapshot) => _quoteListFromSnapshot(snapshot));
  }

  // brew list from snapshot
  List<Quote> _quoteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Quote(
        // used to be doc.data()['propertyName'];
        author: doc['author'],
        quote: doc['quote'],
        id: doc.id,
      );
    }).toList();
  }
}