import 'package:dish_dash/ui/component/Toolbar.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = "setting";

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            const Toolbar(title: "Setting"),
          ],
        ),
      )
    );
  }
}
