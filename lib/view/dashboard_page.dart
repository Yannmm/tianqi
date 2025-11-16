import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _appBar(),

          _brief(),

          // C — LIST
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  title: Text("Item $index"),
                );
              },
              childCount: 50,
            ),
          )
        ],
      ),
    );
  }

  Widget _appBar() => SliverAppBar(
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
        pinned: true,
        backgroundColor: TDTheme.of(context).brandNormalColor,
      );

  Widget _brief() => SliverPersistentHeader(
        pinned: true,
        delegate: _ShrinkHeaderDelegate(
          minHeight: 0, // fully collapsed
          maxHeight: 400, // original height
          child: BriefView(),
        ),
      );
}

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
