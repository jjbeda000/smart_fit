import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_data_provider.dart';
import 'widgets/custom_button.dart';
import 'exercise_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final double totalCalories = userData.calculateTotalCalories();
    final List<ExerciseData> exercises = userData.dailyExercises;

    final TimeOfDay? recommendedTime = userData.recommendExerciseTime();

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 운동 기록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, totalCalories),
            if (recommendedTime != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  '추천 운동 시간: ${recommendedTime.format(context)}',
                  style: const TextStyle(fontSize: 16),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  '충분한 자유 시간이 없습니다.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: exercises.isNotEmpty
                  ? ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              exercises[index].name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                '${exercises[index].calories.toStringAsFixed(1)} kcal - ${exercises[index].date}'),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // 삭제 확인 다이얼로그
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('삭제 확인'),
                                    content: const Text('이 운동 기록을 삭제하시겠습니까?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('취소'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // 운동 기록 삭제
                                          userData.removeExercise(index);
                                          Navigator.of(context).pop();
                                          // 삭제 완료 메시지
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '${exercises[index].name} 운동 기록이 삭제되었습니다.'),
                                            ),
                                          );
                                        },
                                        child: const Text('삭제'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        '운동 기록이 없습니다. 추가하려면 아래의 버튼을 누르세요.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/schedule_input');
        },
        child: const Icon(Icons.schedule, size: 30),
        backgroundColor: Colors.purple,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼들 간격 균등
          children: [
            Expanded(
              child: CustomButton(
                label: '정보 입력',
                icon: Icons.input,
                onPressed: () {
                  Navigator.pushNamed(context, '/bmi_input');
                },
              ),
            ),
            const SizedBox(width: 8), // 버튼 간 간격 유지
            Expanded(
              child: CustomButton(
                label: '식단 추천',
                icon: Icons.restaurant,
                onPressed: () {
                  Navigator.pushNamed(context, '/diet_recommendation');
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomButton(
                label: '식단 설정',
                icon: Icons.settings,
                onPressed: () {
                  Navigator.pushNamed(context, '/diet_settings');
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomButton(
                label: '운동 기록 추가',
                icon: Icons.add,
                onPressed: () {
                  Navigator.pushNamed(context, '/add_exercise');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double totalCalories) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '총 소모 칼로리',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${totalCalories.toStringAsFixed(2)} kcal',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomButton(
              label: '운동 분석 보기',
              icon: Icons.bar_chart,
              onPressed: () {
                Navigator.pushNamed(context, '/progress');
              },
            ),
            const SizedBox(height: 8),
            CustomButton(
              label: '운동 추천 받기',
              icon: Icons.recommend,
              onPressed: () {
                Navigator.pushNamed(context, '/exercise_recommendation');
              },
            ),
          ],
        ),
      ),
    );
  }
}
