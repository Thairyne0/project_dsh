part of 'paged_datatable.dart';

class _PagedDataTableFooter<TKey extends Comparable, TResultId extends Comparable, TResult extends Object> extends StatelessWidget {
  final PagedDataTableThemeData themeData;

  const _PagedDataTableFooter({required this.themeData});

  @override
  Widget build(BuildContext context) {
    return Consumer<_PagedDataTableState<TKey, TResultId, TResult>>(
      builder: (context, state, child) {
        final textStyle = themeData.footerTextStyle ?? CLTheme.of(context).bodyText;

        Widget child = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(height: 0, thickness: 1, color: CLTheme.of(context).borderColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: Sizes.padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Elementi per pagina
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Righe:',
                        style: textStyle.copyWith(
                          fontSize: 12,
                          color: CLTheme.of(context).secondaryText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...(themeData.configuration.pageSizes ?? [5, 25, 50, 100]).map((pageSize) {
                        final isSelected = state._pageSize == pageSize;
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                if (!isSelected) state.setPageSize(pageSize);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? CLTheme.of(context).primary
                                      : CLTheme.of(context).primaryBackground,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? CLTheme.of(context).primary
                                        : CLTheme.of(context).borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  pageSize.toString(),
                                  style: textStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : CLTheme.of(context).primaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(width: 12),
                      Text(
                        '${state.totalElement} totali',
                        style: textStyle.copyWith(
                          fontSize: 12,
                          color: CLTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),

                  // Navigazione pagine
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FooterNavButton(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft01,
                          size: 16,
                          color: (state.hasPreviousPage && state.tableState != _TableState.loading)
                              ? CLTheme.of(context).primaryText
                              : CLTheme.of(context).secondaryText,
                        ),
                        enabled: state.hasPreviousPage && state.tableState != _TableState.loading,
                        onTap: state.hasPreviousPage && state.tableState != _TableState.loading ? state.previousPage : () {},
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: CLTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: CLTheme.of(context).borderColor),
                        ),
                        child: Text(
                          '${state.currentPage + 1}',
                          style: textStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: CLTheme.of(context).primaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _FooterNavButton(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowRight01,
                          size: 16,
                          color: (state.hasNextPage && state.tableState != _TableState.loading)
                              ? CLTheme.of(context).primaryText
                              : CLTheme.of(context).secondaryText,
                        ),
                        enabled: state.hasNextPage && state.tableState != _TableState.loading,
                        onTap: state.hasNextPage && state.tableState != _TableState.loading ? state.nextPage : () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

        if (themeData.headerBackgroundColor != null) {
          child = DecoratedBox(decoration: BoxDecoration(color: themeData.headerBackgroundColor), child: child);
        }

        if (themeData.footerTextStyle != null) {
          child = DefaultTextStyle(style: themeData.footerTextStyle!, child: child);
        }

        return child;
      },
    );
  }
}

class _FooterNavButton extends StatefulWidget {
  final Widget icon;
  final bool enabled;
  final VoidCallback onTap;

  const _FooterNavButton({required this.icon, required this.enabled, required this.onTap});

  @override
  State<_FooterNavButton> createState() => _FooterNavButtonState();
}

class _FooterNavButtonState extends State<_FooterNavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _isHovered && widget.enabled
                ? CLTheme.of(context).alternate.withValues(alpha: 0.6)
                : CLTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: CLTheme.of(context).borderColor),
          ),
          child: Center(child: widget.icon),
        ),
      ),
    );
  }
}
