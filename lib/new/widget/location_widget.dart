import 'package:flutter/material.dart';
import 'package:new_app/new/model/location.dart';
import 'package:new_app/new/widget/expanded_content_widget.dart';
import 'package:new_app/new/widget/image_widget.dart';
import 'dart:async';

class LocationWidget extends StatefulWidget {
  final Location location;

  const LocationWidget({
    required this.location,
    super.key,
  });

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  bool isExpanded = false;
  Timer? _expandTimer;
  Timer? _collapseTimer;

  @override
  void initState() {
    super.initState();
    _expandTimer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isExpanded = true;
      });

      // Collapse the widget after it's been expanded for 5 seconds
      _collapseTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          isExpanded = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _expandTimer?.cancel();
    _collapseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            bottom: isExpanded ? 40 : 100,
            width: isExpanded ? size.width * 0.78 : size.width * 0.7,
            height: isExpanded ? size.height * 0.6 : size.height * 0.5,
            child: ExpandedContentWidget(location: widget.location),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            bottom: isExpanded ? 150 : 100,
            child: GestureDetector(
              onPanUpdate: onPanUpdate,
              onTap: () {},
              child: ImageWidget(location: widget.location),
            ),
          ),
        ],
      ),
    );
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (details.delta.dy < 0) {
      setState(() {
        isExpanded = true;
      });
      _collapseTimer?.cancel(); // Cancel any existing collapse timer
      _collapseTimer = Timer(const Duration(seconds: 5), () {
        setState(() {
          isExpanded = false;
        });
      });
    } else if (details.delta.dy > 0) {
      setState(() {
        isExpanded = false;
      });
      _collapseTimer?.cancel(); // Cancel any existing collapse timer
    }
  }
}
