import 'package:flutter/material.dart';
import '/core/utils/helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> _titles = ['Home', 'Learn', 'About', 'Settings'];
  final List<IconData> _icons = [
    CupertinoIcons.home,
    CupertinoIcons.book,
    CupertinoIcons.info_circle,
    CupertinoIcons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.transparent,
        items: List.generate(
          _titles.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(_icons[index]),
            label: _titles[index],
          ),
        ),
        onTap: (value) {
          // Handle tab change
          print("Selected tab: $value");
          setState(() {
            // Update the state if needed
          });
        },
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return _getTabPage(index);
          },
        );
      },
    );
  }

  Widget _getTabPage(int index) {
    // Return the corresponding page based on the index
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const LearnPage();
      case 2:
        return const AboutPage();
      case 3:
        return const SettingsPage();
      default:
        return const Center(child: Text('Page not found'));
    }
  }
}
