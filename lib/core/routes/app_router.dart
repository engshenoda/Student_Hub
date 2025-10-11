import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/createAcount_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/forget_password/forget_pasword.dart';
import 'package:linkedin/features/auth/presentation/screens/login/login_screen.dart';
import 'package:linkedin/features/chat/Presentation/Screen/chat_screen.dart';
import 'package:linkedin/features/feature_questions/screen/career_preference_screen.dart';
import 'package:linkedin/features/home/presentation/screens/home_screen.dart';
import 'package:linkedin/features/home/presentation/screens/post.dart';
import 'package:linkedin/features/jobs/presentation/screen/jobs_screen.dart';
import 'package:linkedin/features/jobs/presentation/screen/see_all_screen.dart';
import 'package:linkedin/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:linkedin/features/onbording/Onboarding_pages.dart';
import 'package:linkedin/features/onbording/splash_screen.dart';
import 'package:linkedin/features/profile/presentation/screens/profile_screen.dart';
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
        path: Routes.onboardingScreen,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.createAccaount,
        builder: (context, state) => const CreateAccountScreen(),
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
        path: Routes.login,
        builder: (context, state) => const ForgetPasword(),
      ),
      GoRoute(
        path: Routes.careerpreference,
        builder: (context, state) => const CareerPreferenceScreen(),
      ),
      GoRoute(
        path: Routes.Home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.messahes,
        builder: (context, state) => const ChatsListScreen(),
      ),
      
      // GoRoute(
      //   path: Routes.chatscreen ,
        
      //   builder: (context, state) =>  ChatScreen(chatModel: null,),
      // ),
      GoRoute(
        path: Routes.notifcation,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
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
      GoRoute(path: Routes.create, builder: (context, state) => const Post()),
    ],
  );
}
