import 'package:firebase_firestore/quotes.dart';
import 'package:firebase_firestore/quotes_future.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

// PROVIDERS
final isDarkThemeProvider = StateProvider<bool>((ref) {
  return false;
});

final themeBrightnessProvider = Provider<ThemeData>((ref) {
  final isDark = ref.watch(isDarkThemeProvider).state;
  return isDark ? ThemeData.dark() : ThemeData.light();
});

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
      theme: watch(themeBrightnessProvider),
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
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
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
              backgroundColor: Colors.blue
          ),BottomNavigationBarItem(
              icon: Icon(Icons.watch_later_outlined),
              label: 'Future',
              backgroundColor: Colors.blue
          ),
        ],
        onTap: (index) {
          context.read(tabIndexProvider).state = index;
        },
      ),
    );
  }
}

