import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';

// 식단 추천 화면을 구성하는 StatelessWidget 클래스
class DietRecommendationScreen extends StatelessWidget {
  const DietRecommendationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provider 패턴을 사용하여 UserDataProvider에서 사용자 데이터를 가져옴
    final userData = Provider.of<UserDataProvider>(context);
    final String? dietGoal = userData.dietGoal; // 사용자의 식단 목표를 가져옴
    List<String> recommendedFoods = []; // 추천 음식을 담을 리스트

    // dietGoal이 설정되지 않은 경우 사용자에게 설정하라는 메시지 표시
    if (dietGoal == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('식단 추천'),
        ),
        body: const Center(
          child: Text(
            '식단 목표가 설정되지 않았습니다. 설정해주세요.', // 식단 목표가 없을 때의 메시지
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    // 식단 목표에 따라 탐욕적으로 가장 적절한 음식 리스트를 선택
    if (dietGoal == '고단백') {
      recommendedFoods = ['닭가슴살', '연어', '계란', '두부'];
    } else if (dietGoal == '저지방') {
      recommendedFoods = ['브로콜리', '아스파라거스', '시금치', '오이'];
    } else if (dietGoal == '저탄수화물') {
      recommendedFoods = ['아보카도', '견과류', '잎채소', '오메가3 지방산'];
    } else {
      recommendedFoods = ['다양한 야채', '잡곡밥', '견과류', '과일'];
    }

    // 추천된 음식을 화면에 출력
    return Scaffold(
      appBar: AppBar(
        title: const Text('식단 추천'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 화면에 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽으로 정렬
          children: <Widget>[
            // 사용자의 식단 목표 출력
            Text('식단 목표: $dietGoal', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16), // 간격 추가
            const Text('추천 음식:', style: TextStyle(fontSize: 20)), // 추천 음식 제목
            // 추천 음식 리스트를 화면에 출력
            ...recommendedFoods
                .map((item) =>
                    Text('- $item', style: const TextStyle(fontSize: 18)))
                .toList(),
          ],
        ),
      ),
    );
  }
}
