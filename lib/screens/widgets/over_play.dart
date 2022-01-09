import 'package:flutter/material.dart';

class OverPopupPage extends StatefulWidget {
  final Offset offset;
  final bool isLeft;
  final VoidCallback like;
  final VoidCallback dislike;
  const OverPopupPage({
    Key? key,
    required this.offset,
    required this.isLeft,
    required this.like,
    required this.dislike,
  }) : super(key: key);

  @override
  _OverPopupPageState createState() => _OverPopupPageState();
}

class _OverPopupPageState extends State<OverPopupPage> {
  var opacity = 0.0;
  var heightPop = 0.0;
  var widthPop = 0.0;

  void _show(bool isVisible) {
    setState(() {
      opacity = isVisible ? 1 : 0.0;
      heightPop = isVisible ? 50 : 0.0;
      widthPop = isVisible ? 100 : 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _show(true);
    });
  }

  void _handleLike() {
    _show(false);
    Navigator.of(context).pop();
    widget.like();
  }

  void _handleDislike() async {
    _show(false);
    Navigator.of(context).pop();
    widget.dislike();
  }

  void _handleClosed() {
    _show(false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _handleClosed,
            ),
          ),
          if (widget.isLeft)
            Positioned(
              top: widget.offset.dy - 60,
              left: widget.offset.dx,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: heightPop,
                  width: widthPop,
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: IconButton(
                          onPressed: _handleLike,
                          icon: const Icon(
                            Icons.favorite_sharp,
                          ),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: _handleDislike,
                          icon: const Icon(
                            Icons.favorite_border,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!widget.isLeft)
            Positioned(
              top: widget.offset.dy - 60,
              right: widget.offset.dx,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: heightPop,
                  width: widthPop,
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: IconButton(
                          onPressed: _handleLike,
                          icon: const Icon(
                            Icons.favorite_sharp,
                          ),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: _handleDislike,
                          icon: const Icon(
                            Icons.favorite_border,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
