import 'package:flutter/material.dart'; // Flutter의 UI 구축을 위한 패키지

// ResponsiveWidget이라는 StatelessWidget을 정의.
// 주어진 화면 크기에 따라 서로 다른 위젯을 반환함.
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile; // 모바일 화면에서 표시될 위젯
  final Widget? tablet; // 태블릿 화면에서 표시될 위젯 (선택 사항)
  final Widget? desktop; // 데스크탑 화면에서 표시될 위젯 (선택 사항)

  // 생성자: 모바일 화면 위젯은 필수, 태블릿과 데스크탑은 선택 사항
  const ResponsiveWidget({
    Key? key,
    required this.mobile, // 반드시 전달해야 하는 모바일 위젯
    this.tablet, // 선택적으로 전달 가능한 태블릿 위젯
    this.desktop, // 선택적으로 전달 가능한 데스크탑 위젯
  }) : super(key: key);

  // 모바일 기기를 판별하는 함수: 화면 너비가 600보다 작은 경우 모바일로 간주
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  // 태블릿 기기를 판별하는 함수: 화면 너비가 600 이상이고 1200 미만인 경우 태블릿으로 간주
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  // 데스크탑 기기를 판별하는 함수: 화면 너비가 1200 이상인 경우 데스크탑으로 간주
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  // build 메서드: UI를 그리는 역할을 담당.
  @override
  Widget build(BuildContext context) {
    if (isDesktop(context) && desktop != null) {
      // 데스크탑인 경우 desktop 위젯을 반환
      return desktop!;
    } else if (isTablet(context) && tablet != null) {
      // 태블릿인 경우 tablet 위젯을 반환
      return tablet!;
    } else {
      // 그 외에는 mobile 위젯을 반환
      return mobile;
    }
  }
}
