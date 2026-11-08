import 'package:flutter/material.dart';
import 'package:mwandu/core/shared/styles/variables/breakpoints.style.dart';
import 'package:mwandu/core/shared/styles/variables/spacing.style.dart';
import 'package:mwandu/core/theme/app_theme.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _formKey = GlobalKey<FormState>();

  void _continue() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final availableWidth = screenWidth - Spacing.v16px1remSpacing05 * 2;
    final cardWidth = availableWidth < BreakpointMD672px.modalMaxWidth
        ? availableWidth
        : BreakpointMD672px.modalMaxWidth;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(Spacing.v32px2remSpacing07),
      decoration: BoxDecoration(
        color: tokens.layer01,
        border: Border.all(
          color: tokens.borderSubtle01,
          width: Spacing.v2px0125remSpacing01,
        ),
        borderRadius: BorderRadius.zero,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Log in',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.v8px05remSpacing03),
            Text(
              'Enter your details to continue to your account.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: tokens.textSecondary,
              ),
            ),
            const SizedBox(height: Spacing.v32px2remSpacing07),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Email address',
                hintText: 'name@example.com',
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty || !email.contains('@')) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: Spacing.v24px15remSpacing06),
            TextFormField(
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your password';
                }
                return null;
              },
              onFieldSubmitted: (_) => _continue(),
            ),
            const SizedBox(height: Spacing.v32px2remSpacing07),
            SizedBox(
              height: Spacing.v48px3remSpacing09,
              child: ElevatedButton(
                onPressed: _continue,
                child: const Text('Continue'),
              ),
            ),
            const SizedBox(height: Spacing.v16px1remSpacing05),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Don’t have an account?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
