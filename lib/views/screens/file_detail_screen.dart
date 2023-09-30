import 'package:flutter/material.dart';
import 'package:two_sents/models/data_dump.dart';
import 'package:intl/intl.dart';
import 'package:two_sents/views/screens/analysis_screen.dart';
import 'package:two_sents/views/widgets/fds_card.dart';
import 'word_count_screen.dart';
import '../widgets/preview_table.dart';

class FileDetailScreen extends StatelessWidget {
  final DataDump dataDump;
  const FileDetailScreen({super.key, required this.dataDump});

  BoxDecoration containerDecoration(BuildContext context) {
    return BoxDecoration(
        gradient: LinearGradient(colors: [
      Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
    ], begin: Alignment.topLeft, end: Alignment.bottomRight));
  }

  Widget buildIconRow(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 75,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(
          width: 10,
        ),
         Text(
            text,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.secondary, fontSize: 38),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dataDump.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              Text(
                "Added ${DateFormat.yMMMd().format(dataDump.datePublished)}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w200,
                    color: Theme.of(context).colorScheme.secondary),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: containerDecoration(context),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(15)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text("Preview of File:", style: Theme.of(context).textTheme.titleMedium,),
                              const SizedBox(height: 16,),
                              PreviewTable(dataDump.preview),
                            ],
                          ),
                        ),
                      )
                    ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.all(16),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (ctx) {
                                return AnalysisScreen(dataDump);
                              }));
                            },
                            child: FdsCard(buildIconRow(context,
                                Icons.thumbs_up_down, "SENTIMENT\nANALYSIS"))),
                      )),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (ctx) {
                                  return WordCountScreen(dataDump);
                                }));
                              },
                              child: FdsCard(buildIconRow(context,
                                  Icons.format_list_numbered, "WORD\nFREQUENCIES"))),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}