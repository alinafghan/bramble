import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:journal_app/blocs/add_book_cubit/add_book_cubit.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/blocs/get_review_for_book/cubit/task_cubit_cubit.dart';
import 'package:journal_app/blocs/get_book_details_cubit/get_book_details_cubit.dart';
import 'package:journal_app/blocs/get_journal_bloc/get_journal_bloc.dart';
import 'package:journal_app/blocs/get_review_for_book/get_review_for_book_cubit.dart';
import 'package:journal_app/blocs/get_saved_books_cubit/get_saved_books_cubit.dart';
import 'package:journal_app/blocs/get_library_bloc/get_library_bloc.dart';
import 'package:journal_app/blocs/mood_bloc/mood_bloc.dart';
import 'package:journal_app/blocs/remove_book_cubit/remove_book_cubit.dart';
import 'package:journal_app/blocs/search_book_cubit/search_book_cubit.dart';
import 'package:journal_app/blocs/set_journal_bloc/set_journal_bloc.dart';
import 'package:journal_app/blocs/set_review_cubit/set_review_cubit.dart';
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
      BlocProvider<RemoveBookCubit>(
        create: (_) => RemoveBookCubit(provider: BookListProvider()),
      ),
      BlocProvider<GetSavedBooksCubit>(
        create: (_) => GetSavedBooksCubit(provider: BookListProvider()),
      ),
      BlocProvider<AddBookCubit>(
        create: (_) => AddBookCubit(provider: BookListProvider()),
      ),
      BlocProvider<TaskCubitCubit>(
        create: (_) => TaskCubitCubit(),
      ),
      BlocProvider<GetBookDetailsCubit>(
        create: (_) => GetBookDetailsCubit(provider: LibraryProvider()),
      ),
      BlocProvider<GetLibraryBloc>(
        create: (_) => GetLibraryBloc(provider: LibraryProvider()),
      ),
      BlocProvider<GetReviewForBookCubit>(
        create: (_) => GetReviewForBookCubit(provider: ReviewProvider()),
      ),
      BlocProvider<SetReviewCubit>(
          create: (_) => SetReviewCubit(provider: ReviewProvider())),
      BlocProvider<AuthenticationBloc>(
          create: (_) =>
              AuthenticationBloc(authRepository: FirebaseAuthRepository())),
      BlocProvider<SearchBookCubit>(
        create: (_) => SearchBookCubit(provider: LibraryProvider()),
      ),
      BlocProvider<MoodBloc>(
        create: (_) => MoodBloc(provider: MoodProvider()),
      ),
      BlocProvider<GetJournalBloc>(
        create: (_) => GetJournalBloc(provider: JournalProvider()),
      ),
      BlocProvider<SetJournalBloc>(
        create: (_) => SetJournalBloc(provider: JournalProvider()),
      ),
    ], child: const MyAppView());
  }
}
