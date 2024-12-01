import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'user_data_provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String? selectedMonth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userData = Provider.of<UserDataProvider>(context, listen: false);
      final availableMonths = userData.getAvailableMonths();
      if (availableMonths.isNotEmpty) {
        setState(() {
          selectedMonth = availableMonths.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);
    final availableMonths = userData.getAvailableMonths();

    if (availableMonths.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('운동 분석'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Text(
            '운동 기록이 없습니다. 데이터를 추가해주세요.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    selectedMonth ??= availableMonths.first;
    final monthlyCalories = userData.calculateMonthlyCalories(selectedMonth!);
    final todayExercises = userData.getTodayExercises();
    final weeklyCalories = userData.calculateWeeklyCalories();
    final todayDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 분석'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 오늘의 운동 요약
            _buildTodayExerciseSummary(todayExercises),

            // 주간 소모 칼로리 그래프
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '주간 소모 칼로리',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 300,
                    child: _buildWeeklyCaloriesChart(weeklyCalories, todayDate),
                  ),
                  const SizedBox(height: 16),
                  _buildWeeklyCaloriesSummary(weeklyCalories), // 주간 총 소모 칼로리 표시
                ],
              ),
            ),

            // 월간 소모 칼로리 캘린더 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonthlyAnalysisScreen(
                        monthlyCalories: monthlyCalories,
                      ),
                    ),
                  );
                },
                child: const Text('월간 분석 보기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayExerciseSummary(List<ExerciseData> todayExercises) {
    if (todayExercises.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "오늘 운동 기록이 없습니다.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    // 당일 운동 중에서 가장 많은 칼로리 소모 운동 찾기
    ExerciseData maxCalorieExercise =
        todayExercises.reduce((a, b) => a.calories > b.calories ? a : b);
    List<ExerciseData> otherExercises = todayExercises
        .where((exercise) => exercise != maxCalorieExercise)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            '오늘의 운동',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_fire_department,
                  color: Colors.blueAccent, size: 40),
              const SizedBox(width: 8),
              Text(
                '${maxCalorieExercise.name} - ${maxCalorieExercise.calories.toStringAsFixed(1)} kcal',
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '오늘 이정도로 운동하셨어요!',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (otherExercises.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: otherExercises.asMap().entries.map((entry) {
                int index = entry.key + 2;
                ExerciseData exercise = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    '$index. ${exercise.name} - ${exercise.calories.toStringAsFixed(1)} kcal',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCaloriesChart(
      Map<String, double> weeklyCalories, DateTime todayDate) {
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final List<charts.Series<ChartData, String>> series = [
      charts.Series<ChartData, String>(
        id: 'WeeklyCalories',
        domainFn: (ChartData data, _) => weekdays[data.index],
        measureFn: (ChartData data, _) => data.value,
        data: List.generate(7, (index) {
          String currentDay = todayDate
              .subtract(Duration(days: todayDate.weekday - 1 - index))
              .toIso8601String()
              .substring(0, 10);
          return ChartData(index, weeklyCalories[currentDay] ?? 0.0);
        }),
        colorFn: (ChartData data, _) {
          // 오늘에 해당하는 막대는 초록색으로 강조
          if (data.index == todayDate.weekday - 1) {
            return charts.MaterialPalette.green.shadeDefault;
          } else {
            return charts.MaterialPalette.blue.shadeDefault;
          }
        },
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 16,
            fontWeight: 'bold',
          ),
        ),
      ),
      defaultRenderer: charts.BarRendererConfig(
        cornerStrategy: const charts.ConstCornerStrategy(4),
      ),
    );
  }

  Widget _buildWeeklyCaloriesSummary(Map<String, double> weeklyCalories) {
    double totalCalories = weeklyCalories.values.fold(0, (a, b) => a + b);
    return Center(
      child: Text(
        '이번 주 총 소모 칼로리: ${totalCalories.toStringAsFixed(1)} kcal\n훌륭한 운동량입니다!',
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class MonthlyAnalysisScreen extends StatelessWidget {
  final Map<String, double> monthlyCalories;

  MonthlyAnalysisScreen({required this.monthlyCalories});

  @override
  Widget build(BuildContext context) {
    double totalCalories = monthlyCalories.values.fold(0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('월간 소모 칼로리 분석'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '이번 달 총 소모 칼로리: ${totalCalories.toStringAsFixed(1)} kcal\n멋진 한 달이었습니다!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildMonthlyCaloriesCalendar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyCaloriesCalendar() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: monthlyCalories.length,
      itemBuilder: (context, index) {
        String day = monthlyCalories.keys.elementAt(index);
        double calories = monthlyCalories[day]!;

        // 칼로리 값에 따른 색상 변경
        Color color;
        if (calories >= 500) {
          color = Colors.green; // 초록색
        } else if (calories >= 300) {
          color = Colors.blue; // 파란색
        } else if (calories > 0) {
          color = Colors.lightBlueAccent; // 연한 파란색
        } else {
          color = Colors.grey; // 운동 기록 없으면 회색
        }

        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            '${day.split('-').last}\n${calories.toStringAsFixed(0)} kcal',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 22), // 텍스트 크기 확실히 증가
          ),
        );
      },
    );
  }
}

class ChartData {
  final int index;
  final double value;

  ChartData(this.index, this.value);
}
