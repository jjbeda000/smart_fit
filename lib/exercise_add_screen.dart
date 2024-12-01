import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';

class Exercise {
  final String name;
  final double caloriePerMinute;

  Exercise(this.name, this.caloriePerMinute);
}

// 운동 리스트
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

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  Exercise? _selectedExercise; // 선택된 운동
  int _duration = 0; // 운동 시간
  DateTime _selectedDate = DateTime.now(); // 선택된 날짜

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
        title: const Text('운동 기록 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                    _selectedExercise = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '운동을 선택하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 운동 시간 입력 필드
              TextFormField(
                decoration: const InputDecoration(labelText: '운동 시간 (분)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _duration = int.parse(value);
                  }
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return '유효한 시간을 입력하세요';
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
                      '운동한 날짜: ${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('날짜 선택'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 저장 버튼
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (_selectedExercise != null) {
                      String exerciseDateTime = _formatDateTime();
                      Provider.of<UserDataProvider>(context, listen: false)
                          .addExercise(
                        exerciseDateTime,
                        _duration,
                        _selectedExercise!.caloriePerMinute,
                        _selectedExercise!.name, // 운동 이름 추가
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
