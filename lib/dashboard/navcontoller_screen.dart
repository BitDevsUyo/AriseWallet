import 'package:bitdevs_project/dashboard/dashboardscreen.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:flutter/material.dart';

class NavControllerScreen extends StatefulWidget {
  const NavControllerScreen({super.key});

  @override
  State<NavControllerScreen> createState() => _NavControllerScreenState();
}

class _NavControllerScreenState extends State<NavControllerScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: kdarkgraycolor,
          border: BoxBorder.fromLTRB(top: BorderSide(color:Theme.of(context).colorScheme.tertiary )),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor:Theme.of(context).colorScheme.background,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: korangeColor,
            unselectedItemColor: Colors.grey.shade600,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Portfolio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.swap_horiz_rounded),
                label: 'Swap',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.language_rounded),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}