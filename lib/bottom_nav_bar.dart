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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
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
          backgroundColor: Colors.white,
          elevation: 0,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            onTap(index);

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
              icon: Icon(Icons.home, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list, size: 28),
              label: 'Katalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info, size: 28),
              label: 'Informasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 28),
              label: 'Profil',
            ),
          ],
          selectedItemColor:
              const Color(0xFF0E9F6E), // Green color for selected item
          unselectedItemColor: Colors.grey, // Grey for unselected items
          selectedLabelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
