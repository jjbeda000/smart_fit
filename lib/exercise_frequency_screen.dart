import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';
import 'diet_settings_screen.dart';

class ExerciseFrequencyScreen extends StatelessWidget {
  const ExerciseFrequencyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 빈도 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('운동 빈도를 선택하세요', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            _buildFrequencyButton(context, userData, '적음'),
            _buildFrequencyButton(context, userData, '보통'),
            _buildFrequencyButton(context, userData, '많음'),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyButton(
      BuildContext context, UserDataProvider userData, String frequency) {
    return ElevatedButton(
      onPressed: () {
        userData.setExerciseFrequency(frequency);
        final maintenanceCalories = userData.calculateMaintenanceCalories();

        // 유지 칼로리를 계산한 후, 결과를 보여주는 AlertDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('유지 칼로리'),
              content: Text(
                maintenanceCalories != null
                    ? '당신의 유지 칼로리는 ${maintenanceCalories.toStringAsFixed(2)} kcal 입니다.'
                    : '정보가 부족하여 유지 칼로리를 계산할 수 없습니다.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // 유지 칼로리 확인 후 식단 목표 설정 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DietSettingsScreen(),
                      ),
                    );
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      },
      child: Text(frequency),
    );
  }
}
