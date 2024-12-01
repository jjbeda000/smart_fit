import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';

class DietSettingsScreen extends StatefulWidget {
  const DietSettingsScreen({Key? key}) : super(key: key);

  @override
  _DietSettingsScreenState createState() => _DietSettingsScreenState();
}

class _DietSettingsScreenState extends State<DietSettingsScreen> {
  String _dietGoal = '체중 유지'; // Default diet goal
  String _exerciseFrequency = '주 0-1회'; // Default exercise frequency

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('선호하는 식단 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('운동 빈도를 선택하세요', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _exerciseFrequency,
              items: <String>['주 0-1회', '주 2-3회', '주 4회 이상']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _exerciseFrequency = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('식단 목표를 선택하세요', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _dietGoal,
              items: <String>['벌크업', '체중 유지', '체지방 커팅']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _dietGoal = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final userData =
                    Provider.of<UserDataProvider>(context, listen: false);
                userData.setExerciseFrequency(_exerciseFrequency);
                userData.setDietGoal(_dietGoal);
                Navigator.pop(context);
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
