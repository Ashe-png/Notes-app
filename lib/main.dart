import 'package:flutter/material.dart';
// import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/constants/routes.dart';
import 'package:my_app/helpers/loading/loading_screen.dart';
// import 'package:my_app/services/auth/auth_service.dart';
import 'package:my_app/services/auth/bloc/auth_bloc.dart';
import 'package:my_app/services/auth/bloc/auth_event.dart';
import 'package:my_app/services/auth/bloc/auth_state.dart';
import 'package:my_app/services/auth/firebase_auth_provider.dart';
import 'package:my_app/views/forgot_password_view.dart';
import 'package:my_app/views/login_view.dart';
import 'package:my_app/views/notes/create_update_note_view.dart';
import 'package:my_app/views/notes/notes_view.dart';
import 'package:my_app/views/register_view.dart';
import 'package:my_app/views/verify_email_view.dart';
// import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );

    // return FutureBuilder(
    //   future: AuthService.firebase().initialize(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         final user = AuthService.firebase().currentUser;
    //         if (user != null) {
    //           if (user.isEmailVerified) {
    //             return const NotesView();
    //           } else {
    //             return const VerifyEmailView();
    //           }
    //         } else {
    //           return const LoginView();
    //         }
    //       // if (user?.emailVerified ?? false) {
    //       //   // return const Text('Done');
    //       // } else {
    //       //   return const VerifyEmailView();
    //       // }
    //       // return const Text('Done');
    //       default:
    //         return const Text('Loading...');
    //     }
    //   },
    // );
  }
}
