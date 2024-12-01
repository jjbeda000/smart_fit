import 'package:flutter/material.dart'; // Flutter의 UI 구축을 위한 패키지

// CustomButton이라는 StatelessWidget을 정의. 이 위젯은 상태가 변하지 않는 버튼.
class CustomButton extends StatelessWidget {
  final String label; // 버튼에 표시할 텍스트
  final IconData icon; // 버튼에 표시할 아이콘
  final VoidCallback onPressed; // 버튼 클릭 시 호출될 함수

  // 생성자: 버튼을 생성할 때 텍스트(label), 아이콘(icon), 클릭 시 호출되는 함수(onPressed)를 필수로 받음.
  const CustomButton({
    Key? key,
    required this.label, // 반드시 전달해야 하는 텍스트
    required this.icon, // 반드시 전달해야 하는 아이콘
    required this.onPressed, // 반드시 전달해야 하는 클릭 동작
  }) : super(key: key);

  // build 메서드: UI를 그리는 역할을 담당. 이 메서드는 Flutter가 UI를 생성할 때 호출됨.
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed, // 버튼이 클릭되면 onPressed 함수를 호출함
      icon: Icon(icon, size: 24), // 아이콘의 크기를 24로 설정
      label: Text(
        label, // 버튼에 표시될 텍스트
        style: const TextStyle(fontSize: 16), // 텍스트 스타일을 지정 (폰트 크기 16)
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            vertical: 16.0, horizontal: 24.0), // 버튼의 패딩 설정 (세로: 16, 가로: 24)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // 버튼의 모서리를 둥글게 (반지름 10)
        ),
      ),
    );
  }
}
