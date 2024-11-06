import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'provider_calculator.dart';
import 'getx_calculator.dart';
import 'upload_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        fontFamily: 'Roboto', 
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
          bodyText1: TextStyle(fontSize: 24),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final RxInt _selectedIndex = 0.obs;  

  final List<Widget> _screens = [
    ProviderCalculatorScreen(),
    GetXCalculatorScreen(),
    UploadScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[_selectedIndex.value]), 
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
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
          currentIndex: _selectedIndex.value, 
          selectedItemColor: Colors.purple, 
          unselectedItemColor: Colors.grey, 
          iconSize: MediaQuery.of(context).size.width * 0.08, 
          onTap: (index) {
            _selectedIndex.value = index;
          },
        );
      }),
    );
  }
}
