import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/blocs/cubit/task_cubit_cubit.dart';
import 'package:journal_app/blocs/booklist_cubit/booklistcubit.dart';
import 'package:journal_app/blocs/get_book_details_cubit/get_book_details_cubit.dart';
import 'package:journal_app/blocs/journal_bloc/journal_bloc.dart';
import 'package:journal_app/blocs/library_bloc/get_library_bloc.dart';
import 'package:journal_app/blocs/mood_bloc/mood_bloc.dart';
import 'package:journal_app/blocs/review_cubit/review_cubit.dart';
import 'package:journal_app/blocs/theme_cubit/theme_cubit.dart';
import 'package:journal_app/my_app_view.dart';
import 'package:journal_app/providers/journal_provider/journal_provider.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';
import 'package:journal_app/providers/mood_provider/mood_provider.dart';
import 'package:journal_app/providers/review_provider/review_provider.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:journal_app/simple_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://jzboacqcyalyouakshwx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6Ym9hY3FjeWFseW91YWtzaHd4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY0Njg0MjEsImV4cCI6MjA2MjA0NDQyMX0.sEPz6PIDh41-JPK76fQHjvIOcENe3T3Zfw9toNde-Dk',
  );
  runApp(MyApp(MyAuthProvider()));
}

class MyApp extends StatelessWidget {
  final MyAuthProvider authProvider;
  //have a Bloc for all the auth methods so not calling
  const MyApp(this.authProvider, {super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<BookListCubit>(
        create: (_) => BookListCubit(listProvider: BookListProvider()),
      ),
      BlocProvider<TaskCubitCubit>(
        create: (_) => TaskCubitCubit(),
      ),
      BlocProvider<LibraryBloc>(
        create: (_) => LibraryBloc(libraryProvider: LibraryProvider()),
      ),
      BlocProvider<GetBookDetailsCubit>(
        create: (_) => GetBookDetailsCubit(provider: LibraryProvider()),
      ),
      BlocProvider<ReviewCubit>(
          create: (_) => ReviewCubit(reviewProvider: ReviewProvider())),
      BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(authRepository: AuthRepository())),
      BlocProvider<MoodBloc>(
        create: (_) => MoodBloc(moodProvider: MoodProvider()),
      ),
      BlocProvider<JournalBloc>(
        create: (_) => JournalBloc(journalProvider: JournalProvider()),
      ),
      BlocProvider<ThemeCubit>(
        create: (_) => ThemeCubit(),
      ),
    ], child: const MyAppView());
  }
}
