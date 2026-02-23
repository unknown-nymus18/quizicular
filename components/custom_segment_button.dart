import 'package:flutter/material.dart';

class CustomSegmentButton extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final List<String> options;
  final int initialSelectedIndex;
  final Function(int)? onSelectionChanged;

  const CustomSegmentButton({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.options,
    this.initialSelectedIndex = 0,
    this.onSelectionChanged,
  });

  @override
  State<CustomSegmentButton> createState() => _CustomSegmentButtonState();
}

class _CustomSegmentButtonState extends State<CustomSegmentButton> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex;
  }

  void _onSegmentTapped(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
      });
      // Call the external callback if provided
      widget.onSelectionChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: EdgeInsets.all(4),
      child: Row(
        children: [
          for (int i = 0; i < widget.options.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => _onSegmentTapped(i),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: selectedIndex == i
                        ? widget.foregroundColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selectedIndex == i
                            ? (widget.foregroundColor == Colors.white
                                  ? Colors.black
                                  : Colors.white)
                            : Colors.grey[600],
                      ),
                      child: Text(widget.options[i]),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
