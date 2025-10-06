import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/core/widgets/custom_bottom_navigation.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/createAcount_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/onbording/OnboardingScreen1.dart';
import 'package:linkedin/features/auth/presentation/screens/onbording/splash_screen.dart';
import 'package:linkedin/features/home/presentation/screens/home_screen.dart';
import 'package:linkedin/features/notifications/notifications_screen.dart';
import 'package:linkedin/features/profile/presentation/screens/profile_screen.dart';

abstract class AppRoute {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboardingScreen,
        builder: (context, state) => const OnboardingScreen1(),
      ),
      GoRoute(
        path: Routes.createAccaount,
        builder: (context, state) => const CreateAccountScreen(),
      ),
      GoRoute(
        path: Routes.Home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.notifcation,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      
      // ShellRoute(
      //   builder: (context, state, child) {
      //     return CustomBottomNavigationBar(child: child);
      //   },
      //   routes: [
      //     GoRoute(
      //       path: Routes.Home,
      //       builder: (context, state) => const HomeScreen(),
      //     ),
      //     // GoRoute(
      //     //   path: Rutes.messahes,
      //     //   builder: (context, state) => const MessagesScreen(),
      //     // ),
      //     // GoRoute(
      //     //   path: Routes.create,
      //     //   builder: (context, state) => const CreateScreen(),
      //     // ),
      //     // GoRoute(
      //     //   path: Routes.jobs,
      //     //   builder: (context, state) => const JobsScreen(),
      //     // ),
      //     GoRoute(
      //       path: Routes.profile,
      //       builder: (context, state) => const ProfileScreen(),
      //     ),
      //   ],
      // ),
    ],
  );
}
