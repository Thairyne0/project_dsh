import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../ui/cl_theme.dart';
import '../../ui/widgets/buttons/cl_button.widget.dart';
import '../../ui/widgets/buttons/cl_ghost_button.widget.dart';
import '../../ui/widgets/buttons/cl_soft_button.widget.dart';

class PageAction {
  bool isMain;
  bool isSecondary;
  String title;
  IconData? iconData;
  Future Function() onTap;
  final bool needConfirmation;
  final String? confirmationMessage;
  final Color? color;

  PageAction(
      {this.iconData,
        this.isMain = false,
        this.isSecondary = false,
        required this.title,
        this.needConfirmation = false,
        this.confirmationMessage,
        this.color,
        required this.onTap});

  Widget toWidget(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isDesktop
        ? isMain
        ? !isSecondary
        ? CLButton(
      backgroundColor: color??CLTheme.of(context).primary,
      iconData: iconData,
      onTap: onTap,
      text: title,
      context: context,
      confirmationMessage: confirmationMessage,
      needConfirmation: needConfirmation, iconAlignment: IconAlignment.start,
    )
        : CLSoftButton(
      onTap: onTap,
      text: title,
      context: context,
      iconData: iconData,
      confirmationMessage: confirmationMessage,
      needConfirmation: needConfirmation, color: color??CLTheme.of(context).danger, iconAlignment: IconAlignment.start,
    )
        : CLGhostButton(
        color: CLTheme.of(context).primaryText,
        text: title,
        iconData: iconData,
        onTap: () async {
          await onTap();
          Navigator.of(context).pop();
        },
        foregroundColor: CLTheme.of(context).secondaryBackground,
        context: context,
        confirmationMessage: confirmationMessage,
        needConfirmation: needConfirmation,
        iconAlignment: IconAlignment.start)
        : CLGhostButton(
        color: CLTheme.of(context).primaryText,
        text: title,
        iconData: iconData,
        foregroundColor: CLTheme.of(context).secondaryBackground,
        onTap: () async {
          await onTap();
          Navigator.of(context).pop();
        },
        context: context,
        confirmationMessage: confirmationMessage,
        needConfirmation: needConfirmation,
        iconAlignment: IconAlignment.start);
  }
}
