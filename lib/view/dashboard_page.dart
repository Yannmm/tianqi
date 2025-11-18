import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'dart:math' as math;

import 'package:tianqi/view/ui_utility.dart';

class BriefView extends StatefulWidget {
  @override
  State<BriefView> createState() => _BriefViewState();
}

class _BriefViewState extends State<BriefView> {
  @override
  Widget build(BuildContext context) => Container(
        color: TDTheme.of(context).brandNormalColor,
        alignment: Alignment.center,
        child: Text(
          "B: Shrinkable Header",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      );
}

// -------------------------------
// CUSTOM SHRINKING HEADER
// -------------------------------

class _ShrinkHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _ShrinkHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double progress = shrinkOffset / (maxExtent - minExtent);

    return SizedBox.expand(
      child: Opacity(
        opacity: 1 - progress.clamp(0, 1),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_ShrinkHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}

/// Real working example

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // This is the fixed height for Widget B
  final double _widgetBHeight = 300.0;

  final double _listCornerRadius = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // WIDGET A: The AppBar
      appBar: _appBar(),
      // We set a background color for the whole page.
      // The list (Widget C) will have its own background color.
      backgroundColor: TDTheme.of(context).brandNormalColor,
      floatingActionButton: TDFab(
        theme: TDFabTheme.primary,
        text: 'Add Expense',
        onClick: _addExpense,
      ),
      body: CustomScrollView(
        slivers: [
          _brief(),
          // We create the rounded corner "sheet" effect using two slivers.
          _cap(),

          // 2. This is the actual list content.
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // The list items themselves are inside a Container
                // with the *same* background color. This makes the
                // rounded "cap" and the list appear as one continuous sheet.
                return Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                    ),
                    title: Text('List Item ${index + 1}'),
                    subtitle: const Text('This is the subtitle'),
                  ),
                );
              },
              // Add a large number of items to demonstrate scrolling
              childCount: 50,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() => AppBar(
        title: Container(
          child: Center(
            child: Text("BMW 320D",
                style: TextStyle(
                    color: TDTheme.of(context).fontWhColor1,
                    fontSize: TDTheme.of(context).fontHeadlineSmall?.size,
                    fontWeight:
                        TDTheme.of(context).fontHeadlineSmall?.fontWeight)),
          ),
        ),
        elevation: 0,
        backgroundColor: TDTheme.of(context).brandNormalColor,
      );

  Widget _brief() => SliverPersistentHeader(
        // The delegate builds the widget and defines its shrink behavior.
        delegate: _ShrinkHeaderDelegate(
          minHeight: 0, // fully collapsed
          maxHeight: 250, // original height
          child: BriefView(),
        ),
        // We don't pin it, so it can shrink completely to 0.
        pinned: false,
        floating: true,
      );

  Widget _cap() => SliverToBoxAdapter(
        child: Container(
          // This transform pulls the container "up" by 1 pixel,
          // overlapping the header and closing any anti-aliasing gap.
          transform: Matrix4.translationValues(0.0, 1.0, 0.0),
          // We add 1 pixel to the height to compensate for the transform
          // and ensure the rounded corner radius looks correct.
          height: _listCornerRadius + 1.0,
          decoration: BoxDecoration(
            color: Colors.white, // The list's background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_listCornerRadius),
              topRight: Radius.circular(_listCornerRadius),
            ),
          ),
        ),
      );

  void _addExpense() {
    // Navigator.of(context).push(
    //   TDSlidePopupRoute(
    //       isDismissible: false,
    //       slideTransitionFrom: SlideTransitionFrom.bottom,
    //       builder: (context) {
    //         return SizedBox(
    //           height: kGetModalSheetHeight1(context),
    //           child: TDPopupBottomDisplayPanel(
    //             // hideClose: true,
    //             title: 'Log Refuel',
    //             // closeColor: TDTheme.of(context).errorNormalColor,
    //             // closeClick: () => Navigator.maybePop(context),
    //             rightClick: () {
    //               TDToast.showText('确定', context: context);
    //               Navigator.maybePop(context);
    //             },
    //             child: Container(
    //               height: 200,
    //               color: Colors.green,
    //             ),
    //             // draggable: true,
    //             radius: 6,
    //           ),
    //         );
    //       }),
    // );

    // Navigator.of(context).push(
    //   TDSlidePopupRoute(
    //     slideTransitionFrom: SlideTransitionFrom.bottom,
    //     builder: (context) {
    //       return TDPopupBottomConfirmPanel(
    //         title: '标题文字',
    //         leftClick: () {
    //           Navigator.maybePop(context);
    //         },
    //         rightText: '',
    //         // rightText: "123",
    //         // rightClick: () {
    //         //   TDToast.showText('确定', context: context);
    //         //   Navigator.maybePop(context);
    //         // },
    //         child: Container(height: 200),
    //       );
    //     },
    //   ),
    // );

    Navigator.of(context).push(
      TDSlidePopupRoute(
          slideTransitionFrom: SlideTransitionFrom.bottom,
          builder: (context) {
            return TDPopupBottomDisplayPanel(
              title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
              closeColor: TDTheme.of(context).errorNormalColor,
              closeClick: () => Navigator.maybePop(context),
              child: Container(height: 200),
            );
          }),
    );
  }
}

// This custom delegate is the "magic" that makes Widget B shrink.
class WidgetBDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Color backgroundColor;

  WidgetBDelegate({
    required this.height,
    required this.backgroundColor,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Calculate the current height of the widget as it shrinks
    // math.max ensures the height never goes below 0.
    final double currentHeight = math.max(0, height - shrinkOffset);

    // Calculate the opacity of the content.
    // It fades out as it shrinks.
    // (currentHeight / height) goes from 1.0 to 0.0
    final double opacity = (currentHeight / height).clamp(0.0, 1.0);

    return Container(
      // The height of this container shrinks from [height] to [minExtent] (0.0)
      height: currentHeight,
      color: backgroundColor,
      // We use ClipRect to prevent the content from overflowing
      // as the container shrinks.
      child: ClipRect(
        child: Opacity(
          opacity: opacity,
          child: Center(
            child: Text(
              'Widget B',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // This is the maximum height Widget B can have.
  double get maxExtent => height;

  @override
  // This is the minimum height Widget B will shrink to.
  // We set it to 0.0 so it disappears completely.
  double get minExtent => 0.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // This allows the delegate to rebuild if its properties change.
    return oldDelegate is! WidgetBDelegate ||
        oldDelegate.height != height ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

void _showQuarterModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    // Prevent tapping the scrim to dismiss
    isDismissible: false,
    // Prevent dragging down to dismiss
    enableDrag: false,
    // Makes the modal's background transparent so we control corner rounding
    backgroundColor: Colors.transparent,
    // Dimmed background color
    barrierColor: Colors.black54,
    builder: (context) {
      final height = MediaQuery.of(context).size.height * 0.75;
      return WillPopScope(
        // Prevent system back button from closing the sheet
        onWillPop: () async => false,
        child: Container(
          height: height,
          // The rounding and background color are applied here
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // Top row with close button on the right
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 48), // placeholder to keep X right-aligned
                      const Expanded(child: SizedBox()), // center space
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ),

                // Divider to separate header from content (optional)
                const Divider(height: 1),

                // Contents
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        20,
                        (i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text('Sheet item ${i + 1}'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
