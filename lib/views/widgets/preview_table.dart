import 'package:flutter/material.dart';

class PreviewTable extends StatelessWidget {
  final Map<String, dynamic> previewRows;
  const PreviewTable(this.previewRows, {super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        for (int i = 0; i < previewRows["0"].length; i++) i: const FlexColumnWidth(),
      },
      border: TableBorder.all(
          color: Colors.blue,
          width: 0.8,
          borderRadius: BorderRadius.circular(5)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          for (final headerRow in previewRows["0"])
            Card(
              child: Text(headerRow, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall,),
            )
        ]),
        for (int i = 1; i < 11; i++)
          TableRow(children: [
            for (final row in previewRows["$i"])
              SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Text(
                        row,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ))
          ])
      ],
    );
  }
}
