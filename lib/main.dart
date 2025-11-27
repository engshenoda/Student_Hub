// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubit.dart';
import 'package:linkedin/firebase_options.dart';
import 'package:linkedin/student_hub.dart';
import 'package:linkedin/features/home/data/repo/post_repository.dart';
import 'package:linkedin/features/home/data/service/post_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => PostServices()),
        RepositoryProvider(
          create: (context) => PostRepository(context.read<PostServices>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                PostCubit(context.read<PostRepository>())..watchPosts(),
          ),
        ],
        child: const StudentHub(),
      ),
    );
  }
}
