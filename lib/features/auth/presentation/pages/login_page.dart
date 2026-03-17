import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_tracker/features/auth/presentation/pages/login_button.dart';

import '../../../../app/pages.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_validation.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<String?>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (userId) {
          if (userId != null) Pages.home.go(context);
        },
        error: (err, _) => context.showError(err.toString()),
      );
    });

    final authState = ref.watch(authControllerProvider);
    final isObscure = ref.watch(passwordVisibilityProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Column(
                children: [
                  Image.asset(AppAssets.appIcon, width: 120),

                  const SizedBox(height: AppSpacing.s),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: AppSpacing.s),
                  Text(
                    'Please Enter Your Credentials To Continue',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, "Email Address"),
                    TextFormField(
                      controller: _emailController,
                      enabled: !isLoading,
                      validator: AppValidation.validateEmail,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'test@example.com',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),

                    _buildLabel(context, "Password"),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: isObscure,
                      enabled: !isLoading,
                      validator: AppValidation.validatePassword,
                      decoration: InputDecoration(
                        hintText: "••••••••",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => ref
                              .read(passwordVisibilityProvider.notifier)
                              .toggle(),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    LoginButton(
                      isLoading: isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(authControllerProvider.notifier)
                              .login(
                                _emailController.text.trim(),
                                _passwordController.text,
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildBiometricSection(context, isLoading),
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: const [
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
              const SizedBox(height: AppSpacing.m),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }

  Widget _buildBiometricSection(BuildContext context, bool isLoading) {
    return Column(
      children: [
        Text("Or Login With", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.l),
        IconButton(
          onPressed: isLoading
              ? null
              : () => ref
                    .read(authControllerProvider.notifier)
                    .loginWithBiometrics(),
          icon: const Icon(
            Icons.fingerprint,
            color: AppColors.primary,
            size: 36,
          ),
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(AppSpacing.s),
            backgroundColor: AppColors.primary.withAlpha(25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
