import 'package:flutter/material.dart';

class SupplierOrderTab extends StatelessWidget {
  final String label;
  const SupplierOrderTab({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
