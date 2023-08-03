import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.backgroundColor,
    required this.image,
    required this.onPressed,
  });

  final Color backgroundColor;
  final AssetImage image;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 50,
      height: 50,
      color: backgroundColor,
      shape: const CircleBorder(),
      onPressed: onPressed,
      child: Image(
        image: image,
        width: 30,
        height: 30,
      ),
    );
  }
}


class RoundedCategoryButton extends StatelessWidget {
  const RoundedCategoryButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  final String text;
  final bool isSelected;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      color: isSelected ? Colors.black : Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
              ),
            )),
      ),
    );
  }
}

