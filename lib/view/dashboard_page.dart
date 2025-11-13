import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      floatingActionButton: const TDFab(
        theme: TDFabTheme.primary,
        text: 'Floating',
      ),
      body: Center(
        child: Text('Welcome to the Dashboard!'),
      ),
    );
  }
}
