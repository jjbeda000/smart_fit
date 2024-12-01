import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';

// 일정 목록을 보여주는 화면을 구성하는 StatelessWidget
class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData =
        Provider.of<UserDataProvider>(context); // Provider에서 사용자 데이터를 가져옴
    final schedules = userData.schedules; // 저장된 일정 목록
    final TimeOfDay? recommendedTime =
        userData.recommendExerciseTime(); // 운동 추천 시간

    return Scaffold(
      appBar: AppBar(
        title: const Text('일정 목록'), // 상단바 제목
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 화면 전체에 16픽셀 여백 추가
        child: Column(
          children: [
            // 저장된 일정이 있을 경우 일정 목록을 리스트로 출력
            if (schedules.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: schedules.length, // 일정 개수만큼 리스트 항목 생성
                  itemBuilder: (context, index) {
                    final schedule = schedules[index]; // 각 일정 데이터
                    return ListTile(
                      title: Text('${schedule['activity']}'), // 활동 이름 표시
                      subtitle: Text(
                          '시작: ${schedule['start']!.format(context)}, 종료: ${schedule['end']!.format(context)}'), // 시작과 종료 시간 표시
                      trailing: IconButton(
                        icon: const Icon(Icons.delete), // 삭제 아이콘
                        onPressed: () {
                          userData.deleteSchedule(index); // 일정 삭제
                        },
                      ),
                    );
                  },
                ),
              )
            // 저장된 일정이 없을 경우 메시지 출력
            else
              const Text('저장된 일정이 없습니다.'),

            const SizedBox(height: 20), // 일정과 운동 추천 시간 간의 간격
            // 추천 운동 시간이 있을 경우 해당 시간을 출력
            if (recommendedTime != null)
              Text(
                '운동 추천 시간: ${recommendedTime.format(context)}에 운동을 추천합니다!',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold), // 추천 시간 텍스트 스타일
              ),
          ],
        ),
      ),
    );
  }
}
