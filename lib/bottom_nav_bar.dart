import 'package:flutter/material.dart';
import 'package:project_mbkm/routes.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index); // Update the index in the parent widget

        String? selectedRoute;
        switch (index) {
          case 0:
            selectedRoute = Routes.home;
            break;
          case 1:
            selectedRoute = Routes.katalog;
            break;
          case 2:
            selectedRoute = Routes.informasi;
            break;
          case 3:
            selectedRoute = Routes.profile;
            break;
        }

        if (selectedRoute != null &&
            ModalRoute.of(context)?.settings.name != selectedRoute) {
          Navigator.pushReplacementNamed(context, selectedRoute);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Katalog',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Informasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      selectedItemColor:
          const Color(0xFF0E9F6E), // Green color for selected item
      unselectedItemColor: Colors.grey, // Grey color for unselected items
    );
  }
}
