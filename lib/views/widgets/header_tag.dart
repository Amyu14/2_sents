import 'package:flutter/material.dart';

class HeaderTag extends StatelessWidget {
  final String contentHeader;
  final bool isSelected;
  const HeaderTag(
    this.contentHeader,
    this.isSelected,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.primaryContainer,
      elevation: 2,
      child: Center(
        child: Text(
          contentHeader,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}