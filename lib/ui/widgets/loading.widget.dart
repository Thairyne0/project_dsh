import 'package:project_dsh/ui/cl_theme.dart';
import 'package:project_dsh/ui/widgets/cl_shimmer.widget.dart';
import 'package:flutter/material.dart';
import 'package:project_dsh/ui/layout/constants/sizes.constant.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: Sizes.headerOffset,
        left: Sizes.padding,
        right: Sizes.padding,
        bottom: Sizes.padding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          Row(
            children: [
              CLShimmer(width: 180, height: 28, borderRadius: 6),
              const Spacer(),
              CLShimmer(width: 100, height: 36, borderRadius: Sizes.borderRadius),
            ],
          ),
          const SizedBox(height: Sizes.padding * 1.5),
          // Stats row
          Row(
            children: List.generate(3, (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 2 ? Sizes.padding : 0),
                padding: const EdgeInsets.all(Sizes.padding),
                decoration: BoxDecoration(
                  color: t.secondaryBackground,
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  border: Border.all(color: t.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CLShimmer(width: 80, height: 14, borderRadius: 4),
                    const SizedBox(height: 10),
                    CLShimmer(width: 120, height: 24, borderRadius: 4),
                  ],
                ),
              ),
            )),
          ),
          const SizedBox(height: Sizes.padding * 1.5),
          // Card / table skeleton
          Container(
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
              border: Border.all(color: t.borderColor),
            ),
            child: Column(
              children: [
                // Table header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.padding,
                    vertical: Sizes.verticalPadding,
                  ),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: t.borderColor)),
                  ),
                  child: Row(
                    children: List.generate(4, (i) => Expanded(
                      child: CLShimmer(
                        width: double.infinity,
                        height: 14,
                        borderRadius: 4,
                        margin: EdgeInsets.only(right: i < 3 ? Sizes.padding : 0),
                      ),
                    )),
                  ),
                ),
                // Table rows
                CLShimmerTableRows(
                  rowCount: 6,
                  columnsCount: 4,
                  rowHeight: 52,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
