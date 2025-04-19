import 'package:flutter/material.dart';

class ButtonComp extends StatefulWidget {
  final String buttonText;
  final Function()? onPressFun;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final Icon? icon;
  final bool isEnabled;

  const ButtonComp({
    super.key,
    required this.buttonText,
    required this.onPressFun,
    this.backgroundColor = const Color(0xff131f28),
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 50,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
    this.borderRadius = 7.0,
    this.icon,
    this.isEnabled = true,
  });

  @override
  State<ButtonComp> createState() => _ButtonCompState();
}

class _ButtonCompState extends State<ButtonComp> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: widget.isEnabled ? widget.onPressFun : null,
        style: ButtonStyle(
          minimumSize:
              WidgetStateProperty.all<Size>(const Size(double.infinity, 50)),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return widget.backgroundColor?.withOpacity(0.5) ??
                    const Color(0xff131f28).withOpacity(0.5);
              }
              return widget.backgroundColor ?? const Color(0xff131f28);
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 7.0),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              widget.icon ?? const SizedBox(),
              const SizedBox(width: 8),
            ],
            Text(
              widget.buttonText,
              style: TextStyle(
                color: widget.isEnabled
                    ? (widget.textColor ?? Colors.white)
                    : (widget.textColor ?? Colors.white).withOpacity(0.5),
                fontWeight: widget.fontWeight,
                fontSize: widget.fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
