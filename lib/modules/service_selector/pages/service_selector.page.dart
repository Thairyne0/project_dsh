import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../ui/cl_theme.dart';
import '../../../ui/widgets/cl_expandable_gradient_card.widget.dart';
import '../../../ui/widgets/cl_gradient_square_card.widget.dart';
import '../../../utils/extension.util.dart';
import '../../../utils/providers/service_state.util.provider.dart';
import '../../dashboard/constants/dashboard_routes.constants.dart';
import '../../production/constants/production_routes.constants.dart';

class ServiceSelectorPage extends StatelessWidget {
  const ServiceSelectorPage({super.key});


  static final _services = [
    _ServiceDef(
      type: ServiceType.vulcanobuono,
      title: 'Vulcano Buono',
      subtitle: 'Centro commerciale',
      icon: Icons.storefront_rounded,
      color: ServiceType.vulcanobuono.serviceColor,
      gradientEnd: ServiceType.vulcanobuono.serviceColorLight,
    ),
    _ServiceDef(
      type: ServiceType.macchinari,
      title: 'Gestione Macchinari',
      subtitle: 'Produzione & OEE',
      icon: Icons.precision_manufacturing_rounded,
      color: ServiceType.macchinari.serviceColor,
      gradientEnd: ServiceType.macchinari.serviceColorLight,
    ),
    _ServiceDef(
      type: ServiceType.finanza,
      title: 'Gestione Finanziaria',
      subtitle: 'Budget & Costi',
      icon: Icons.account_balance_rounded,
      color: ServiceType.finanza.serviceColor,
      gradientEnd: ServiceType.finanza.serviceColorLight,
    ),
  ];

  Future<void> _onSelect(BuildContext context, ServiceType type) async {
    final serviceState = context.read<ServiceState>();
    await serviceState.select(type);
    if (context.mounted) {
      switch (type) {
        case ServiceType.macchinari:
          context.customGoNamed(ProductionRoutes.production.name);
          break;
        case ServiceType.vulcanobuono:
        case ServiceType.finanza:
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
                  ? _buildDesktopCards(context)
                  : _buildMobileCards(context),
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
  Widget _buildDesktopCards(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_services.length, (i) {
          final s = _services[i];
          return Padding(
            padding: EdgeInsets.only(left: i > 0 ? 20 : 0),
            child: CLExpandableGradientCard(
              title: s.title,
              subtitle: s.subtitle,
              icon: s.icon,
              color: s.color,
              gradientEnd: s.gradientEnd,
              onTap: () => _onSelect(context, s.type),
            ),
          );
        }),
      ),
    );
  }

  // ── Mobile: griglia di card quadrate ──
  Widget _buildMobileCards(BuildContext context) {
    return LayoutBuilder(builder: (ctx, c) {
      final cols = c.maxWidth >= 480 ? 3 : 2;
      final spacing = 16.0;
      final cardSize =
          ((c.maxWidth - spacing * (cols - 1)) / cols).clamp(0.0, 200.0);

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: WrapAlignment.center,
        children: _services.map((s) {
          return CLGradientSquareCard(
            title: s.title,
            subtitle: s.subtitle,
            icon: s.icon,
            color: s.color,
            gradientEnd: s.gradientEnd,
            size: cardSize,
            onTap: () => _onSelect(context, s.type),
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

