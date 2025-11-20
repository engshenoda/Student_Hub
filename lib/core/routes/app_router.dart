import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';
import 'package:linkedin/features/auth/presentation/screens/create_account/create_account_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/forget_password/forget_pasword.dart';
import 'package:linkedin/features/auth/presentation/screens/login/login_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/set_password_reset/password_reset_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/set_password_reset/set_new_password_screen.dart';
import 'package:linkedin/features/auth/presentation/screens/verification/verify.dart';
import 'package:linkedin/features/chat/presentation/widget/chat_screen.dart';
import 'package:linkedin/features/chat/presentation/widget/chats_list_screen.dart';
import 'package:linkedin/features/home/data/models/post_model.dart';
import 'package:linkedin/features/home/presentation/screens/add_post.dart';
import 'package:linkedin/features/home/presentation/screens/comments_screen.dart';
import 'package:linkedin/features/home/presentation/screens/home_screen.dart';
import 'package:linkedin/features/jobs/presentation/screen/jobs_screen.dart';
import 'package:linkedin/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:linkedin/features/onbording/onboarding_pages.dart';
import 'package:linkedin/features/onbording/splash_screen.dart';
import 'package:linkedin/features/profile/presentation/screens/profile_screen.dart';
import 'package:linkedin/features/questions/presentation/user_question_screen.dart';
import 'package:linkedin/features/search_feature/search_screen.dart';
import 'package:linkedin/features/settings/screens/about_us.dart';
import 'package:linkedin/features/settings/screens/settings.dart';
import 'package:linkedin/features/settings/screens/terms_and_conditions.dart';

class AppRoute {
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
      GoRoute(
        path: Routes.profileqscreen,
        builder: (context, state) => const ProfileQScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.messahes,
        builder: (context, state) => const ChatsListScreen(),
      ),
      GoRoute(
        path: Routes.chatscreen,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return ChatScreen(
            chatName: extra['chatName'] ?? '',
            receiverId: extra['receiverId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: Routes.notifcation,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: Routes.profile, // /profile
        name: 'my_profile',
        builder: (context, state) {
          final name = state.extra as String?;
          return ProfileScreen(uid: null, name: name);
        },
      ),
      GoRoute(
        path: '${Routes.profile}/:uid', // /profile/123
        name: 'user_profile',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          final name = state.extra as String?;
          return ProfileScreen(uid: uid, name: name);
        },
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const Settings(),
      ),
      GoRoute(path: Routes.search, builder: (context, state) => SearchPage()),
      GoRoute(
        path: Routes.aboutUs,
        builder: (context, state) => const AboutUs(),
      ),
      GoRoute(
        path: Routes.termsandconditions,
        builder: (context, state) => const Termsandconditions(),
      ),
      GoRoute(
        path: Routes.jobs,
        builder: (context, state) => const JobsScreen(),
      ),
      GoRoute(
        path: Routes.addPostScreen,
        builder: (context, state) => const AddPostScreen(),
      ),
      GoRoute(
        path: Routes.comments,
        builder: (context, state) {
          final post = state.extra as PostModel;
          return CommentsScreen(post: post);
        },
      ),
    ],
  );
}
