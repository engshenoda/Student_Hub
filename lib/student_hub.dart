import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin/core/routes/app_router.dart';
import 'package:linkedin/features/home/data/rebo/posr_repo.dart';
import 'package:linkedin/features/home/data/service/post_service.dart';
import 'package:linkedin/features/home/logic/post_cubit/post_cubt.dart';

class StudentHub extends StatelessWidget {
  const StudentHub({super.key});

  @override
  Widget build(BuildContext context) {
    final postRepository = PostRepository(PostService());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PostCubit(repo: postRepository)..start(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoute.router,
      ),
    );
  }
}
