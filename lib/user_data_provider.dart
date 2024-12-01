import 'package:flutter/material.dart';

/// 운동 데이터를 관리하는 클래스
class ExerciseData {
  final String date; // 운동 일자 (예: "2023-11-10")
  final int duration; // 운동 시간 (분 단위)
  final double caloriePerMinute; // 1분당 칼로리 소모량
  final String name; // 운동 이름

  ExerciseData(this.date, this.duration, this.caloriePerMinute, this.name);

  // 총 칼로리 계산 속성
  double get calories => duration * caloriePerMinute;
}

/// 사용자 데이터를 관리하는 프로바이더 클래스
class UserDataProvider extends ChangeNotifier {
  double? _weight; // 체중
  double? _height; // 키
  int? _fatigueLevel; // 피로도
  String? _dietGoal; // 식단 목표
  String? _exerciseFrequency; // 운동 빈도
  String? _gender; // 성별
  int? _age; // 나이

  List<ExerciseData> _dailyExercises = []; // 운동 기록 리스트
  final List<Map<String, dynamic>> _schedules = []; // 일정 데이터 리스트

  double? _cachedMaintenanceCalories; // 유지 칼로리 계산 캐시

  // 체중, 키, 피로도, 식단 목표, 성별, 나이, 운동 빈도를 가져오는 getter
  double? get weight => _weight;

  double? get height => _height;

  int? get fatigueLevel => _fatigueLevel;

  String? get dietGoal => _dietGoal;

  String? get exerciseFrequency => _exerciseFrequency;

  String? get gender => _gender;

  int? get age => _age;

  // 운동 기록 반환 getter
  List<ExerciseData> get dailyExercises => _dailyExercises;

  // 일정 데이터 반환 getter
  List<Map<String, dynamic>> get schedules => List.unmodifiable(_schedules);

  // 체중 설정 메서드
  void setWeight(double weight) {
    if (weight <= 0) throw ArgumentError('Weight must be greater than 0');
    _weight = weight;
    _cachedMaintenanceCalories = null; // 캐시 초기화
    notifyListeners();
  }

  // 키 설정 메서드
  void setHeight(double height) {
    if (height <= 0) throw ArgumentError('Height must be greater than 0');
    _height = height;
    _cachedMaintenanceCalories = null; // 캐시 초기화
    notifyListeners();
  }

  // 피로도 설정 메서드
  void setFatigueLevel(int fatigue) {
    _fatigueLevel = fatigue;
    notifyListeners();
  }

  // 운동 빈도 설정 메서드
  void setExerciseFrequency(String frequency) {
    _exerciseFrequency = frequency;
    _cachedMaintenanceCalories = null; // 캐시 초기화
    notifyListeners();
  }

  // 식단 목표 설정 메서드
  void setDietGoal(String dietGoal) {
    _dietGoal = dietGoal;
    notifyListeners();
  }

  // 성별 설정 메서드
  void setGender(String gender) {
    _gender = gender;
    _cachedMaintenanceCalories = null; // 캐시 초기화
    notifyListeners();
  }

  // 나이 설정 메서드
  void setAge(int age) {
    _age = age;
    _cachedMaintenanceCalories = null; // 캐시 초기화
    notifyListeners();
  }

  // 유지 칼로리 계산 메서드
  double? calculateMaintenanceCalories() {
    if (_weight == null ||
        _height == null ||
        _gender == null ||
        _age == null ||
        _exerciseFrequency == null) {
      return null;
    }

    double bmr;
    if (_gender == '남성') {
      bmr = 66 + (13.7 * _weight!) + (5 * _height!) - (6.8 * _age!);
    } else {
      bmr = 655 + (9.6 * _weight!) + (1.8 * _height!) - (4.7 * _age!);
    }

    double multiplier;
    switch (_exerciseFrequency) {
      case '주 0-1회':
        multiplier = 1.2;
        break;
      case '주 2-3회':
        multiplier = 1.5;
        break;
      case '주 4회 이상':
        multiplier = 1.8;
        break;
      default:
        multiplier = 1.2;
    }

    return bmr * multiplier;
  }

  // BMI 계산 메서드
  double? calculateBMI() {
    if (_weight == null || _height == null || _height! <= 0) {
      return null;
    }

    double heightInMeters = _height! / 100; // cm를 m로 변환
    return _weight! / (heightInMeters * heightInMeters);
  }

  // 탄수화물, 단백질, 지방 비율 계산 메서드
  Map<String, double> calculateMacros(double targetCalories) {
    // 비율: 탄수화물 5.5, 단백질 2.5, 지방 2
    double carbCalories = targetCalories * (5.5 / 10);
    double proteinCalories = targetCalories * (2.5 / 10);
    double fatCalories = targetCalories * (2.0 / 10);

    return {
      'carbs': carbCalories / 4, // 탄수화물: 1g당 4칼로리
      'protein': proteinCalories / 4, // 단백질: 1g당 4칼로리
      'fat': fatCalories / 9, // 지방: 1g당 9칼로리
    };
  }

  // 전체 소모 칼로리 계산 메서드
  double calculateTotalCalories() {
    return _dailyExercises.fold(
        0, (total, exercise) => total + exercise.calories);
  }

  // 운동 기록 추가 메서드
  void addExercise(
      String date, int duration, double caloriePerMinute, String name) {
    _dailyExercises.add(ExerciseData(date, duration, caloriePerMinute, name));
    notifyListeners();
  }

  // 운동 기록 삭제 메서드
  void removeExercise(int index) {
    if (index >= 0 && index < _dailyExercises.length) {
      _dailyExercises.removeAt(index);
      notifyListeners();
    }
  }

  // 특정 연월의 날짜별 소모 칼로리를 계산하는 메서드
  Map<String, double> calculateMonthlyCalories(String yearMonth) {
    Map<String, double> monthlyCalories = {};

    // 해당 연월의 모든 날짜를 0으로 초기화
    List<String> allDaysInMonth = _generateAllDaysInMonth(yearMonth);
    for (var day in allDaysInMonth) {
      monthlyCalories[day] = 0.0; // 기본적으로 모든 날짜를 0 칼로리로 설정
    }

    // 해당 연월의 운동 데이터를 날짜별로 합산
    for (var exercise in _dailyExercises) {
      if (exercise.date.startsWith(yearMonth)) {
        final calories = exercise.calories;
        monthlyCalories.update(
          exercise.date,
          (existingCalories) => existingCalories + calories,
          ifAbsent: () => calories,
        );
      }
    }

    return monthlyCalories;
  }

  // 주어진 연월의 모든 날짜 목록을 생성하는 함수
  List<String> _generateAllDaysInMonth(String yearMonth) {
    int year = int.parse(yearMonth.split('-')[0]);
    int month = int.parse(yearMonth.split('-')[1]);

    // 월의 마지막 날을 계산
    int daysInMonth = DateTime(year, month + 1, 0).day;

    List<String> allDays = [];
    for (int i = 1; i <= daysInMonth; i++) {
      allDays.add("$yearMonth-${i.toString().padLeft(2, '0')}");
    }
    return allDays;
  }

  // 사용 가능한 연월 목록 생성 (예: ["2023-11", "2023-10"])
  List<String> getAvailableMonths() {
    return _dailyExercises
        .map((exercise) => exercise.date.substring(0, 7)) // "yyyy-MM" 형식 추출
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // 최신순 정렬
  }

  // 일정 추가 메서드: 활동 내용과 시작 및 종료 시간 정보 추가
  void addSchedule(String activity, TimeOfDay startTime, TimeOfDay endTime) {
    _schedules.add({
      'activity': activity,
      'start': startTime,
      'end': endTime,
    });
    notifyListeners();
  }

  // 일정 삭제 메서드
  void deleteSchedule(int index) {
    _schedules.removeAt(index);
    notifyListeners();
  }

  // 가장 긴 빈 시간대를 찾아 추천하는 메서드
  TimeOfDay? recommendExerciseTime() {
    if (_schedules.isEmpty) return null;

    _schedules.sort((a, b) =>
        _timeToMinutes(a['start']!).compareTo(_timeToMinutes(b['start']!)));

    int maxFreeTime = 0;
    TimeOfDay? bestStartTime;

    int firstFreeTime = _timeToMinutes(_schedules[0]['start']!) -
        _timeToMinutes(TimeOfDay(hour: 0, minute: 0));

    if (firstFreeTime > maxFreeTime) {
      maxFreeTime = firstFreeTime;
      bestStartTime = TimeOfDay(hour: 0, minute: 0);
    }

    for (int i = 0; i < _schedules.length - 1; i++) {
      int freeTime = _timeToMinutes(_schedules[i + 1]['start']!) -
          _timeToMinutes(_schedules[i]['end']!);
      if (freeTime > maxFreeTime) {
        maxFreeTime = freeTime;
        bestStartTime = _schedules[i]['end'];
      }
    }

    int lastFreeTime = _timeToMinutes(TimeOfDay(hour: 23, minute: 59)) -
        _timeToMinutes(_schedules.last['end']!);

    if (lastFreeTime > maxFreeTime) {
      bestStartTime = _schedules.last['end'];
    }

    return bestStartTime;
  }

  // 시간을 분 단위로 변환하는 헬퍼 함수
  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  // 사용자 정보 입력 확인 메서드
  bool isUserInfoComplete() {
    return _weight != null && _height != null && _dietGoal != null;
  }

  // 오늘의 운동 기록 가져오기
  List<ExerciseData> getTodayExercises() {
    String today = DateTime.now().toIso8601String().substring(0, 10);
    return _dailyExercises.where((exercise) => exercise.date == today).toList();
  }

  // 최근 7일간의 칼로리 소모량 계산하기
  Map<String, double> calculateWeeklyCalories() {
    Map<String, double> weeklyCalories = {};
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime day = today.subtract(Duration(days: i));
      String dayString = day.toIso8601String().substring(0, 10);
      double dailyCalories = _dailyExercises
          .where((exercise) => exercise.date == dayString)
          .fold(0, (total, exercise) => total + exercise.calories);
      weeklyCalories[dayString] = dailyCalories;
    }

    return weeklyCalories;
  }
}
