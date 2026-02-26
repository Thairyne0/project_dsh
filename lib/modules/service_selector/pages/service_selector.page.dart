import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../ui/cl_theme.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../utils/extension.util.dart';
import '../../../utils/providers/service_state.util.provider.dart';
import '../../dashboard/constants/dashboard_routes.constants.dart';
import '../../production/constants/production_routes.constants.dart';

class ServiceSelectorPage extends StatefulWidget {
  const ServiceSelectorPage({super.key});

  @override
  State<ServiceSelectorPage> createState() => _ServiceSelectorPageState();
}

class _ServiceSelectorPageState extends State<ServiceSelectorPage> {
  int? _hoveredIndex;

  static final _services = [
    _ServiceDef(
      type: ServiceType.vulcanobuono,
      title: 'Vulcano Buono',
      subtitle: 'Centro commerciale',
      icon: Icons.storefront_rounded,
      color: const Color(0xFF2563EB),
      gradientEnd: const Color(0xFF38BDF8),
    ),
    _ServiceDef(
      type: ServiceType.macchinari,
      title: 'Gestione Macchinari',
      subtitle: 'Produzione & OEE',
      icon: Icons.precision_manufacturing_rounded,
      color: const Color(0xFF7C3AED),
      gradientEnd: const Color(0xFFA78BFA),
    ),
    _ServiceDef(
      type: ServiceType.finanza,
      title: 'Gestione Finanziaria',
      subtitle: 'Budget & Costi',
      icon: Icons.account_balance_rounded,
      color: const Color(0xFF059669),
      gradientEnd: const Color(0xFF34D399),
    ),
  ];

  Future<void> _onSelect(ServiceType type) async {
    final serviceState = context.read<ServiceState>();
    await serviceState.select(type);
    if (mounted) {
      switch (type) {
        case ServiceType.macchinari:
          context.customGoNamed(ProductionRoutes.production.name);
          break;
        case ServiceType.vulcanobuono:
        case ServiceType.finanza:
        default:
          context.customGoNamed(DashboardRoutes.dashboard.name);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return Scaffold(
      backgroundColor: t.primaryBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 48 : 24,
            vertical: 48,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: t.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.apps_rounded, color: t.primary, size: 32),
              ),
              const SizedBox(height: 24),
              Text(
                'Scegli il servizio',
                style: t.heading3.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Seleziona l\'area di lavoro a cui vuoi accedere',
                style: t.bodyText.copyWith(color: t.secondaryText),
              ),
              const SizedBox(height: 48),
              // Cards
              isDesktop
                  ? _buildDesktopCards(t)
                  : _buildMobileCards(t),
              const SizedBox(height: 48),
              // Footer
              Text(
                'Puoi cambiare servizio in qualsiasi momento dal menu laterale',
                style: t.smallLabel,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Desktop: rettangoli verticali affiancati con hover expand ──
  Widget _buildDesktopCards(CLTheme t) {
    return SizedBox(
      height: 340,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_services.length, (i) {
          final s = _services[i];
          final isHovered = _hoveredIndex == i;
          return Padding(
            padding: EdgeInsets.only(left: i > 0 ? 20 : 0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _hoveredIndex = i),
              onExit: (_) => setState(() => _hoveredIndex = null),
              child: GestureDetector(
                onTap: () => _onSelect(s.type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  width: isHovered ? 280 : 180,
                  height: 340,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [s.color, s.gradientEnd],
                    ),
                    borderRadius: BorderRadius.circular(Sizes.borderRadius + 4),
                    boxShadow: [
                      BoxShadow(
                        color: s.color.withValues(alpha: isHovered ? 0.35 : 0.15),
                        blurRadius: isHovered ? 32 : 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // ── Icona grande di sfondo (overflow clippato) ──
                      Positioned(
                        right: isHovered ? -20 : -50,
                        bottom: -20,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 350),
                          opacity: isHovered ? 0.18 : 0.10,
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            scale: isHovered ? 1.0 : 0.85,
                            child: Icon(s.icon, size: 200, color: Colors.white),
                          ),
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
                              child: Icon(s.icon, color: Colors.white, size: 24),
                            ),
                            const Spacer(),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isHovered ? 20 : 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                              child: Text(s.title),
                            ),
                            const SizedBox(height: 6),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isHovered ? 1.0 : 0.0,
                              child: AnimatedSlide(
                                duration: const Duration(milliseconds: 300),
                                offset: isHovered ? Offset.zero : const Offset(0, 0.3),
                                child: Text(
                                  s.subtitle,
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
                              opacity: isHovered ? 1.0 : 0.0,
                              child: Row(
                                children: [
                                  Text(
                                    'Accedi',
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
            ),
          );
        }),
      ),
    );
  }

  // ── Mobile: griglia di card quadrate ──
  Widget _buildMobileCards(CLTheme t) {
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 480 ? 3 : 2;
      final spacing = 16.0;
      final cardSize = (c.maxWidth - spacing * (cols - 1)) / cols;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: WrapAlignment.center,
        children: _services.map((s) {
          return GestureDetector(
            onTap: () => _onSelect(s.type),
            child: Container(
              width: cardSize.clamp(0, 200),
              height: cardSize.clamp(0, 200),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [s.color, s.gradientEnd],
                ),
                borderRadius: BorderRadius.circular(Sizes.borderRadius + 4),
                boxShadow: [
                  BoxShadow(
                    color: s.color.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Icona sfondo
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Opacity(
                      opacity: 0.12,
                      child: Icon(s.icon, size: 140, color: Colors.white),
                    ),
                  ),
                  // Contenuto
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(s.icon, color: Colors.white, size: 20),
                        ),
                        const Spacer(),
                        Text(
                          s.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class _ServiceDef {
  final ServiceType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color gradientEnd;

  const _ServiceDef({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.gradientEnd,
  });
}

