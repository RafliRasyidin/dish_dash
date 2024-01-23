import 'package:flutter/material.dart';

class Toolbar extends StatelessWidget {
  final String title;

  const Toolbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        customBorder: const CircleBorder(),
        child: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: Text(title),
      titleSpacing: 0,
    );
  }
}
