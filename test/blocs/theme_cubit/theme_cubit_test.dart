import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:journal_app/blocs/theme_cubit/theme_cubit.dart';

void main() {
  group('ThemeCubit Tests', () {
    test('initial state is ThemeMode.system', () {
      expect(ThemeCubit().state, ThemeMode.system);
    });

    blocTest<ThemeCubit, ThemeMode>(
      'toggleTheme from light -> dark',
      build: () => ThemeCubit()..emit(ThemeMode.light),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.dark],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'toggleTheme from dark -> light',
      build: () => ThemeCubit()..emit(ThemeMode.dark),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.light],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'toggleTheme from system (defaults to light)',
      build: () => ThemeCubit(),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.light],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'setSystemTheme emits ThemeMode.system',
      build: () => ThemeCubit()..emit(ThemeMode.light),
      act: (cubit) => cubit.setSystemTheme(),
      expect: () => [ThemeMode.system],
    );
  });
}
