import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/create_account_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/forget_password/forget_pasword.dart';
import 'package:linkedin/features/auth/presentation/screens/login/login_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/set_password_reset/password_reset_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/set_password_reset/set_new_password_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/verification/verify.dart';
import 'package:linkedin/features/chat/Presentation/widget/chat_screen.dart';
import 'package:linkedin/features/chat/Presentation/widget/chats_list_screen.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/presentation/screens/comments.dart';

import 'package:linkedin/features/home/presentation/screens/home_screen.dart';
import 'package:linkedin/features/home/presentation/screens/post.dart';
import 'package:linkedin/features/home/presentation/screens/repost.dart';
import 'package:linkedin/features/jobs/logic/cubit/jobs_cubit.dart';
import 'package:linkedin/features/jobs/presentation/screen/jobs_screen.dart';
import 'package:linkedin/features/jobs/presentation/screen/see_all_screen.dart';
import 'package:linkedin/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:linkedin/features/onbording/Onboarding_pages.dart';
import 'package:linkedin/features/onbording/splash_screen.dart';
import 'package:linkedin/features/profile/presentation/screens/profile_screen.dart';
import 'package:linkedin/features/questions/presentation/profile_screen.dart';
import 'package:linkedin/features/search_feature/search_screen.dart';
import 'package:linkedin/features/settings/screens/about_us.dart';
import 'package:linkedin/features/settings/screens/settings.dart';
import 'package:linkedin/features/settings/screens/terms_and_conditions.dart';

abstract class AppRoute {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
  path: '/jobs',
  builder: (context, state) {
    return BlocProvider(
      create: (_) => JobsCubit()..fetchJobs(),
      child: const JobScreen(),
    );
  },
),

      GoRoute(
        path: Routes.onboardingScreen,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.createAccaount,
        builder: (context, state) => const CreateAccountScreen(),
      ),

      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.forgetpassword,
        builder: (context, state) => const ForgetPasword(),
      ),
      GoRoute(
        path: Routes.veryfypassword,
        builder: (context, state) => const VerifyCodeScreen(),
      ),
      GoRoute(
        path: Routes.setnewpassword,
        builder: (context, state) => const SetNewPasswordScreen(),
      ),
      GoRoute(
        path: Routes.passwordreset,
        builder: (context, state) => const PasswordResetScreen(),
      ),
      // GoRoute(
      //   path: Routes.careerpreference,
      //   builder: (context, state) => const CareerNextScreen(),
      // ),
      GoRoute(
        path: Routes.profileqscreen,
        builder: (context, state) => const ProfileQScreen(),
      ),
      GoRoute(
        path: Routes.Home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.messahes,
        builder: (context, state) => const ChatsListScreen(),
      ),

      GoRoute(
        path: Routes.chatscreen,

        builder: (context, state) => ChatScreen(chatName: '', receiverId: '',),
      ),
      GoRoute(
        path: Routes.notifcation,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        name: 'profile',
        builder: (context, state) {
          // final uid = state.pathParameters['uid']!;
          return ProfileScreen();
        },
      ),

      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const Settings(),
      ),
      GoRoute(
        path: Routes.search,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: Routes.aboutUs,
        builder: (context, state) => const About_Us(),
      ),
      GoRoute(
        path: Routes.termsandconditions,
        builder: (context, state) => const Termsandconditions(),
      ),
      GoRoute(
        path: Routes.jobs,
        builder: (context, state) => const JobScreen(),
      ),
      GoRoute(
        path: Routes.alljobsscreen,
        builder: (context, state) => const AllJobsScreen(),
      ),
      GoRoute(
  path: '/AddPost',
  builder: (context, state) {
    final post = state.extra as Post?;
    return AddPost(existing: post);
  },
),
GoRoute(
  path: '/repost',
  builder: (context, state) {
    final originalPost = state.extra as Post;
    return Repost(originalPost: originalPost);
  },
),

    GoRoute(
  path: '/comments',
  builder: (context, state) {
    final postId = state.extra as String;
    return Comments(postId: postId);
  },
),


    ],
  );
}
