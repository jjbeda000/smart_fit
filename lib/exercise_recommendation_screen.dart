import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';

class ExerciseRecommendationScreen extends StatelessWidget {
  const ExerciseRecommendationScreen({Key? key}) : super(key: key);

  // 운동 효과 값 설정 (저강도 체중 감량 운동 추가 및 피로도, 우선순위 조정)
  final Map<String, Map<String, double>> exerciseData = const {
    '가벼운 웨이트 트레이닝': {
      'fatigueIncrease': 2,
      'weightLoss': 2,
      'muscleGain': 4,
      'priority': 1
    },
    '요가': {
      'fatigueIncrease': 1,
      'weightLoss': 1,
      'muscleGain': 2,
      'priority': 0.5
    },
    '조깅 (30분)': {
      'fatigueIncrease': 3,
      'weightLoss': 4,
      'muscleGain': 2,
      'priority': 1.5
    },
    '사이클링 (20분)': {
      'fatigueIncrease': 3,
      'weightLoss': 3,
      'muscleGain': 3,
      'priority': 1.5
    },
    '고강도 인터벌 트레이닝': {
      'fatigueIncrease': 5,
      'weightLoss': 5,
      'muscleGain': 3,
      'priority': 2.0
    },
    '수영': {
      'fatigueIncrease': 4,
      'weightLoss': 4,
      'muscleGain': 3,
      'priority': 1.8
    },
    '유산소 운동 (걷기)': {
      'fatigueIncrease': 1,
      'weightLoss': 2,
      'muscleGain': 1,
      'priority': 0.8
    },
    '저강도 사이클링': {
      'fatigueIncrease': 2,
      'weightLoss': 3,
      'muscleGain': 1,
      'priority': 1.2
    },
    '근력 운동': {
      'fatigueIncrease': 3,
      'weightLoss': 2,
      'muscleGain': 5,
      'priority': 1.6
    },
  };

  double calculateScore(String exercise, double weightLossWeight,
      double muscleGainWeight, double fatigueLevel, double bmi) {
    final data = exerciseData[exercise]!;

    // 체중 감소 및 근육 증가 점수
    double weightLossScore = data['weightLoss']! * weightLossWeight;
    double muscleGainScore = data['muscleGain']! * muscleGainWeight;

    // 피로도에 따른 페널티 (상한 및 최소 페널티 적용)
    double fatiguePenalty = data['fatigueIncrease']! *
        pow(fatigueLevel / 10.0 + 0.1, 2) *
        data['priority']!;

    // 비만도가 높을수록 피로도 페널티를 증가시켜 고강도 운동을 제한
    if (bmi >= 30) {
      fatiguePenalty *= 1.5; // 비만일 때 페널티 추가 증가
    }

    // 최종 점수 계산
    return weightLossScore + muscleGainScore - fatiguePenalty;
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final double? bmi = userData.calculateBMI();
    final int? fatigueLevel = userData.fatigueLevel;

    if (bmi == null || fatigueLevel == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('운동 추천'),
        ),
        body: const Center(
          child: Text(
            'BMI 정보와 피로도를 입력해주세요.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    // BMI 상태 결정 및 가중치 설정
    String bmiCategory;
    double weightLossWeight;
    double muscleGainWeight;

    if (bmi < 16.5) {
      // 매우 저체중: 영양 섭취 권장
      return Scaffold(
        appBar: AppBar(
          title: const Text('건강 권장사항'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                '충분한 영양 섭취가 필요합니다.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              Text(
                '추천:',
                style: TextStyle(fontSize: 20),
              ),
              Text('- 영양가 있는 식사를 통해 체력을 보충하세요.'),
              Text('- 근육 증가를 위한 단백질과, 체력 보충을 위한 다양한 영양소를 섭취하세요.'),
            ],
          ),
        ),
      );
    } else if (bmi < 18.5) {
      bmiCategory = '저체중';
      weightLossWeight = 0.5;
      muscleGainWeight = 1.5;
    } else if (bmi >= 30) {
      bmiCategory = '비만';
      weightLossWeight = 2.0; // 비만일 때 체중 감소에 높은 가중치
      muscleGainWeight = 0.3; // 근육 증가 가중치 낮춤
    } else if (bmi >= 25) {
      bmiCategory = '과체중';
      weightLossWeight = 1.5;
      muscleGainWeight = 0.5;
    } else {
      bmiCategory = '정상 체중';
      weightLossWeight = 1.0;
      muscleGainWeight = 1.0;
    }

    // 피로도가 극단적으로 높으면 휴식을 권장
    if (fatigueLevel >= 9) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('건강 권장사항'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                '지금은 충분한 휴식이 필요합니다.',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              Text(
                '추천:',
                style: TextStyle(fontSize: 20),
              ),
              Text('- 충분한 수면과 휴식을 취하세요.'),
              Text('- 무리한 운동은 피하고, 몸의 회복에 집중하세요.'),
            ],
          ),
        ),
      );
    }

    // 운동 점수를 기준으로 추천 운동 정렬
    List<String> recommendedExercises = exerciseData.keys.toList();
    recommendedExercises.sort((a, b) => calculateScore(
            b, weightLossWeight, muscleGainWeight, fatigueLevel.toDouble(), bmi)
        .compareTo(calculateScore(a, weightLossWeight, muscleGainWeight,
            fatigueLevel.toDouble(), bmi)));

    // 최상위 2개의 운동만 추천
    recommendedExercises = recommendedExercises.take(2).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 추천'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('BMI: ${bmi.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 24)),
            Text('상태: $bmiCategory', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            const Text('추천 운동:', style: TextStyle(fontSize: 20)),
            for (var exercise in recommendedExercises)
              Text('- $exercise', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
