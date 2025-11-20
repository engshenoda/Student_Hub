// student_hub.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/core/routes/app_router.dart';
import 'package:linkedin/features/auth/data/auth_repo.dart';
import 'package:linkedin/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:linkedin/features/home/data/repo/post_repository.dart';
import 'package:linkedin/features/home/data/service/post_service.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';

class StudentHub extends StatelessWidget {
  const StudentHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepo()),
        RepositoryProvider(create: (context) => PostServices()),
        RepositoryProvider(create: (context) => PostRepository(context.read<PostServices>())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(create: (context) => PostCubit(context.read<PostRepository>())),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRoute.router,
          theme: ThemeData(
            primaryColor: const Color(0xFF007A66),
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          ),
        ),
      ),
    );
  }
}