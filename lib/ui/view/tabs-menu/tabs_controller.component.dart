import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TypeIconBottomNav { cupetinoIcons, svg }

class ItemMenuBottomNavigationData {
  final Widget componentPage;
  final String title;
  final dynamic icon;
  final TypeIconBottomNav typeIcon;

  const ItemMenuBottomNavigationData(
      {required this.componentPage,
      required this.title,
      required this.icon,
      required this.typeIcon});
}

class TabsControllerComponent extends StatefulWidget {
  List<ItemMenuBottomNavigationData> itemsMenu;
  Color? primaryColor;
  Color? backgroundColor;

  TabsControllerComponent(
      {this.primaryColor,
      this.backgroundColor,
      required this.itemsMenu,
      super.key});

  @override
  State<TabsControllerComponent> createState() => _TabsControllerState();
}

class _TabsControllerState extends State<TabsControllerComponent> {
  int _selectedIndex = 0;
  List<String> titleItemsMenu = [];
  List<BottomNavigationBarItem> itemsBottomMenu = [];
  List<Widget> pages = [];

  @override
  void initState() {
    generateMenuItems();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: Container(
            padding: const EdgeInsets.only(bottom: 0),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 245, 255),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: pages.elementAt(_selectedIndex),
          )),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: itemsBottomMenu,
            currentIndex: _selectedIndex,
            selectedItemColor: widget.primaryColor,
            selectedLabelStyle: const TextStyle(fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            onTap: _onItemTapped,
          ),
        )));
  }

  generateMenuItems() {
    pages = [];
    for (var i in widget.itemsMenu) {
      pages.add(i.componentPage);
    }

    titleItemsMenu = [];
    for (var i in widget.itemsMenu) {
      titleItemsMenu.add(i.title.toString());
    }

    itemsBottomMenu = [];
    for (var i in widget.itemsMenu) {
      itemsBottomMenu.add(BottomNavigationBarItem(
          icon: _buildIcon(i.typeIcon, i.icon), label: i.title));
    }
  }

  _buildIcon(typeIcon, iconSRC) {
    dynamic icon = Icon(Icons.now_widgets_sharp);
    switch (typeIcon) {
      case TypeIconBottomNav.cupetinoIcons:
        icon = Icon(iconSRC);
        break;
      case TypeIconBottomNav.svg:
        icon = SvgPicture.asset(iconSRC, width: 30, height: 30);
        break;
    }
    return icon;
  }
}
