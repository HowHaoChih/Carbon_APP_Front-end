// bottom_navigation_bar.dart
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTabTapped,
    super.key, // 使用 super.key 的簡化語法
  });

  @override
  Widget build(BuildContext context) {
    // 子頁面列表
    return BottomNavigationBar(
      currentIndex: currentIndex, // 當前選中的索引
      onTap: onTabTapped, // 點擊切換頁面
      selectedItemColor: Colors.green[700], // 設定選中項目的顏色，這裡使用淺綠色
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
