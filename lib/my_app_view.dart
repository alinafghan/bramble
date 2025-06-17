import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:journal_app/blocs/font_cubit/font_cubit.dart';
import 'package:journal_app/blocs/theme_cubit/theme_cubit.dart';
import 'package:journal_app/models/book.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:journal_app/screens/about_screen.dart';
import 'package:journal_app/screens/book_screen.dart';
import 'package:journal_app/screens/booklist_screen.dart';
import 'package:journal_app/screens/font_screen.dart';
import 'package:journal_app/screens/home_screen.dart';
import 'package:journal_app/screens/journal_list_screen.dart';
import 'package:journal_app/screens/journal_screen.dart';
import 'package:journal_app/screens/library_screen.dart';
import 'package:journal_app/screens/moderate_reviews_screen.dart';
import 'package:journal_app/screens/profile_screen.dart';
import 'package:journal_app/screens/review_screen.dart';
import 'package:journal_app/screens/reviews_book_screen.dart';
import 'package:journal_app/screens/settings_screen.dart';
import 'package:journal_app/utils/constants.dart';
import 'screens/splash_screen.dart';

class MyAppView extends StatelessWidget {
  //have a repository for all the auth methods so not calling
  const MyAppView({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc = AuthenticationBloc(
      authRepository: AuthRepository(),
    );

    final GoRouter router = GoRouter(
      refreshListenable: StreamToListenable([authBloc.stream]),
      redirect: (context, state) {
        final isAuthenticated =
            authBloc.state.status == AuthenticationStatus.authenticated;
        final isUnAuthenticated =
            authBloc.state.status == AuthenticationStatus.unauthenticated;

        final loggingIn =
            state.matchedLocation == '/' || state.matchedLocation == '/';

        if (isUnAuthenticated && !loggingIn) {
          return '/';
        }
        if (isAuthenticated && (state.matchedLocation == '/' || loggingIn)) {
          return '/home';
        }

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return SplashScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'book',
              builder: (BuildContext context, GoRouterState state) {
                return BookScreen(
                  book: state.extra as Book,
                );
              },
            ),
            GoRoute(
              path: 'reviews',
              builder: (BuildContext context, GoRouterState state) {
                return const ModerateReviewsScreen();
              },
            ),
            GoRoute(
                path: 'home',
                builder: (BuildContext context, GoRouterState state) {
                  return const HomeScreen();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'settings',
                    builder: (BuildContext context, GoRouterState state) {
                      return const SettingsScreen();
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'about',
                        builder: (BuildContext context, GoRouterState state) {
                          return const AboutScreen();
                        },
                      ),
                      GoRoute(
                        path: 'profile',
                        builder: (BuildContext context, GoRouterState state) {
                          return const ProfileScreen(
                            readOnly: true,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'edit_profile',
                        builder: (BuildContext context, GoRouterState state) {
                          return const ProfileScreen(
                            readOnly: false,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'font',
                        builder: (BuildContext context, GoRouterState state) {
                          return const FontScreen();
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'journal_list',
                    builder: (BuildContext context, GoRouterState state) {
                      return JournalListScreen(
                        moodMap: state.extra as Map<String, String>,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'journal/:selectedDate/:mood',
                    builder: (BuildContext context, GoRouterState state) {
                      return KeyboardVisibilityProvider(
                        child: JournalScreen(
                          selectedDate: DateTime.parse(Uri.decodeComponent(
                              (state.pathParameters['selectedDate']!))),
                          mood: Uri.decodeComponent(
                              state.pathParameters['mood']!),
                        ),
                      );
                    },
                  ),
                ]),
            GoRoute(
              path: 'booklist',
              builder: (BuildContext context, GoRouterState state) {
                return const BooklistScreen();
              },
            ),
            GoRoute(
              path: 'library',
              builder: (BuildContext context, GoRouterState state) {
                return const LibraryScreen();
              },
            ),
            GoRoute(
              path: 'review',
              builder: (BuildContext context, GoRouterState state) {
                return KeyboardVisibilityProvider(
                  child: SetReviewScreen(
                    book: state.extra as Book,
                  ),
                );
              },
            ),
            GoRoute(
              path: 'book_review',
              builder: (BuildContext context, GoRouterState state) {
                return BookReviewsScreen(
                  book: state.extra as Book,
                );
              },
            ),
          ],
        ),
      ],
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CalendarBloc(),
        ),
        BlocProvider(create: (context) => authBloc),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<FontCubit, String>(
            builder: (context, fontFamily) {
              return MaterialApp.router(
                theme: AppThemes.lightTheme(fontFamily), // Light mode
                darkTheme: AppThemes.darkTheme(fontFamily), // Dark mode
                themeMode: themeMode,
                debugShowCheckedModeBanner: false,
                // routeInformationProvider: router.routeInformationProvider,
                // routerDelegate: router.routerDelegate,
                // routeInformationParser: router.routeInformationParser,
                routerConfig: router,
              );
            },
          );
        },
      ),
    );
  }
}

class StreamToListenable extends ChangeNotifier {
  late final List<StreamSubscription> subscriptions;

  StreamToListenable(List<Stream> streams) {
    subscriptions = [];
    for (var e in streams) {
      var s = e.asBroadcastStream().listen(_tt);
      subscriptions.add(s);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (var e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _tt(event) => notifyListeners();
}
