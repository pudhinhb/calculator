import 'package:flutter/material.dart';
import 'provider_calculator.dart';
import 'getx_calculator.dart';
import 'upload_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        fontFamily: 'Roboto', // Add Roboto font in pubspec.yaml if not default
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
          bodyText1: TextStyle(fontSize: 24),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
     ProviderCalculatorScreen(),
    GetXCalculatorScreen(),
    UploadScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Provider',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'GetX',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        onTap: _onItemTapped,
      ),
    );
  }
}
