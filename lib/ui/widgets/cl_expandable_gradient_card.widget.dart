import 'package:flutter/material.dart';
import '../layout/constants/sizes.constant.dart';

/// Card rettangolare verticale con effetto hover-expand per desktop.
///
/// Quando il mouse entra nella card, questa si allarga mostrando
/// il sottotitolo e il pulsante "Accedi".
class CLExpandableGradientCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color gradientEnd;
  final VoidCallback onTap;
  final double collapsedWidth;
  final double expandedWidth;
  final double height;
  final String actionLabel;

  const CLExpandableGradientCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.gradientEnd,
    required this.onTap,
    this.collapsedWidth = 180,
    this.expandedWidth = 280,
    this.height = 340,
    this.actionLabel = 'Accedi',
  });

  @override
  State<CLExpandableGradientCard> createState() =>
      _CLExpandableGradientCardState();
}

class _CLExpandableGradientCardState extends State<CLExpandableGradientCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          width: _isHovered ? widget.expandedWidth : widget.collapsedWidth,
          height: widget.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.color, widget.gradientEnd],
            ),
            borderRadius: BorderRadius.circular(Sizes.borderRadius + 4),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // ── Icona grande di sfondo (overflow clippato) ──
              Positioned(
                right: _isHovered ? -20 : -50,
                bottom: -20,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 350),
                  opacity: _isHovered ? 0.18 : 0.10,
                  child: Icon(widget.icon, size: 200, color: Colors.white),
                ),
              ),
              // ── Contenuto ──
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Icon(widget.icon, color: Colors.white, size: 24),
                    ),
                    const Spacer(),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _isHovered ? 20 : 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                      child: Text(widget.title),
                    ),
                    const SizedBox(height: 6),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _isHovered ? 1.0 : 0.0,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        offset: _isHovered
                            ? Offset.zero
                            : const Offset(0, 0.3),
                        child: Text(
                          widget.subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _isHovered ? 1.0 : 0.0,
                      child: Row(
                        children: [
                          Text(
                            widget.actionLabel,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

