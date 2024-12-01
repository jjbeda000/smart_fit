import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'user_data_provider.dart';
import 'bmi_input_screen.dart';
import 'exercise_add_screen.dart'; // 경로 확인
import 'progress_screen.dart';
import 'exercise_recommendation_screen.dart';
import 'diet_settings_screen.dart';
import 'schedule_input_screen.dart';
import 'diet_recommendation_screen.dart';
import 'nutrition_screen.dart'; // NutritionScreen 파일 추가

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      routes: {
        '/bmi_input': (context) => const BmiInputScreen(),
        '/add_exercise': (context) => const AddExerciseScreen(), // 오류 발생 원인 수정
        '/progress': (context) => const ProgressScreen(),
        '/exercise_recommendation': (context) =>
            const ExerciseRecommendationScreen(),
        '/diet_recommendation': (context) => const DietRecommendationScreen(),
        '/diet_settings': (context) => const DietSettingsScreen(),
        '/schedule_input': (context) => const ScheduleInputScreen(),
        '/nutrition': (context) =>
            const NutritionScreen(), // NutritionScreen 경로 추가
      },
    );
  }
}
