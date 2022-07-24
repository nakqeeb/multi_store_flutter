import 'package:flutter/material.dart';

class ProductDetailsHeaderLabel extends StatelessWidget {
  final String label;
  const ProductDetailsHeaderLabel({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Theme.of(context).colorScheme.tertiary,
              thickness: 2,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Theme.of(context).colorScheme.tertiary,
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
