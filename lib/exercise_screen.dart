import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';

// 운동 클래스 정의, 운동 이름과 분당 칼로리 소모량을 포함
class Exercise {
  final String name;
  final double caloriePerMinute;

  Exercise(this.name, this.caloriePerMinute);
}

// 운동 리스트, 보기로 제공되는 운동 종목과 분당 칼로리 소모량
final List<Exercise> exercises = [
  Exercise('수영', 12.25),
  Exercise('조깅', 8.63),
  Exercise('등산', 8),
  Exercise('줄넘기', 5.2),
  Exercise('걷기', 4.2),
  Exercise('자전거', 3.3),
  Exercise('요가', 2.1),
  Exercise('산책', 2.4),
  Exercise('윗몸일으키기', 11.6),
];

// 운동 기록을 추가하는 화면을 구성하는 StatefulWidget
class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>(); // 폼의 상태를 관리하는 글로벌 키
  Exercise? _selectedExercise; // 선택된 운동
  int _duration = 0; // 운동 시간
  DateTime _selectedDate = DateTime.now(); // 운동한 날짜를 저장하는 변수

  // 날짜 선택 다이얼로그를 보여주는 함수
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 날짜를 문자열로 포맷하는 함수
  String _formatDateTime() {
    return "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 기록 추가'), // 상단바에 표시될 타이틀
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 화면 전체에 여백 추가
        child: Form(
          key: _formKey, // 폼 상태를 관리하는 키를 설정
          child: Column(
            children: [
              // 운동 선택 드롭다운
              DropdownButtonFormField<Exercise>(
                decoration: const InputDecoration(labelText: '운동 선택'),
                items: exercises.map((exercise) {
                  return DropdownMenuItem<Exercise>(
                    value: exercise,
                    child: Text(exercise.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExercise = value; // 선택한 운동 저장
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '운동을 선택하세요'; // 운동이 선택되지 않은 경우 오류 메시지
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 운동 시간을 입력하는 필드
              TextFormField(
                decoration:
                    const InputDecoration(labelText: '운동 시간 (분)'), // 필드의 레이블
                keyboardType: TextInputType.number, // 숫자 입력을 위한 키보드 설정
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _duration = int.parse(value); // 입력한 운동 시간을 저장
                  }
                },
                validator: (value) {
                  // 유효성 검사
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return '유효한 시간을 입력하세요'; // 입력값이 없거나 유효하지 않으면 오류 메시지 표시
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 날짜 선택 필드
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '운동한 날짜: ${_formatDateTime()}', // 선택된 날짜 표시
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('날짜 선택'),
                  ),
                ],
              ),
              const SizedBox(height: 20), // 입력 필드와 버튼 사이에 간격 추가
              // 저장 버튼
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 폼의 유효성 검사를 통과한 경우
                    _formKey.currentState!.save(); // 입력된 데이터를 저장
                    if (_selectedExercise != null) {
                      // 선택한 운동이 있는 경우
                      String exerciseDate =
                          _formatDateTime(); // 선택된 날짜를 문자열로 포맷
                      // Provider를 사용하여 전역 상태에 운동 기록 추가
                      Provider.of<UserDataProvider>(context, listen: false)
                          .addExercise(
                        exerciseDate, // 날짜
                        _duration, // 운동 시간
                        _selectedExercise!.caloriePerMinute, // 분당 칼로리 소모량
                        _selectedExercise!.name, // 운동 이름
                      );
                      Navigator.pop(context); // 저장 후 이전 화면으로 돌아감
                    }
                  }
                },
                child: const Text('저장'), // 버튼에 표시될 텍스트
              ),
            ],
          ),
        ),
      ),
    );
  }
}
