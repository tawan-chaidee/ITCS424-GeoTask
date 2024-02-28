import 'package:flutter/material.dart';

class BottomSheet extends StatefulWidget {
  const BottomSheet({
    super.key,
    this.minSize = 0.1,
    this.maxSize = 1,
    this.child,
    this.snapSizes = const [0.1, 0.5, 1],
    this.snapDistance = 0.1,
  });

  final double minSize;
  final double maxSize;
  final Widget? child;
  final List<num> snapSizes;
  final num snapDistance;

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  double _heightFactor = 0.5;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedFractionallySizedBox(
              duration: Duration(milliseconds: _isDragging ? 0 : 250),
              curve: Curves.easeInOut,
              heightFactor: _heightFactor,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: _heightFactor < 1
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )
                      : BorderRadius.zero,
                  boxShadow: [
                    BoxShadow(
                      color: _heightFactor < 1
                          ? Colors.black.withOpacity(0.2)
                          : Colors.transparent,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: (details) {
                          var change = details.delta.dy / constraints.maxHeight;
                          var factor = (_heightFactor - change);

                          setState(() {
                            _isDragging = true;
                            _heightFactor =
                                factor.clamp(widget.minSize, widget.maxSize);
                          });
                        },
                        onVerticalDragEnd: (details) {
                          // Snap to the nearest value
                          for (int i = 0; i < widget.snapSizes.length; i++) {
                            if ((_heightFactor - widget.snapSizes[i]).abs() <
                                widget.snapDistance) {
                              setState(() {
                                _heightFactor = widget.snapSizes[i].toDouble();
                              });
                            }
                          }

                          setState(() {
                            _isDragging = false;
                          });
                        },
                        child: Container(
                          // margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                height: 6,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                      ),
                      Expanded(child: widget.child ?? Container()),
                    ]),
              ),
            ));
      },
    );
  }
}
