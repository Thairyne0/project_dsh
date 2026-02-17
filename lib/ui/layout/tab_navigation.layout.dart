import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/providers/tabs.util.provider.dart';
import '../cl_theme.dart';

/// Widget per la tab bar stile IDE (come VS Code / Android Studio)
/// Mostra i tab delle pagine aperte con possibilità di chiuderli
class IdeTabBar extends StatelessWidget {
  final double height;

  const IdeTabBar({
    super.key,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TabsState>(
      builder: (context, tabsState, child) {
        if (tabsState.tabs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: CLTheme.of(context).secondaryBackground,
            border: Border(
              bottom: BorderSide(
                color: CLTheme.of(context).alternate,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Lista dei tab scrollabile
              Expanded(
                child: ReorderableListView.builder(
                  scrollDirection: Axis.horizontal,
                  buildDefaultDragHandles: false,
                  itemCount: tabsState.tabs.length,
                  onReorder: (oldIndex, newIndex) {
                    tabsState.reorderTab(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final tab = tabsState.tabs[index];
                    final isActive = tab.id == tabsState.activeTabId;

                    return ReorderableDragStartListener(
                      key: ValueKey(tab.id),
                      index: index,
                      child: _TabItem(
                        tab: tab,
                        isActive: isActive,
                        onTap: () => _onTabTap(context, tabsState, tab),
                        onClose: tab.canClose
                            ? () => _onTabClose(context, tabsState, tab)
                            : null,
                        onMiddleClick: tab.canClose
                            ? () => _onTabClose(context, tabsState, tab)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              // Bottone per menu azioni (opzionale)
              _TabActions(tabsState: tabsState),
            ],
          ),
        );
      },
    );
  }

  void _onTabTap(BuildContext context, TabsState tabsState, OpenTab tab) {
    tabsState.setActiveTab(tab.id);
    context.go(tab.path);
  }

  void _onTabClose(BuildContext context, TabsState tabsState, OpenTab tab) {
    final wasActive = tab.id == tabsState.activeTabId;
    tabsState.closeTab(tab.id);

    // Se il tab chiuso era attivo, naviga al nuovo tab attivo
    if (wasActive && tabsState.activeTab != null) {
      context.go(tabsState.activeTab!.path);
    }
  }
}

/// Singolo tab item
class _TabItem extends StatefulWidget {
  final OpenTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onClose;
  final VoidCallback? onMiddleClick;

  const _TabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
    this.onClose,
    this.onMiddleClick,
  });

  @override
  State<_TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<_TabItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        // Middle click per chiudere
        if (event.buttons == 4 && widget.onMiddleClick != null) {
          widget.onMiddleClick!();
        }
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          onSecondaryTapDown: (details) {
            _showContextMenu(context, details.globalPosition);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            constraints: const BoxConstraints(
              minWidth: 120,
              maxWidth: 200,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? CLTheme.of(context).primaryBackground
                  : _isHovered
                      ? CLTheme.of(context).primaryBackground.withValues(alpha: 0.5)
                      : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: widget.isActive
                      ? CLTheme.of(context).primary
                      : Colors.transparent,
                  width: 2,
                ),
                right: BorderSide(
                  color: CLTheme.of(context).alternate,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icona (opzionale)
                if (widget.tab.icon != null) ...[
                  Icon(
                    widget.tab.icon,
                    size: 16,
                    color: widget.isActive
                        ? CLTheme.of(context).primaryText
                        : CLTheme.of(context).secondaryText,
                  ),
                  const SizedBox(width: 8),
                ],
                // Titolo
                Expanded(
                  child: Text(
                    widget.tab.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: widget.isActive ? FontWeight.w500 : FontWeight.normal,
                      color: widget.isActive
                          ? CLTheme.of(context).primaryText
                          : CLTheme.of(context).secondaryText,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                // Bottone chiudi
                if (widget.onClose != null) ...[
                  const SizedBox(width: 4),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: _isHovered || widget.isActive ? 1.0 : 0.0,
                    child: InkWell(
                      onTap: widget.onClose,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: CLTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset position) {
    final tabsState = Provider.of<TabsState>(context, listen: false);

    showMenu<dynamic>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: <PopupMenuEntry<dynamic>>[
        if (widget.onClose != null)
          PopupMenuItem<dynamic>(
            child: const Row(
              children: [
                Icon(Icons.close, size: 18),
                SizedBox(width: 8),
                Text('Chiudi'),
              ],
            ),
            onTap: widget.onClose,
          ),
        PopupMenuItem<dynamic>(
          child: const Row(
            children: [
              Icon(Icons.close_fullscreen, size: 18),
              SizedBox(width: 8),
              Text('Chiudi altri'),
            ],
          ),
          onTap: () => tabsState.closeOtherTabs(widget.tab.id),
        ),
        PopupMenuItem<dynamic>(
          child: const Row(
            children: [
              Icon(Icons.keyboard_double_arrow_right, size: 18),
              SizedBox(width: 8),
              Text('Chiudi tab a destra'),
            ],
          ),
          onTap: () => tabsState.closeTabsToRight(widget.tab.id),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<dynamic>(
          child: const Row(
            children: [
              Icon(Icons.close_outlined, size: 18),
              SizedBox(width: 8),
              Text('Chiudi tutti'),
            ],
          ),
          onTap: () => tabsState.closeAllTabs(),
        ),
      ],
    );
  }
}

/// Bottone azioni tab
class _TabActions extends StatelessWidget {
  final TabsState tabsState;

  const _TabActions({required this.tabsState});

  @override
  Widget build(BuildContext context) {
    if (tabsState.tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        size: 20,
        color: CLTheme.of(context).secondaryText,
      ),
      tooltip: 'Azioni tab',
      onSelected: (value) {
        switch (value) {
          case 'close_all':
            tabsState.closeAllTabs();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'close_all',
          child: Row(
            children: [
              Icon(Icons.close_outlined, size: 18),
              SizedBox(width: 8),
              Text('Chiudi tutti i tab'),
            ],
          ),
        ),
      ],
    );
  }
}










