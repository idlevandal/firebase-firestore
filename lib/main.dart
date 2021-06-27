import 'package:firebase_firestore/screens/quotes.dart';
import 'package:firebase_firestore/screens/quotes_future.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/add_quote.dart';

// PROVIDERS
final isDarkThemeProvider = StateProvider<bool>((ref) {
  return false;
});

final themeBrightnessProvider = Provider<Brightness>((ref) {
  final isDark = ref.watch(isDarkThemeProvider).state;
  return isDark ? Brightness.dark : Brightness.light;
});

// use with : theme: watch(themeBrightnessProvider),
// final themeBrightnessProvider = Provider<ThemeData>((ref) {
//   final isDark = ref.watch(isDarkThemeProvider).state;
//   return isDark ? ThemeData.dark() : ThemeData.light();
// });

final tabIndexProvider = StateProvider<int>((ref) {
  return 0;
});
// end Providers

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: watch(themeBrightnessProvider),
        // fontFamily: 'Georgia',
        // textTheme: GoogleFonts.ralewayTextTheme(
        //   // Theme.of(context).textTheme,
        // ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isDarkMode = watch(isDarkThemeProvider).state;
    final selectedIndex = watch(tabIndexProvider).state;

    List<Widget> _screens = [
      Quotes(),
      QuotesFuture(),
      AddQuote()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
        elevation: 0,
        actions: [
          Row(
            children: [
              Text(isDarkMode ? 'Dark mode' : 'Light mode'),
              IconButton(
                onPressed: () {
                  context.read(isDarkThemeProvider).state = !context.read(isDarkThemeProvider).state;
                },
                icon: isDarkMode ? Icon(Icons.toggle_on) : Icon(Icons.toggle_off),
              )
            ],
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _screens[selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.stream),
              label: 'Stream',
          ),BottomNavigationBarItem(
              icon: Icon(Icons.watch_later_outlined),
              label: 'Future',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Quote',
          ),
        ],
        onTap: (index) {
          context.read(tabIndexProvider).state = index;
        },
      ),
    );
  }
}

