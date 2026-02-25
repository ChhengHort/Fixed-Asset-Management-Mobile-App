import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AssetSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String? initialValue;
  final String hint;

  const AssetSearchBar({
    super.key,
    required this.onChanged,
    this.onClear,
    this.initialValue,
    this.hint = 'Search',
  });

  @override
  State<AssetSearchBar> createState() => _AssetSearchBarState();
}

class _AssetSearchBarState extends State<AssetSearchBar> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _hasText = widget.initialValue?.isNotEmpty ?? false;
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Input
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                suffixIcon: _hasText
                    ? IconButton(
                        icon: Icon(Icons.close,
                            size: 18, color: Colors.grey.shade400),
                        onPressed: () {
                          _controller.clear();
                          widget.onClear?.call();
                          widget.onChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Search Button
        GestureDetector(
          onTap: () => widget.onChanged(_controller.text),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.darkGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }
}
