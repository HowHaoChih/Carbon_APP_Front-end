import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import '../widgets/city_chart.dart'; // 引入碳排放圖表的 widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 預設選擇的城市名稱，初始值為 "台北市"
  String selectedCity = "台北市";

  // 所有產業選項
  final List<String> allDepartments = [
    "Residential",
    "Services",
    "Energy",
    "Manufacturing",
    "Transportation",
    "Electricity"
  ];

  // 初始選中的產業
  Set<String> selectedDepartments = {
    "Residential",
    "Services",
    "Energy",
    "Manufacturing",
    "Transportation",
    "Electricity"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      // Scaffold 是 Flutter 提供的基礎頁面框架，包含 appBar、drawer 和 body

      body: Padding(
        padding: const EdgeInsets.all(16.0), // 整個頁面內容四周的內邊距
        child: Column(
          children: [
            // 全國碳排放趨勢圖表
            Expanded(
              flex: 2, // 占用父容器 2 倍的空間
              child: CityChart(
                city: "Total",
                selectedDepartments: selectedDepartments,
              ), // 顯示全國碳排放趨勢的自定義 widget
            ),
            const SizedBox(height: 16), // 垂直間距
            // 城市碳排放趨勢圖
            Expanded(
              flex: 2, // 占用父容器 2 倍的空間
              child: Column(
                children: [
                  // 城市選擇下拉選單
                  DropdownButton<String>(
                    value: selectedCity, // 當前選中的城市
                    items: const [
                      // 縣市選項列表
                      "南投縣",
                      "台中市",
                      "台北市",
                      "台南市",
                      "台東縣",
                      "嘉義市",
                      "嘉義縣",
                      "基隆市",
                      "宜蘭縣",
                      "屏東縣",
                      "彰化縣",
                      "新北市",
                      "新竹市",
                      "新竹縣",
                      "桃園市",
                      "澎湖縣",
                      "花蓮縣",
                      "苗栗縣",
                      "連江縣",
                      "金門縣",
                      "雲林縣",
                      "高雄市"
                    ].map((String city) {
                      // 將每個城市名稱轉為 DropdownMenuItem
                      return DropdownMenuItem<String>(
                        value: city, // 城市名稱
                        child: Text(city), // 顯示城市名稱
                      );
                    }).toList(),
                    onChanged: (value) {
                      // 當用戶選擇不同的城市時觸發
                      setState(() {
                        selectedCity = value!; // 更新選中的城市
                      });
                    },
                  ),
                  // 城市碳排放趨勢圖表
                  Expanded(
                    child: CityChart(
                      city: selectedCity,
                      selectedDepartments: selectedDepartments,
                    ), // 顯示選中城市的碳排放數據
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
