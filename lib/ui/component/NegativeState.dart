import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NegativeState extends StatefulWidget {
  final String image;
  final String description;
  final VoidCallback onClick;
  final Widget? button;

  const NegativeState({
    super.key,
    required this.image,
    required this.description,
    required this.onClick,
    this.button
  });

  @override
  State<NegativeState> createState() => _NegativeStateState();
}

class _NegativeStateState extends State<NegativeState> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            widget.image,
            width: 140,
            height: 140,
          ),
          Text(
            widget.description,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: widget.button != null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: widget.onClick,
                  child: widget.button
              ),
            )
          ),
        ],
      ),
    );;
  }
}
