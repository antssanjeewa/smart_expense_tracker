import 'package:flutter/material.dart';

import '../../../../app/pages.dart';
import '../../../../core/constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 32),

                      Column(
                        children: [
                          Image.asset(AppAssets.appIcon, width: 120),

                          const SizedBox(height: 8),
                          Text(
                            'Welcome Back',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                          const SizedBox(height: 8),
                          Text(
                            'Please Enter Your Credentials To Continue',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email Address",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: 'test@example.com',
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              "Password",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                prefixIcon: Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.visibility_outlined),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Pages.home.go(context);
                                },
                                child: const Text('Login'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          Text(
                            "Or Login With",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          IconButton(
                            onPressed: () {
                              // Implement biometric login logic here
                            },
                            // onPressed: _handleBiometricLogin,
                            icon: const Icon(
                              Icons.fingerprint,
                              color: AppColors.primary,
                              size: 36,
                            ),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              backgroundColor: AppColors.primary.withAlpha(25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
