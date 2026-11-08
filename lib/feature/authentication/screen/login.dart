import 'package:flutter/material.dart';
import 'package:mwandu/core/theme/theme.dart';
import 'package:mwandu/feature/authentication/widgets/login_card.dart';

import '../../../core/shared/styles/variables/spacing.style.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tokens.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.v16px1remSpacing05,
              vertical: Spacing.v32px2remSpacing07,
            ),
            child: const LoginCard(),
          ),
        ),
      ),
    );
  }
}
