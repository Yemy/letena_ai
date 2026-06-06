import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/language_select_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/identity_select_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/mood/screens/mood_checkin_screen.dart';
import '../../features/mood/screens/wellness_dashboard_screen.dart';
import '../../features/ai_companion/screens/companion_screen.dart';
import '../../features/wellness/screens/wellness_hub_screen.dart';
import '../../features/wellness/screens/mind_screen.dart';
import '../../features/wellness/screens/body_screen.dart';
import '../../features/wellness/screens/nutrition_screen.dart';
import '../../features/wellness/screens/sleep_screen.dart';
import '../../features/wellness/screens/digital_screen.dart';
import '../../features/gamification/screens/achievements_screen.dart';
import '../../features/gamification/screens/leagues_screen.dart';
import '../../features/community/screens/community_screen.dart';
import '../../features/challenges/screens/challenges_screen.dart';
import '../../features/challenges/screens/challenge_detail_screen.dart';
import '../../features/journal/screens/journal_list_screen.dart';
import '../../features/journal/screens/journal_entry_screen.dart';
import '../../features/emergency/screens/emergency_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../shell/app_shell.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Onboarding
      GoRoute(path: '/splash', builder: (ctx, state) => const SplashScreen()),
      GoRoute(path: '/language', builder: (ctx, state) => const LanguageSelectScreen()),
      GoRoute(path: '/welcome', builder: (ctx, state) => const WelcomeScreen()),
      GoRoute(path: '/identity', builder: (ctx, state) => const IdentitySelectScreen()),

      // Main App Shell
      ShellRoute(
        builder: (ctx, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (ctx, state) => const HomeScreen()),
          GoRoute(path: '/companion', builder: (ctx, state) => const CompanionScreen()),
          GoRoute(path: '/wellness', builder: (ctx, state) => WellnessHubScreen()),
          GoRoute(path: '/community', builder: (ctx, state) => const CommunityScreen()),
          GoRoute(path: '/profile', builder: (ctx, state) => const ProfileScreen()),
        ],
      ),

      // Modal / deep routes
      GoRoute(path: '/mood', builder: (ctx, state) => const MoodCheckInScreen()),
      GoRoute(path: '/wellness-dashboard', builder: (ctx, state) => const WellnessDashboardScreen()),
      GoRoute(path: '/wellness/mind', builder: (ctx, state) => const MindScreen()),
      GoRoute(path: '/wellness/body', builder: (ctx, state) => const BodyScreen()),
      GoRoute(path: '/wellness/nutrition', builder: (ctx, state) => const NutritionScreen()),
      GoRoute(path: '/wellness/sleep', builder: (ctx, state) => const SleepScreen()),
      GoRoute(path: '/wellness/digital', builder: (ctx, state) => const DigitalScreen()),
      GoRoute(path: '/achievements', builder: (ctx, state) => const AchievementsScreen()),
      GoRoute(path: '/leagues', builder: (ctx, state) => const LeaguesScreen()),
      GoRoute(path: '/challenges', builder: (ctx, state) => const ChallengesScreen()),
      GoRoute(
        path: '/challenges/:id',
        builder: (ctx, state) => ChallengeDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(path: '/journal', builder: (ctx, state) => const JournalListScreen()),
      GoRoute(path: '/journal/new', builder: (ctx, state) => const JournalEntryScreen()),
      GoRoute(path: '/emergency', builder: (ctx, state) => const EmergencyScreen()),
      GoRoute(path: '/settings', builder: (ctx, state) => const SettingsScreen()),
    ],
  );
}

