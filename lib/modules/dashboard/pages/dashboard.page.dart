import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:project_dsh/ui/layout/constants/sizes.constant.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/widgets/charts/cl_pie_chart.widget.dart';
import 'package:project_dsh/ui/widgets/stats.widget.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../ui/cl_theme.dart';
import '../../../ui/widgets/buttons/cl_action_text.widget.dart';
import '../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../ui/widgets/charts/cl_spline_area_chart.widget.dart';
import '../../../ui/widgets/cl_container.widget.dart';
import '../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../ui/widgets/cl_pill.widget.dart';
import '../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../ui/widgets/loading.widget.dart';
import '../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/providers/appstate.util.provider.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../../events/constants/event_routes.constant.dart';
import '../../events/models/event.model.dart';
import '../viewmodels/dashboard.viewmodel.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<DashboardViewModel>.reactive(
      viewModelBuilder: () => DashboardViewModel(context, VMType.list, null),
      onViewModelReady: (vm) async => await vm.initialize(),
      builder: (context, vm, child) {
        return vm.isBusy
            ? const LoadingWidget()
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(top: Sizes.headerOffset),
                    sliver: SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.padding * 1.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Section
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: Sizes.padding * 1.5,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dashboard',
                                    style: CLTheme.of(context).title.copyWith(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Panoramica generale del sistema',
                                    style: CLTheme.of(context).bodyText.copyWith(
                                      color: CLTheme.of(
                                        context,
                                      ).bodyText.color?.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Stats Cards
                            ResponsiveGrid(
                              showMargin: false,
                              gridSpacing: Sizes.padding,
                              children: [
                                ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 400),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: StatsWidget(
                                      label: "Utenti registrati",
                                      body: vm.dashboard.totalUsers.toString(),
                                      icon: Icons.person,
                                      color: CLTheme.of(context).primary,
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 500),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: StatsWidget(
                                      label: "Eventi",
                                      body: vm.dashboard.totalEvents.toString(),
                                      icon: Icons.calendar_month_rounded,
                                      color: CLTheme.of(context).warning,
                                      onTap: () {
                                        context.customGoNamed(
                                          EventRoutes.event.name,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 600),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: StatsWidget(
                                      label: "Promozioni",
                                      body: vm.dashboard.totalPromos.toString(),
                                      icon: Icons.discount,
                                      color: CLTheme.of(context).danger,
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 700),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: StatsWidget(
                                      label: "Tickets aperti",
                                      body: vm.dashboard.totalOpenTickets
                                          .toString(),
                                      icon: Icons.question_answer_rounded,
                                      color: CLTheme.of(context).success,
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Sizes.padding * 2),
                            // Divider decorativo
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(
                                vertical: Sizes.padding,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    CLTheme.of(
                                      context,
                                    ).borderColor.withOpacity(0.0),
                                    CLTheme.of(context).borderColor,
                                    CLTheme.of(
                                      context,
                                    ).borderColor.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: Sizes.padding),
                            // Sezione Grafici
                            ResponsiveGrid(
                              showMargin: false,
                              gridSpacing: Sizes.padding,
                              children: [
                                ResponsiveGridItem(
                                  lg: 70,
                                  xs: 100,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 800),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: 0.95 + (0.05 * value),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: CLContainer(
                                      actionWidget: Container(
                                        height: 35,
                                        width: 115,
                                        child: DropdownButtonFormField2<DateTime>(
                                          isExpanded: true,
                                          value: vm.selectedDate,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: CLTheme.of(context).primary,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                Sizes.borderRadius,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: CLTheme.of(
                                                  context,
                                                ).borderColor,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                Sizes.borderRadius,
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.only(
                                              right: 8,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                Sizes.borderRadius,
                                              ),
                                            ),
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                              color: CLTheme.of(
                                                context,
                                              ).secondaryBackground,
                                              borderRadius: BorderRadius.circular(
                                                Sizes.borderRadius,
                                              ),
                                            ),
                                            elevation: 2,
                                          ),
                                          menuItemStyleData: MenuItemStyleData(),
                                          style: CLTheme.of(context).smallText,
                                          onChanged: (selectedYear) async {
                                            if (selectedYear != null) {
                                              setState(() {
                                                vm.selectedDate = selectedYear;
                                              });
                                              vm.userGraphData = [];
                                              vm.userGraphData = await vm
                                                  .fillGraph();
                                              setState(() {});
                                            }
                                          },
                                          items: vm.years
                                              .map(
                                                (year) => DropdownMenuItem(
                                              value: year,
                                              child: Text(
                                                DateFormat('yyyy').format(year),
                                                style: CLTheme.of(
                                                  context,
                                                ).smallText,
                                              ),
                                            ),
                                          )
                                              .toList(),
                                        ),
                                      ),
                                      height: 480,
                                      title: "Registrazioni",
                                      contentPadding: const EdgeInsets.all(
                                        Sizes.padding,
                                      ),
                                      child: CLSplineAreaChart(
                                        userChartData: vm.userGraphData,
                                      ),
                                    ),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 30,
                                  xs: 100,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 900),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Transform.scale(
                                        scale: 0.95 + (0.05 * value),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: CLContainer(
                                      contentPadding: EdgeInsets.zero,
                                      actionWidget: CLActionText(
                                        color: CLTheme.of(context).primary,
                                        text: 'Mostra tutti',
                                        onTap: () {},
                                        context: context,
                                      ),
                                      height: 480,
                                      title: "Utenti per città",
                                      child: CLPieChart(
                                        data: vm.dashboard.cityGraphData,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Sizes.padding * 2),
                            // Divider decorativo
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(
                                vertical: Sizes.padding,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    CLTheme.of(
                                      context,
                                    ).borderColor.withOpacity(0.0),
                                    CLTheme.of(context).borderColor,
                                    CLTheme.of(
                                      context,
                                    ).borderColor.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: Sizes.padding),
                            // Sezione Tabelle
                            ResponsiveGrid(
                              showMargin: false,
                              gridSpacing: Sizes.padding,
                              children: [
                                ResponsiveGridItem(
                                  lg: 50,
                                  xs: 100,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 1000),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 30 * (1 - value)),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: CLContainer(
                                      height:
                                      ResponsiveBreakpoints.of(
                                        context,
                                      ).isDesktop
                                          ? 700
                                          : null,
                                      actionWidget: CLActionText(
                                        color: CLTheme.of(context).primary,
                                        text: 'Mostra tutti',
                                        onTap: () {
                                          context.customGoNamed(
                                            EventRoutes.event.name,
                                          );
                                        },
                                        context: context,
                                      ),
                                      title: 'I prossimi 5 eventi',
                                      child: PagedDataTable<String, String, Event>(
                                        showBorder: false,
                                        rowsSelectable: false,
                                        showFooter: false,
                                        idGetter: (event) => event.id,
                                        controller:
                                        vm.eventDashboardTableController,
                                        fetchPage: vm.getAllEventDashboard,
                                        initialPage: "1",
                                        refreshListener: appState.refreshList,
                                        initialPageSize: 25,
                                        onItemTap: (item) {
                                          context.customGoNamed(
                                            EventRoutes.viewEvent.name,
                                            params: {"id": item.id},
                                            replacedRouteName: item.modelIdentifier,
                                          );
                                        },
                                        columns: [
                                          TableColumn(
                                            id: "title",
                                            title: const Text("Titolo"),
                                            sortable: false,
                                            cellBuilder: (item) => Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                CLMediaViewer(
                                                  medias: [
                                                    CLMedia(fileUrl: item.imageUrl),
                                                  ],
                                                  clMediaViewerMode:
                                                  CLMediaViewerMode.tableMode,
                                                  resourceName: item.title,
                                                ),
                                                SizedBox(width: Sizes.padding),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style: CLTheme.of(
                                                          context,
                                                        ).bodyText,
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                      Text(
                                                        "In evidenza? ${item.isHighlighted ? "Si" : "No"}",
                                                        style: CLTheme.of(
                                                          context,
                                                        ).smallLabel,
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            sizeFactor: .3,
                                            isMain: false,
                                          ),
                                          TableColumn(
                                            id: "startingAt",
                                            title: const Text("Inizio"),
                                            sortable: false,
                                            cellBuilder: (item) => Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  item.startingAtDate.split(" ")[0],
                                                  style: CLTheme.of(
                                                    context,
                                                  ).bodyText,
                                                ),
                                                Text(
                                                  item.startingAtDate.split(" ")[1],
                                                  style: CLTheme.of(
                                                    context,
                                                  ).smallLabel,
                                                ),
                                              ],
                                            ),
                                            sizeFactor: .25,
                                            isMain: false,
                                          ),
                                          TableColumn(
                                            id: "endingAt",
                                            title: const Text("Fine"),
                                            sortable: false,
                                            cellBuilder: (item) => Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  item.endingAtDate.split(" ")[0],
                                                  style: CLTheme.of(
                                                    context,
                                                  ).bodyText,
                                                ),
                                                Text(
                                                  item.endingAtDate.split(" ")[1],
                                                  style: CLTheme.of(
                                                    context,
                                                  ).smallLabel,
                                                ),
                                              ],
                                            ),
                                            sizeFactor: .25,
                                            isMain: false,
                                          ),
                                          TableColumn(
                                            id: "store:name",
                                            title: const Text("Store"),
                                            sortable: true,
                                            cellBuilder: (item) =>
                                                CLActionText.primary(
                                                  text: "",
                                                  onTap: () {},
                                                  context: context,
                                                ),
                                            sizeFactor: .20,
                                            isMain: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 50,
                                  xs: 100,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 1100),
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 30 * (1 - value)),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: CLContainer(
                                      actionWidget: CLActionText(
                                        color: CLTheme.of(context).primary,
                                        text: 'Mostra tutti',
                                        onTap: () {},
                                        context: context,
                                      ),
                                      height:
                                      ResponsiveBreakpoints.of(
                                        context,
                                      ).isDesktop
                                          ? 700
                                          : null,
                                      title: 'Monitoraggio dispositivi',
                                      child: Container(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Sizes.padding),
                          ],
                        ),
                      ),
                    ),
                  )
                ],

              );
      },
    );
  }
}

class UserPerMonth {
  final String month;
  final int users;

  UserPerMonth(this.month, this.users);
}
