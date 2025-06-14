import 'package:flutter/material.dart';
import 'profile_tab.dart';
import 'friends_tab.dart';
import 'rooms_tab.dart';

/// 主页
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const RoomsTab(),
    const FriendsTab(),
    const ProfileTab(),
  ];
  
  final List<String> _tabTitles = ['对局', '好友', '我的'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.games),
            label: _tabTitles[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: _tabTitles[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: _tabTitles[2],
          ),
        ],
      ),
    );
  }
} 