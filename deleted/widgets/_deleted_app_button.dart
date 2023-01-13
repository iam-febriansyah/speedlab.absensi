import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  AppButton(
      {required this.onPressed,
      required this.text,
      this.color = ColorsTheme.primary1,
      this.icon = const Icon(
        Icons.add,
        color: Colors.white,
      )});
  final Function()? onPressed;
  final String text;
  final Icon icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ColorsTheme.primary1,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            icon
          ],
        ),
      ),
    );
  }
}
