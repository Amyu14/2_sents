import 'package:flutter/material.dart';

class AddFile extends StatelessWidget {
  final void Function() startAddFile;
  final double elevation;
  const AddFile({super.key, required this.startAddFile, this.elevation = 1});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: startAddFile,
      child: Card(
        elevation: elevation,
        color: Colors.blueGrey.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 40,
          )
        ),
      ),
    );
  }
}