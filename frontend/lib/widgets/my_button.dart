import 'package:flutter/material.dart';
import 'package:project_crud/utils/loading_state.dart';

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
    this.icon,
    this.width = 100,
    this.height = 40,
  });

  final Icon? icon;
  final String label;
  final Function() onPressed;
  final Color color;
  final double width, height;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> with LoadingStateMixin {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder:
          (context, value, child) => InkWell(
            onTap: () => withLoading(widget.onPressed),
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(5),
              ),
              child:
                  value
                      ? Center(
                        child: SizedBox(
                          width: widget.height * 0.5,
                          height: widget.height * 0.5,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.icon ?? SizedBox.shrink(),
                          Text(
                            widget.label,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
            ),
          ),
    );
  }
}
