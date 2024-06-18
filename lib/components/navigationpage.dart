import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onFabPressed;

  const NavigationPage({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onFabPressed,
  }) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => widget.onItemSelected(0),
          ),
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () => widget.onItemSelected(1),
          ),
        ],
      ),
    );
  }
}
