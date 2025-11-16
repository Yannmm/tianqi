import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tianqi/view/dashboard_page.dart';
import 'package:tianqi/view/expense_page.dart';
import 'package:tianqi/view/more_page.dart';
import 'package:tianqi/view/refuel_page.dart';

enum HomeTab { dashboard, refuel, expenses, more }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _tab = BehaviorSubject<HomeTab>.seeded(HomeTab.dashboard);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _tab,
        builder: (context, snapshot) => !snapshot.hasData
            ? const SizedBox.shrink()
            : switch (snapshot.data!) {
                HomeTab.dashboard => const DashboardPage(),
                HomeTab.expenses => ExpensePage(),
                HomeTab.more => MorePage(),
                HomeTab.refuel => RefuelPage()
              },
      ),
      bottomNavigationBar: _tabBar(),
    );
  }

  Widget _tabBar() {
    TDBottomTabBarTabConfig tab(String text, IconData selectedIcon,
            IconData unselectedIcon, VoidCallback onTap) =>
        TDBottomTabBarTabConfig(
          tabText: text,
          selectedIcon: Icon(
            selectedIcon,
            size: 20,
            color: TDTheme.of(context).brandNormalColor,
          ),
          unselectedIcon: Icon(
            unselectedIcon,
            size: 20,
            color: TDTheme.of(context).brandNormalColor,
          ),
          onTap: onTap,
        );

    return TDBottomTabBar(
      TDBottomTabBarBasicType.iconText,
      useVerticalDivider: false,
      navigationTabs: [
        tab(
          'Dashboard',
          TDIcons.dashboard_filled,
          TDIcons.dashboard,
          () => _tab.add(HomeTab.dashboard),
        ),
        tab(
          'Refuel',
          TDIcons.filter_1_filled,
          TDIcons.filter_1,
          () => _tab.add(HomeTab.refuel),
        ),
        tab(
          'Expenses',
          TDIcons.saving_pot_filled,
          TDIcons.saving_pot,
          () => _tab.add(HomeTab.expenses),
        ),
        tab(
          'More',
          TDIcons.setting_filled,
          TDIcons.setting,
          () => _tab.add(HomeTab.more),
        ),
      ],
    );
  }
}
