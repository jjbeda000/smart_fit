import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';

// BMI 입력 화면을 구성하는 StatefulWidget 클래스
class BmiInputScreen extends StatefulWidget {
  const BmiInputScreen({Key? key}) : super(key: key);

  @override
  _BmiInputScreenState createState() => _BmiInputScreenState();
}

class _BmiInputScreenState extends State<BmiInputScreen> {
  final _formKey = GlobalKey<FormState>(); // 폼의 상태를 관리하는 글로벌 키
  late double _weight; // 체중 값
  late double _height; // 키 값
  late int _age; // 나이 값
  late String _gender; // 성별 값
  late int _fatigueLevel; // 피로도 값

  @override
  void initState() {
    super.initState();

    // UserDataProvider에서 값 가져오기
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    _weight = userDataProvider.weight ?? 60.0; // 저장된 체중 값이 없으면 기본값 60.0
    _height = userDataProvider.height ?? 170.0; // 저장된 키 값이 없으면 기본값 170.0
    _age = userDataProvider.age ?? 30; // 저장된 나이 값이 없으면 기본값 30
    _gender = userDataProvider.gender ?? "남성"; // 저장된 성별 값이 없으면 기본값 "남성"
    _fatigueLevel = userDataProvider.fatigueLevel ?? 0; // 저장된 피로도 값이 없으면 기본값 0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정보 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // 체중 입력 필드
              TextFormField(
                decoration: const InputDecoration(labelText: '체중 (kg)'),
                keyboardType: TextInputType.number,
                initialValue: _weight.toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return '유효한 체중을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = double.parse(value!);
                },
              ),
              // 키 입력 필드
              TextFormField(
                decoration: const InputDecoration(labelText: '키 (cm)'),
                keyboardType: TextInputType.number,
                initialValue: _height.toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return '유효한 키를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _height = double.parse(value!);
                },
              ),
              // 나이 입력 필드
              TextFormField(
                decoration: const InputDecoration(labelText: '나이'),
                keyboardType: TextInputType.number,
                initialValue: _age.toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return '유효한 나이를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.parse(value!);
                },
              ),
              // 성별 선택 드롭다운
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '성별'),
                value: _gender,
                items: ['남성', '여성'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              // 피로도 입력 필드
              TextFormField(
                decoration: const InputDecoration(labelText: '피로도 (0-10)'),
                keyboardType: TextInputType.number,
                initialValue: _fatigueLevel.toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) < 0 ||
                      int.parse(value) > 10) {
                    return '유효한 피로도(0-10)를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fatigueLevel = int.parse(value!);
                },
              ),
              const SizedBox(height: 16), // 간격 추가
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 유효성 검사가 성공하면
                    _formKey.currentState!.save(); // 폼의 값을 저장
                    // Provider 패턴을 사용하여 UserDataProvider에 값을 저장
                    final userDataProvider =
                        Provider.of<UserDataProvider>(context, listen: false);

                    // 저장된 값들 업데이트
                    userDataProvider.setWeight(_weight);
                    userDataProvider.setHeight(_height);
                    userDataProvider.setAge(_age);
                    userDataProvider.setGender(_gender);
                    userDataProvider.setFatigueLevel(_fatigueLevel);

                    Navigator.pop(context); // 저장 후 이전 화면으로 돌아감
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
