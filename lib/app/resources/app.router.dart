import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/services/navigation_service.dart';
import 'package:hospital_staff_management/ui/features/create_account/login_views/signin_user_view.dart';
import 'package:hospital_staff_management/ui/features/activity/activity_view/activity_view.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/homepage.dart';
import 'package:hospital_staff_management/ui/features/profile/profile_view/profile_view.dart';
import 'package:hospital_staff_management/ui/features/record_screen/record_view/record_view.dart';
import 'package:hospital_staff_management/ui/features/splash_screen/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    // initialLocation: '/createAccountView',
    // initialLocation: '/homepageView',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      /// App Pages
      GoRoute(
        path: '/homepageView',
        builder: (context, state) => const HomepageView(),
      ),
      GoRoute(
        path: '/recordPageView',
        builder: (context, state) => const RecordPageView(),
      ),
      GoRoute(
        path: '/profilePageView',
        builder: (context, state) => const ProfilePageView(),
      ),
      GoRoute(
        path: '/activityPageView',
        builder: (context, state) => const ActivityPageView(),
      ),
      //
      GoRoute(
        path: '/signInView',
        builder: (context, state) => SignInView(),
      ),
    ],
  );
}
