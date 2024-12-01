import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';
import 'bmi_input_screen.dart'; // 사용자가 BMI 정보를 입력할 수 있는 화면을 불러오기 위한 임포트

class ExerciseRecommendationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context); // 사용자의 데이터를 제공받음
    final double? bmi = userData.calculateBMI(); // BMI 계산

    // BMI가 없는 경우 BMI 입력을 요구
    if (bmi == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('운동 및 식단 추천'),
        ),
        body: const Center(
          child: Text(
            'BMI 정보를 입력해주세요.', // BMI 정보가 없을 때 보여줄 메시지
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    // 추천할 운동 및 식단 리스트 초기화
    String _bmiCategory;
    List<String> _recommendedExercises = [];
    List<String> _recommendedDiet = [];

    // BMI에 따라 운동 및 식단을 다르게 추천
    if (bmi < 18.5) {
      _bmiCategory = '저체중'; // 저체중일 경우 추천
      _recommendedExercises = ['가벼운 웨이트 트레이닝', '요가'];
      _recommendedDiet = ['단백질 많은 식단', '고칼로리 건강식'];
    } else if (bmi >= 18.5 && bmi < 24.9) {
      _bmiCategory = '정상 체중'; // 정상 체중일 경우 추천
      _recommendedExercises = ['조깅 (30분)', '사이클링 (20분)'];
      _recommendedDiet = ['균형 잡힌 식단', '신선한 야채와 과일'];
    } else if (bmi >= 25 && bmi < 29.9) {
      _bmiCategory = '과체중'; // 과체중일 경우 추천
      _recommendedExercises = ['고강도 인터벌 트레이닝', '수영'];
      _recommendedDiet = ['저칼로리 식단', '고섬유질 식품'];
    } else {
      _bmiCategory = '비만'; // 비만일 경우 추천
      _recommendedExercises = ['유산소 운동 (걷기, 자전거)', '근력 운동'];
      _recommendedDiet = ['저지방 식단', '채소 위주의 식사'];
    }

    // 추천 운동 및 식단을 표시하는 화면 구성
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 및 식단 추천'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 화면에 여백을 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 요소를 왼쪽으로 정렬
          children: <Widget>[
            // BMI 정보 표시
            Text(
              'BMI: ${bmi.toStringAsFixed(1)}', // BMI 값을 소수점 1자리로 표시
              style: const TextStyle(fontSize: 24), // 텍스트 스타일 설정
            ),
            // BMI 카테고리(저체중, 정상 체중 등) 표시
            Text('상태: $_bmiCategory', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16), // 간격 추가
            // 추천 운동 목록 표시
            const Text('추천 운동:', style: TextStyle(fontSize: 20)),
            for (var exercise in _recommendedExercises) Text('- $exercise'),
            const SizedBox(height: 16), // 간격 추가
            // 추천 식단 목록 표시
            const Text('추천 식단:', style: TextStyle(fontSize: 20)),
            for (var diet in _recommendedDiet) Text('- $diet'),
          ],
        ),
      ),
    );
  }
}
