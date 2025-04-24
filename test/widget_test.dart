// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:alchemist/alchemist.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:journal_app/screens/test_screen.dart';

// void main() {
//   setUpAll(() async {
//     TestWidgetsFlutterBinding.ensureInitialized();
//   });

//   goldenTest(
//     'TestScreen renders correctly',
//     fileName: 'test_screen',
//     builder: () => GoldenTestGroup(
//         scenarioConstraints: const BoxConstraints(maxWidth: 600),
//         children: [
//           GoldenTestScenario(
//             name: 'TestScr',
//             child: const TestScreen(),
//           ),
//         ]),
//   );
// }
import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journal_app/screens/test_screen.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('MyApp Golden Tests', () {
    goldenTest(
      'renders full countries list on multiple screen sizes',
      fileName: 'text_screen',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 6000),
        children: [
          GoldenTestScenario(
            name: 'Mobile (iPhone 13 Pro)',
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 844),
            child: const TestScreen(),
          ),
          GoldenTestScenario(
            name: 'Tablet (iPad Air)',
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 1180),
            child: const TestScreen(),
          ),
        ],
      ),
    );
  });
}
