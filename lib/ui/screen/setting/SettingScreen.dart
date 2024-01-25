import 'package:dish_dash/data/local/preferences/AppPreferences.dart';
import 'package:dish_dash/di/Locator.dart';
import 'package:dish_dash/ui/component/Toolbar.dart';
import 'package:dish_dash/ui/screen/setting/SettingViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = "setting";

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late SettingViewModel _viewModel;

  @override
  void initState() {
    _viewModel = SettingViewModel(locator<AppPreferencesImpl>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            const Toolbar(title: "Setting"),
            ChangeNotifierProvider(
              create: (_) => _viewModel,
              child: Consumer<SettingViewModel>(
                builder: (context, vm, _) {
                  return _buildReminder();
                },
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _buildReminder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enable Notification",
                  style: Theme.of(context).textTheme.titleMedium
                ),
                Text(
                  "Show recommended restaurant for your lunch",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline
                  )
                ),
              ],
            )
          ),
          Switch(
            value: _viewModel.isActive,
            onChanged: (isActive) {
              _viewModel.setRemainder(isActive);
              _viewModel.getReminder();
            },
          )
        ],
      ),
    );
  }
}
