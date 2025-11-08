import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TDesign Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TDTheme.of(context).brandNormalColor,
        title: TDText(
          'TDesign HomePage',
          textColor: Colors.white,
          font: Font(size: 18, lineHeight: 26),
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              TDToast.showText('Search clicked', context: context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              TDToast.showText('Notifications clicked', context: context);
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: TDBottomTabBar(
        TDBottomTabBarBasicType.text,
        useVerticalDivider: false,
        navigationTabs: [
          TDBottomTabBarTabConfig(
            tabText: 'Home',
            selectedIcon: const Icon(Icons.home),
            unselectedIcon: const Icon(Icons.home_outlined),
            onTap: () {},
          ),
          TDBottomTabBarTabConfig(
            tabText: 'Discover',
            selectedIcon: const Icon(Icons.explore),
            unselectedIcon: const Icon(Icons.explore_outlined),
            onTap: () {},
          ),
          TDBottomTabBarTabConfig(
            tabText: 'Messages',
            selectedIcon: const Icon(Icons.message),
            unselectedIcon: const Icon(Icons.message_outlined),
            onTap: () {},
          ),
          TDBottomTabBarTabConfig(
            tabText: 'Profile',
            selectedIcon: const Icon(Icons.person),
            unselectedIcon: const Icon(Icons.person_outlined),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Section
          _buildBannerSection(),
          const SizedBox(height: 16),

          // Quick Actions
          _buildQuickActions(),
          const SizedBox(height: 16),

          // Featured Content
          _buildFeaturedSection(),
          const SizedBox(height: 16),

          // Button Examples
          _buildButtonSection(),
          const SizedBox(height: 16),

          // Tags Section
          _buildTagsSection(),
          const SizedBox(height: 16),

          // List Section
          _buildListSection(),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return SizedBox(
      height: 200,
      child: PageView(
        children: [
          _buildBannerItem(Colors.blue.shade300, 'Welcome to TDesign'),
          _buildBannerItem(Colors.purple.shade300, 'Beautiful UI Components'),
          _buildBannerItem(Colors.green.shade300, 'Build Amazing Apps'),
        ],
      ),
    );
  }

  Widget _buildBannerItem(Color color, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TDText(
          text,
          textColor: Colors.white,
          font: Font(size: 24, lineHeight: 32),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDText(
            'Quick Actions',
            font: Font(size: 18, lineHeight: 26),
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionItem(Icons.qr_code_scanner, 'Scan'),
              _buildActionItem(Icons.payment, 'Pay'),
              _buildActionItem(Icons.card_giftcard, 'Rewards'),
              _buildActionItem(Icons.more_horiz, 'More'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        TDToast.showText('$label clicked', context: context);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: TDTheme.of(context).brandLightColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 30,
              color: TDTheme.of(context).brandNormalColor,
            ),
          ),
          const SizedBox(height: 8),
          TDText(
            label,
            font: Font(size: 14, lineHeight: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDText(
            'Featured',
            font: Font(size: 18, lineHeight: 26),
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          TDCellGroup(
            cells: [
              TDCell(
                title: 'Special Offer',
                note: 'Limited time only',
                leftIcon: Icons.local_offer,
                arrow: true,
                onClick: (cell) {
                  TDToast.showSuccess('Offer clicked', context: context);
                },
              ),
              TDCell(
                title: 'New Arrivals',
                note: 'Check out latest items',
                leftIcon: Icons.new_releases,
                arrow: true,
                onClick: (cell) {
                  TDToast.showSuccess('New Arrivals clicked', context: context);
                },
              ),
              TDCell(
                title: 'Best Sellers',
                note: 'Most popular products',
                leftIcon: Icons.star,
                arrow: true,
                onClick: (cell) {
                  TDToast.showSuccess('Best Sellers clicked', context: context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDText(
            'Actions',
            font: Font(size: 18, lineHeight: 26),
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TDButton(
                  text: 'Primary',
                  type: TDButtonType.fill,
                  theme: TDButtonTheme.primary,
                  size: TDButtonSize.large,
                  onTap: () {
                    TDToast.showSuccess('Primary button clicked',
                        context: context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TDButton(
                  text: 'Outline',
                  type: TDButtonType.outline,
                  theme: TDButtonTheme.primary,
                  size: TDButtonSize.large,
                  onTap: () {
                    TDToast.showText('Outline button clicked',
                        context: context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TDButton(
                  text: 'Text Style',
                  type: TDButtonType.text,
                  theme: TDButtonTheme.primary,
                  size: TDButtonSize.large,
                  onTap: () {
                    TDToast.showSuccess('Text button clicked',
                        context: context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TDButton(
                  text: 'Ghost',
                  type: TDButtonType.ghost,
                  theme: TDButtonTheme.primary,
                  size: TDButtonSize.large,
                  onTap: () {
                    TDToast.showText('Ghost button clicked', context: context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDText(
            'Categories',
            font: Font(size: 18, lineHeight: 26),
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TDTag(
                'Technology',
                theme: TDTagTheme.primary,
                isOutline: false,
              ),
              TDTag(
                'Fashion',
                theme: TDTagTheme.success,
                isOutline: false,
              ),
              TDTag(
                'Food',
                theme: TDTagTheme.warning,
                isOutline: false,
              ),
              TDTag(
                'Travel',
                theme: TDTagTheme.danger,
                isOutline: false,
              ),
              TDTag(
                'Sports',
                theme: TDTagTheme.primary,
                isOutline: true,
              ),
              TDTag(
                'Music',
                theme: TDTagTheme.success,
                isOutline: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDText(
            'Settings',
            font: Font(size: 18, lineHeight: 26),
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          TDCellGroup(
            cells: [
              TDCell(
                title: 'Account',
                leftIcon: Icons.account_circle,
                arrow: true,
                onClick: (cell) {},
              ),
              TDCell(
                title: 'Privacy',
                leftIcon: Icons.privacy_tip,
                arrow: true,
                onClick: (cell) {},
              ),
              TDCell(
                title: 'Notifications',
                leftIcon: Icons.notifications,
                arrow: true,
                onClick: (cell) {
                  TDToast.showText('Notifications settings', context: context);
                },
              ),
              TDCell(
                title: 'Dark Mode',
                leftIcon: Icons.dark_mode,
                arrow: true,
                onClick: (cell) {
                  TDToast.showText('Dark mode settings', context: context);
                },
              ),
              TDCell(
                title: 'Help & Support',
                leftIcon: Icons.help,
                arrow: true,
                onClick: (cell) {},
              ),
              TDCell(
                title: 'About',
                leftIcon: Icons.info,
                arrow: true,
                onClick: (cell) {},
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
