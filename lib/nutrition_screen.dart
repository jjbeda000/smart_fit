import 'package:flutter/material.dart';

class Food {
  final String name;
  final double carbsPer100g;
  final double proteinPer100g;
  final double fatPer100g;

  Food(this.name, this.carbsPer100g, this.proteinPer100g, this.fatPer100g);
}

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  List<Food> foods = [
    Food('닭가슴살', 0, 31, 3.6),
    Food('연어', 0, 20, 13),
    Food('브로콜리', 7, 2.8, 0.4),
    Food('아보카도', 9, 2, 15),
    Food('현미밥', 23, 2.5, 1.5),
    Food('고구마', 20, 1.6, 0.1),
    Food('두부', 1.9, 8, 4.8),
    Food('렌틸콩', 20, 9, 0.4),
    Food('귀리', 12, 2.4, 3),
    Food('시금치', 3.6, 2.9, 0.4),
    Food('사과', 13.8, 0.3, 0.2),
    Food('블루베리', 14.5, 0.7, 0.3),
    Food('바나나', 22.8, 1.1, 0.3),
    Food('계란', 1.1, 13, 11),
    Food('소고기', 0, 26, 17),
    Food('호두', 14, 15, 65),
    Food('아몬드', 22, 21, 50),
    Food('올리브 오일', 0, 0, 100),
  ];

  String selectedNutrient = '탄수화물';

  @override
  Widget build(BuildContext context) {
    List<Food> sortedFoods = [...foods];
    sortedFoods.sort((a, b) {
      if (selectedNutrient == '탄수화물') {
        return b.carbsPer100g.compareTo(a.carbsPer100g);
      } else if (selectedNutrient == '단백질') {
        return b.proteinPer100g.compareTo(a.proteinPer100g);
      } else {
        return b.fatPer100g.compareTo(a.fatPer100g);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('영양소별 음식 정렬'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedNutrient,
              items: ['탄수화물', '단백질', '지방'].map((String nutrient) {
                return DropdownMenuItem(
                  value: nutrient,
                  child: Text(nutrient),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedNutrient = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: sortedFoods.length,
                itemBuilder: (context, index) {
                  final food = sortedFoods[index];
                  final nutrientAmount = selectedNutrient == '탄수화물'
                      ? food.carbsPer100g
                      : selectedNutrient == '단백질'
                          ? food.proteinPer100g
                          : food.fatPer100g;

                  return ListTile(
                    title: Text(food.name),
                    subtitle: Text(
                        '$selectedNutrient: ${nutrientAmount.toStringAsFixed(1)}g'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
