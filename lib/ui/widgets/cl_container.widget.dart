import 'package:flutter/material.dart';
import '../cl_theme.dart';
import '../layout/constants/sizes.constant.dart';
import 'buttons/cl_ghost_button.widget.dart';

class CLContainer extends StatelessWidget {
  const CLContainer({
    super.key,
    required this.child,
    this.title,
    this.showShadow = false,
    this.customHeader,
    this.contentPadding,
    this.contentMargin,
    this.height,
    this.width,
    this.backgroundColor,
    this.constraints,
    this.borderRadius,
    this.actionTitle,
    this.titleWidget,
    this.actionWidget,
    this.onActionTap,
    this.glassmorphism = true,
    this.showBorder = true,
  });

  final Widget child;
  final String? title;
  final bool showShadow;
  final Widget? customHeader;
  final EdgeInsets? contentPadding;
  final EdgeInsets? contentMargin;
  final double? height;
  final double? width;

  final Color? backgroundColor;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;
  final Function()? onActionTap;
  final String? actionTitle;
  final Widget? titleWidget;
  final Widget? actionWidget;
  final bool showBorder;

  final bool glassmorphism;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      margin: contentMargin ?? EdgeInsets.zero,
      constraints: constraints,
      decoration: BoxDecoration(
        border: showBorder ? Border.all(color: CLTheme.of(context).borderColor, width: 1) : null,
        color: backgroundColor ?? CLTheme.of(context).secondaryBackground,
        borderRadius: borderRadius ?? BorderRadius.circular(Sizes.borderRadius),
        boxShadow: showShadow ? [BoxShadow(color: CLTheme.of(context).secondaryText.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 2)] : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || titleWidget != null) ...[
            Container(
              decoration:
                  customHeader == null
                      ? BoxDecoration(border: Border(bottom: BorderSide(color: CLTheme.of(context).borderColor, width: 1)))
                      : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.padding, vertical: Sizes.verticalPadding),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: titleWidget != null ? titleWidget! : Text(title!, style: CLTheme.of(context).bodyLabel)),
                    if (actionTitle != null && onActionTap != null && actionWidget == null)
                      SizedBox(height: 20, child: CLGhostButton.primary(text: actionTitle!, onTap: onActionTap!, context: context)),
                    if (actionWidget != null) actionWidget!,
                  ],
                ),
              ),
            ),
          ],
          customHeader ?? SizedBox.shrink(),
          Flexible(child: Padding(padding: contentPadding ?? EdgeInsets.zero, child: child)),
        ],
      ),
    );
  }
}
