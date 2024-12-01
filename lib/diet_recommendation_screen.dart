import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';

class DietRecommendationScreen extends StatefulWidget {
  const DietRecommendationScreen({Key? key}) : super(key: key);

  @override
  _DietRecommendationScreenState createState() =>
      _DietRecommendationScreenState();
}

class _DietRecommendationScreenState extends State<DietRecommendationScreen> {
  final List<Map<String, dynamic>> _foodItems = [
    {"이름": "닭가슴살", "탄수화물": 0.0, "단백질": 31.0, "지방": 3.5},
    {"이름": "고구마", "탄수화물": 20.1, "단백질": 1.6, "지방": 0.1},
    {"이름": "아몬드", "탄수화물": 21.7, "단백질": 21.1, "지방": 50.6},
    {"이름": "현미밥", "탄수화물": 23.0, "단백질": 2.4, "지방": 0.5},
    {"이름": "연어", "탄수화물": 0.0, "단백질": 25.0, "지방": 13.0},
    {"이름": "브로콜리", "탄수화물": 7.0, "단백질": 2.8, "지방": 0.4},
    {"이름": "삶은 달걀", "탄수화물": 1.1, "단백질": 13.0, "지방": 10.0},
    {"이름": "우유", "탄수화물": 12.0, "단백질": 8.0, "지방": 7.9},
    {"이름": "참치캔", "탄수화물": 0.0, "단백질": 24.0, "지방": 5.0},
    {"이름": "사과", "탄수화물": 13.8, "단백질": 0.3, "지방": 0.2},
    {"이름": "바나나", "탄수화물": 22.8, "단백질": 1.1, "지방": 0.3},
    {"이름": "체다 치즈", "탄수화물": 1.3, "단백질": 25.0, "지방": 33.0},
    {"이름": "땅콩버터", "탄수화물": 20.0, "단백질": 25.0, "지방": 50.0},
  ];

  String _selectedCriteria = "탄수화물 많은 순";

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final maintenanceCalories = userData.calculateMaintenanceCalories();
    final dietGoal = userData.dietGoal;

    if (maintenanceCalories == null || dietGoal == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('식단 추천'),
        ),
        body: const Center(
          child: Text(
            '기초 정보를 입력해주세요.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    // 식단 목표별 목표 칼로리 계산
    double targetCalories;
    switch (dietGoal) {
      case '체지방 커팅':
        targetCalories = maintenanceCalories * 0.8;
        break;
      case '체중 유지':
        targetCalories = maintenanceCalories;
        break;
      case '벌크업':
        targetCalories = maintenanceCalories * 1.2;
        break;
      default:
        targetCalories = maintenanceCalories;
    }

    final macros = userData.calculateMacros(targetCalories);

    return Scaffold(
      appBar: AppBar(
        title: const Text('식단 추천'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('식단 목표: $dietGoal', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text('유지 칼로리: ${maintenanceCalories.toStringAsFixed(1)} kcal',
                style: const TextStyle(fontSize: 18)),
            Text('목표 칼로리: ${targetCalories.toStringAsFixed(1)} kcal',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('섭취해야 할 영양소:', style: TextStyle(fontSize: 20)),
            Text('탄수화물: ${macros['carbs']?.toStringAsFixed(1)} g',
                style: const TextStyle(fontSize: 18)),
            Text('단백질: ${macros['protein']?.toStringAsFixed(1)} g',
                style: const TextStyle(fontSize: 18)),
            Text('지방: ${macros['fat']?.toStringAsFixed(1)} g',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('추천 음식 목록 (100g 기준):', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedCriteria,
              items: [
                "탄수화물 많은 순",
                "단백질 많은 순",
                "지방 많은 순",
              ].map((criteria) {
                return DropdownMenuItem(
                  value: criteria,
                  child: Text(criteria),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCriteria = value!;
                  _sortFoodItems();
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final food = _foodItems[index];
                  return ListTile(
                    title: Text(food["이름"]),
                    subtitle: Text(
                      "탄수화물: ${food["탄수화물"].toStringAsFixed(1)}g, "
                      "단백질: ${food["단백질"].toStringAsFixed(1)}g, "
                      "지방: ${food["지방"].toStringAsFixed(1)}g",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sortFoodItems() {
    switch (_selectedCriteria) {
      case "탄수화물 많은 순":
        _foodItems.sort((a, b) => b["탄수화물"].compareTo(a["탄수화물"]));
        break;
      case "단백질 많은 순":
        _foodItems.sort((a, b) => b["단백질"].compareTo(a["단백질"]));
        break;
      case "지방 많은 순":
        _foodItems.sort((a, b) => b["지방"].compareTo(a["지방"]));
        break;
    }
  }
}
