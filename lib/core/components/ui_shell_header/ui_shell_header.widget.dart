import 'package:flutter/material.dart';
import 'package:mwandu/core/components/icon/index.dart';
import 'package:mwandu/core/theme/variables.dart' hide Theme;

import 'ui_shell_header.props.dart';
import 'ui_shell_header.styles.dart';

/// Carbon-inspired application header with brand, navigation, and actions.
class CUiShellHeader extends StatelessWidget implements PreferredSizeWidget {
  const CUiShellHeader({super.key, required this.props});

  final CUiShellHeaderProps props;

  @override
  Size get preferredSize => Size.fromHeight(
    props.height ?? CUiShellHeaderStyles.height,
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final height = props.height ?? CUiShellHeaderStyles.height;

    return Material(
      color: tokens.background,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: tokens.borderSubtle00)),
        ),
        child: Row(
          children: [
            if (props.showMenuButton)
              _HeaderIconButton(
                label: 'Open navigation menu',
                icon: CIcons.menu,
                onPressed: props.onMenuPressed,
              ),
            _Brand(props: props),
            if (props.links.isNotEmpty) ...[
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final link in props.links)
                        _HeaderLink(link: link),
                    ],
                  ),
                ),
              ),
            ] else
              const Spacer(),
            for (final action in props.actions)
              _HeaderIconButton(
                label: action.label,
                icon: action.icon,
                onPressed: action.onPressed,
              ),
          ],
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.props});

  final CUiShellHeaderProps props;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: props.onTitlePressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CUiShellHeaderStyles.horizontalPadding,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (props.prefix case final prefix? when prefix.isNotEmpty) ...[
              Text(
                prefix,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
              const SizedBox(width: Spacing.v8px05remSpacing03),
            ],
            Text(
              props.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderLink extends StatelessWidget {
  const _HeaderLink({required this.link});

  final CUiShellHeaderLink link;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: link.onPressed,
      child: Container(
        height: CUiShellHeaderStyles.height,
        alignment: Alignment.center,
        padding: CUiShellHeaderStyles.linkPadding,
        decoration: BoxDecoration(
          border: link.isCurrent
              ? Border(bottom: BorderSide(color: tokens.linkPrimary, width: 2))
              : null,
        ),
        child: Text(
          link.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: link.isCurrent ? tokens.textPrimary : tokens.textSecondary,
            fontWeight: link.isCurrent ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SizedBox(
      width: CUiShellHeaderStyles.actionWidth,
      height: CUiShellHeaderStyles.height,
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: CUiShellHeaderStyles.iconSize,
          color: tokens.iconPrimary,
        ),
      ),
    );
  }
}
