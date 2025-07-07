import 'package:flutter/material.dart';
import 'package:rent_app/features/home/screens/homescreen.dart';
import 'package:rent_app/features/maps/screens/map_screen.dart';
import 'package:rent_app/features/messages/screens/message_screen.dart';
import 'package:rent_app/features/profile/screens/profile_screen.dart';
import 'package:rent_app/features/wishlist/screens/wishlist_screen.dart';

class Tabcontroller extends StatefulWidget {
  const Tabcontroller({super.key});

  @override
  State<Tabcontroller> createState() => _TabcontrollerState();
}

class _TabcontrollerState extends State<Tabcontroller> {
  int _index = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    MapScreen(),
    WishListScreen(),
    MessageScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favourites'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
