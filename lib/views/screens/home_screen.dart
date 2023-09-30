import 'package:flutter/material.dart';
import 'package:two_sents/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;

  void changePage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Row(
      children: [
        NavigationRail(
          onDestinationSelected: changePage,
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.data_object),
              selectedIcon: Icon(Icons.data_object),
              label: Text('Training Data'),
            ),
          ],
          selectedIndex: _selectedPage,
        ),
        const VerticalDivider(
          width: 1,
        ),
        Expanded(child: pages[_selectedPage])
      ],
    )));
  }
}
