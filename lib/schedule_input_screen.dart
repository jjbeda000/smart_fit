import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';

// 일정 입력 화면을 구성하는 StatefulWidget
class ScheduleInputScreen extends StatefulWidget {
  const ScheduleInputScreen({Key? key}) : super(key: key);

  @override
  _ScheduleInputScreenState createState() => _ScheduleInputScreenState();
}

class _ScheduleInputScreenState extends State<ScheduleInputScreen> {
  TimeOfDay? _startTime; // 시작 시간을 저장할 변수
  TimeOfDay? _endTime; // 종료 시간을 저장할 변수
  final _activityController = TextEditingController(); // 활동 내용을 입력받기 위한 컨트롤러

  @override
  void dispose() {
    _activityController.dispose(); // 화면이 닫힐 때 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider에서 저장된 일정을 가져옴
    final schedules = Provider.of<UserDataProvider>(context).schedules;

    return Scaffold(
      appBar: AppBar(
        title: const Text('일정 추가 및 조회'), // 상단바 제목
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 화면 전체 여백 설정
        child: Column(
          children: [
            // 활동 내용을 입력하는 필드
            TextFormField(
              controller: _activityController, // 사용자가 입력한 활동 내용을 받음
              decoration: const InputDecoration(labelText: '활동 내용'), // 레이블 텍스트
            ),
            const SizedBox(height: 16), // 필드와 버튼 사이에 간격 추가
            // 시간 선택 버튼을 포함한 Row
            Row(
              children: [
                // 시작 시간 선택 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(), // 기본 시간을 현재 시간으로 설정
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _startTime = selectedTime; // 선택한 시작 시간을 저장
                        });
                      }
                    },
                    child: Text(
                      _startTime == null
                          ? '시작 시간 선택' // 선택되지 않았을 때 기본 텍스트
                          : '시작: ${_startTime!.format(context)}', // 선택된 시간을 표시
                    ),
                  ),
                ),
                const SizedBox(width: 8), // 시작 시간과 종료 시간 버튼 사이의 간격
                // 종료 시간 선택 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(), // 기본 시간을 현재 시간으로 설정
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _endTime = selectedTime; // 선택한 종료 시간을 저장
                        });
                      }
                    },
                    child: Text(
                      _endTime == null
                          ? '종료 시간 선택' // 선택되지 않았을 때 기본 텍스트
                          : '종료: ${_endTime!.format(context)}', // 선택된 시간을 표시
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // 시간 선택 버튼과 저장 버튼 사이의 간격
            // 일정 저장 버튼
            ElevatedButton(
              onPressed: () {
                if (_startTime != null && _endTime != null) {
                  // 시작 시간과 종료 시간이 모두 선택되었을 때
                  Provider.of<UserDataProvider>(context, listen: false)
                      .addSchedule(_activityController.text, _startTime!,
                          _endTime!); // 일정 저장
                }
              },
              child: const Text('일정 저장'),
            ),
            const SizedBox(height: 20), // 저장 버튼과 저장된 일정 목록 사이의 간격
            const Text('저장된 일정들:',
                style: TextStyle(fontSize: 18)), // 저장된 일정 목록 제목
            // 저장된 일정을 리스트로 출력
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length, // 저장된 일정의 개수만큼 리스트 항목 생성
                itemBuilder: (context, index) {
                  final schedule = schedules[index]; // 해당 인덱스의 일정 데이터
                  return ListTile(
                    title: Text(
                      '${schedule['activity']}: ${schedule['start'].format(context)} - ${schedule['end'].format(context)}', // 활동 이름 및 시작/종료 시간 표시
                    ),
                    // 삭제 버튼
                    trailing: IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.red), // 삭제 아이콘
                      onPressed: () {
                        Provider.of<UserDataProvider>(context, listen: false)
                            .deleteSchedule(index); // 해당 인덱스의 일정 삭제
                      },
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
}
