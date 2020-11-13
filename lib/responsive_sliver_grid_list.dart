import 'package:flutter/material.dart';

import 'responsive_grid_list_item.dart';

///
/// Widget which returns a Sliver which can be used inside of a CustomScrollView
///
class ResponsiveSliverGridList extends StatelessWidget {
  final double desiredItemWidth, minSpacing;
  final List<Widget> children;
  final bool squareCells;
  final MainAxisAlignment rowMainAxisAlignment;

  ResponsiveSliverGridList({
    this.desiredItemWidth,
    this.minSpacing,
    this.squareCells = false,
    this.children,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        if (children.length == 0)
          // Return an empty container inside of a SliverBoxAdapter
          return SliverToBoxAdapter(
            child: Container(),
          );

        double width = constraints.crossAxisExtent;

        double N = (width - minSpacing) / (desiredItemWidth + minSpacing);

        int n;
        double spacing, itemWidth;

        if (N % 1 == 0) {
          n = N.floor();
          spacing = minSpacing;
          itemWidth = desiredItemWidth;
        } else {
          n = N.floor();

          double dw =
              width - (n * (desiredItemWidth + minSpacing) + minSpacing);

          itemWidth = desiredItemWidth +
              (dw / n) * (desiredItemWidth / (desiredItemWidth + minSpacing));

          spacing = (width - itemWidth * n) / (n + 1);
        }

        // Return a sliver list with a SliverChildBuilderDelegate to allow
        // large lists without performance loss.
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (index % 2 == 1) {
                return SizedBox(
                  height: minSpacing,
                );
              }
              // Item
              var rowChildren = List<Widget>();
              index = index ~/ 2;
              for (int i = index * n; i < (index + 1) * n; i++) {
                if (i >= children.length) break;
                rowChildren.add(children[i]);
              }
              return ResponsiveGridListItem(
                mainAxisAlignment: this.rowMainAxisAlignment,
                itemWidth: itemWidth,
                spacing: spacing,
                squareCells: squareCells,
                children: rowChildren,
              );
            },
            childCount: (children.length / n).ceil() * 2 - 1,
          ),
        );
      },
    );
  }
}
