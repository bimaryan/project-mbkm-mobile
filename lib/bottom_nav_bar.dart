import 'package:flutter/material.dart';
import 'package:project_mbkm/routes.dart';

class BottomNavBar extends StatelessWidget {
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.onTap, required int currentIndex,
  }) : super(key: key);

  int _getCurrentIndex(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    switch (routeName) {
      case Routes.home:
        return 0;
      case Routes.katalog:
        return 1;
      case Routes.informasi:
        return 2;
      case Routes.profile:
        return 3;
      default:
        return 0; // Default to home if route is unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index);

        switch (index) {
          case 0: // Home
            if (ModalRoute.of(context)?.settings.name != Routes.home) {
              Navigator.pushReplacementNamed(context, Routes.home);
            }
            break;
          case 1: // Katalog
            if (ModalRoute.of(context)?.settings.name != Routes.katalog) {
              Navigator.pushReplacementNamed(context, Routes.katalog);
            }
            break;
          case 2: // Informasi
            if (ModalRoute.of(context)?.settings.name != Routes.informasi) {
              Navigator.pushReplacementNamed(context, Routes.informasi);
            }
            break;
          case 3: // Profil
            if (ModalRoute.of(context)?.settings.name != Routes.profile) {
              Navigator.pushReplacementNamed(context, Routes.profile);
            }
            break;
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
      selectedItemColor: const Color(0xFF0E9F6E),
      unselectedItemColor: Colors.grey,
    );
  }
}
