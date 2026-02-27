import 'package:flutter/material.dart';

import '../cl_theme.dart';
import '../layout/constants/sizes.constant.dart';
import 'cl_container.widget.dart';

class StatsWidget extends StatefulWidget {
  final Color color;
  final String label;
  final String body;
  final Function()? onTap;
  final IconData icon;

  const StatsWidget({super.key, required this.label, required this.body, required this.icon, required this.color, required this.onTap});

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.translucent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
              color: CLTheme.of(context).secondaryBackground,
              border: Border.all(
                color: _isHovered
                    ? widget.color.withValues(alpha: 0.6)
                    : CLTheme.of(context).borderColor,
                width: 1.5,
              ),
            ),
            child: CLContainer(
              showShadow: false,
              showBorder: false,
              contentPadding: EdgeInsets.all(Sizes.padding),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.color.withValues(alpha: 0.1),
                          ),
                          child: CircleAvatar(
                            radius: Sizes.padding * 1.5,
                            backgroundColor: Colors.transparent,
                            child: Icon(widget.icon, color: widget.color, size: Sizes.medium),
                          ),
                        ),
                        SizedBox(height: Sizes.padding),
                        Text(
                          widget.body,
                          style: CLTheme.of(context).heading2.override(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Sizes.padding),
                        Text(
                          widget.label,
                          style: CLTheme.of(context).bodyLabel,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
