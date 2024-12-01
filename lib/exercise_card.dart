import 'package:flutter/material.dart';
import 'user_data_provider.dart';

// 운동 기록을 나타내는 ExerciseCard StatelessWidget
class ExerciseCard extends StatelessWidget {
  final ExerciseData exercise; // 운동 데이터를 담는 변수

  const ExerciseCard({Key? key, required this.exercise})
      : super(key: key); // ExerciseData는 필수로 받음

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // 카드의 그림자 깊이 (입체감)
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // 카드의 모서리를 둥글게
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 카드 내부의 패딩
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽으로 정렬
          children: [
            // 운동 날짜를 출력하는 텍스트 위젯
            Text(
              exercise.date, // 운동 날짜 (문자열)
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold), // 글자 크기와 굵기 설정
            ),
            const SizedBox(height: 8), // 날짜와 시간 텍스트 사이의 간격
            // 운동 시간을 출력하는 텍스트 위젯
            Text(
              '${exercise.duration}분 운동', // 운동 시간 (예: "30분 운동")
              style: const TextStyle(fontSize: 16), // 글자 크기 설정
            ),
          ],
        ),
      ),
    );
  }
}
