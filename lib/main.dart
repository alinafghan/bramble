import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:journal_app/blocs/add_book_cubit/add_book_cubit.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:journal_app/blocs/get_saved_books_cubit/get_saved_books_cubit.dart';
import 'package:journal_app/blocs/get_library_bloc/get_library_bloc.dart';
import 'package:journal_app/blocs/remove_book_cubit/remove_book_cubit.dart';
import 'package:journal_app/my_app_view.dart';
import 'package:journal_app/providers/library_provider/library_provider.dart';
import 'package:journal_app/providers/auth_provider/auth_provider.dart';
import 'package:journal_app/providers/book_provider/book_provider.dart';
import 'package:journal_app/repositories/auth_repository.dart';
import 'package:journal_app/simple_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
  runApp(MyApp(MyAuthProvider()));
}

class MyApp extends StatelessWidget {
  final MyAuthProvider authProvider;
  //have a repository for all the auth methods so not calling
  const MyApp(this.authProvider, {super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<RemoveBookCubit>(
        create: (_) => RemoveBookCubit(provider: BookListProvider()),
      ),
      RepositoryProvider<GetSavedBooksCubit>(
        create: (_) => GetSavedBooksCubit(provider: BookListProvider()),
      ),
      RepositoryProvider<AddBookCubit>(
        create: (_) => AddBookCubit(provider: BookListProvider()),
      ),
      RepositoryProvider<GetLibraryBloc>(
        create: (_) => GetLibraryBloc(provider: LibraryProvider()),
      ),
      RepositoryProvider<AuthenticationBloc>(
          create: (_) =>
              AuthenticationBloc(authRepository: FirebaseAuthRepository()))
    ], child: const MyAppView());
  }
}
