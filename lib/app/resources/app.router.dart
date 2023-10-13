import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/services/navigation_service.dart';
import 'package:hospital_staff_management/ui/features/create_account/login_views/signin_user_view.dart';
import 'package:hospital_staff_management/ui/features/activity/activity_view/activity_view.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/homepage.dart';
import 'package:hospital_staff_management/ui/features/profile/profile_view/profile_view.dart';
import 'package:hospital_staff_management/ui/features/insights_screen/insights_view/insights_view.dart';
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
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const HomepageView(), key: state.pageKey),
      ),
      GoRoute(
        path: '/insightsPageView',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const InsightsPageView(), key: state.pageKey),
      ),
      GoRoute(
        path: '/profilePageView',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const ProfilePageView(), key: state.pageKey),
      ),
      GoRoute(
        path: '/activityPageView',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const ActivityPageView(), key: state.pageKey),
      ),
      //
      GoRoute(
        path: '/signInView',
        builder: (context, state) => SignInView(),
      ),
    ],
  );
}

class CustomNormalTransition extends CustomTransitionPage {
  CustomNormalTransition({required LocalKey key, required Widget child})
      : super(
          key: key,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 0),
          child: child,
        );
}