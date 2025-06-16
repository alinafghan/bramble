import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/blocs/cubit/task_cubit_cubit.dart';
import 'package:journal_app/blocs/journal_bloc/journal_bloc.dart';
import 'package:journal_app/utils/popup_menu2.dart';
import 'package:mocktail/mocktail.dart';

class MockJournalBloc extends Mock implements JournalBloc {}

void main() {
  late JournalBloc mockJournalBloc;

  setUp(() {
    mockJournalBloc = MockJournalBloc();
  });

  Widget buildTestableWidget({
    required String date,
    required VoidCallback onEdit,
  }) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            body: Row(
              children: [
                BlocProvider(
                  create: (context) => TaskCubitCubit(),
                  child: PopupMenu2(date: date, onEdit: onEdit),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        return BlocProvider<JournalBloc>.value(
          value: mockJournalBloc,
          child: child!,
        );
      },
    );
  }

  group('PopupMenu2 Widget Tests', () {
    testWidgets('shows Edit and Delete options', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(
        date: '2024-06-15',
        onEdit: () {},
      ));

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('shows delete confirmation dialog when Delete is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(
        date: '2024-06-15',
        onEdit: () {},
      ));

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Journal'), findsOneWidget);
      expect(
        find.text(
            'Are you sure you want to delete this journal entry? This action cannot be undone.'),
        findsOneWidget,
      );
    });
  });
}
