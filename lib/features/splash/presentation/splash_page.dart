import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/pages.dart';
import '../../../core/constants/constants.dart';
import '../../auth/domain/provider.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<String?>>(authStateProvider, (previous, next) {
      next.whenData((userId) {
        Future.delayed(const Duration(seconds: 3), () {
          if (!context.mounted) return;

          if (userId != null) {
            Pages.home.go(context);
          } else {
            Pages.login.go(context);
          }
        });
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background Glow
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [AppColors.surface, AppColors.background],
              ),
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Card
                AnimatedScale(
                  scale: 1.5,
                  duration: const Duration(seconds: 1),
                  child: Image.asset(AppAssets.appIcon, width: 120),
                ),

                const SizedBox(height: 32),
                Text(
                      'Smart Expense Tracker',
                      style: Theme.of(context).textTheme.headlineLarge,
                    )
                    .animate(delay: const Duration(seconds: 1))
                    .fadeIn()
                    .moveY(
                      begin: 20,
                      end: 0,
                      duration: const Duration(seconds: 1),
                    ),

                const SizedBox(height: 8),
                Text(
                      'YOUR PERSONAL FINANCE ASSISTANT',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                    .animate(delay: const Duration(seconds: 2))
                    .fadeIn()
                    .moveY(
                      begin: 20,
                      end: 0,
                      duration: const Duration(seconds: 1),
                    ),

                const SizedBox(height: 48),
              ],
            ),
          ),

          // Progress Bar
          Positioned(
            bottom: 68,
            left: 34,
            right: 34,
            child: Column(
              children: [
                Text(
                  'Synchronizing Data...',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.onSecondary.withAlpha(50),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Version Footer
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'v 2.4.0 • Secure & Encrypted',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
