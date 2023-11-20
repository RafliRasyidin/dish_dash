import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/assets.dart';

//ignore: must_be_immutable
class SearchBox extends StatefulWidget {
  String text = "";
  String? hint = "";
  ValueChanged<String> onTextChange;
  bool enabled = true;
  bool autoFocus = false;

  SearchBox({
    super.key,
    required this.text,
    required this.hint,
    required this.onTextChange,
    this.enabled = true,
    this.autoFocus = false
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final clearIcon = widget.text.isNotEmpty ? Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        child: Icon(
          Icons.clear,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 16,
        ),
        onTap: () {
          setState(() {
            _controller.clear();
            widget.onTextChange(_controller.text);
            widget.text = _controller.text;
          });
        },
      ),
    ) : null;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).colorScheme.surfaceVariant
      ),
      padding: const EdgeInsets.only(left: 16),
      child: TextField(
        controller: _controller,
        autofocus: widget.autoFocus,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SvgPicture.asset(
              Assets.assetsIcSearch,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onBackground,
                  BlendMode.srcIn
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            maxWidth: 24,
            maxHeight: 24
          ),
          hintText: widget.hint,
          border: InputBorder.none,
          suffixIcon: clearIcon,
          suffixIconConstraints: const BoxConstraints(
              maxWidth: 24,
              maxHeight: 24
          ),
        ),
        onChanged: widget.onTextChange,
        enabled: widget.enabled,
      ),
    );
  }

  @override
  void initState() {
    _controller.text = widget.text;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
