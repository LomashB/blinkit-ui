import 'package:blinkit/repository/screens/cart/cartscreen.dart';
import 'package:blinkit/repository/screens/category/categoryscreen.dart';
import 'package:blinkit/repository/screens/home/Homescreen.dart';
import 'package:blinkit/repository/screens/print/printscreen.dart';
import 'package:blinkit/repository/widgets/uihelper.dart' as customUiHelper;
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BottomNavScreen extends StatefulWidget {
  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _controller;

  final List<Widget> pages = [
    HomeScreen(),
    CartScreen(),
    CategoryScreen(),
    PrintScreen()
  ];

  final List<NavItem> items = [
    NavItem(icon: "home 1.png", label: "Home", activeColor: Colors.blue),
    NavItem(icon: "shopping-bag 1.png", label: "Cart", activeColor: Colors.green),
    NavItem(icon: "category 1.png", label: "Categories", activeColor: Colors.orange),
    NavItem(icon: "printer 1.png", label: "Print", activeColor: Colors.purple),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                items.length,
                    (index) => _buildNavItem(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
        _controller.reset();
        _controller.forward();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? items[index].activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.8,
                end: isSelected ? 1.2 : 0.8,
              ),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: customUiHelper.UiHelper.CustomImage(
                    img: items[index].icon,

                  ),
                );
              },
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(20 * (1 - value), 0),
                      child: Text(
                        items[index].label,
                        style: TextStyle(
                          color: items[index].activeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final String icon;
  final String label;
  final Color activeColor;

  NavItem({
    required this.icon,
    required this.label,
    required this.activeColor,
  });
}