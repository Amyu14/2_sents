import 'package:flutter/material.dart';
import 'package:two_sents/constants.dart';
import 'package:two_sents/models/data_dump.dart';
import 'package:intl/intl.dart';

class FileGridItem extends StatefulWidget {
  final DataDump dataDump;
  final void Function() toFileDetailScreen;

  const FileGridItem(
      {super.key,
      required this.dataDump,
      required this.toFileDetailScreen
      });

  @override
  State<FileGridItem> createState() => _FileGridItemState();
}

class _FileGridItemState extends State<FileGridItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.toFileDetailScreen,
      child: Stack(
        children: [
          Card(
              elevation: 2,
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.dataDump.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )),
          Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Text("Date Added: ${DateFormat.yMMMd().format(widget.dataDump.datePublished)}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall),
              )),
          Positioned(
            left: 10,
            bottom: 10,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(context: context, builder: (ctx) {
                  return SimpleDialog(
                    title: const Text("Are you sure you want to delete this item?"),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: () {
                            Navigator.of(context).pop();
                          }, child: const Text("NO")),
                          const SizedBox(width: 16,),
                          ElevatedButton(onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {

                              firebaseStorage.ref().child(firebaseAuth.currentUser!.uid).child("file").child(widget.dataDump.id).child("${widget.dataDump.name}.xlsx").delete();
                              if (widget.dataDump.analysisExcel.isNotEmpty) {
                                firebaseStorage.ref().child(firebaseAuth.currentUser!.uid).child("analysisExcel").child(widget.dataDump.id).child("${widget.dataDump.name}_sentiments.xlsx").delete();
                              }
                              if (widget.dataDump.analysisPie.isNotEmpty) {
                                firebaseStorage.ref().child(firebaseAuth.currentUser!.uid).child("analysisPie").child(widget.dataDump.id).child("${widget.dataDump.name}_pie.png").delete();
                              }
                              if (widget.dataDump.wordCountExcel.isNotEmpty) {
                                firebaseStorage.ref().child(firebaseAuth.currentUser!.uid).child("wordCountExcel").child(widget.dataDump.id).child("${widget.dataDump.name}_WC_spreadsheet.xlsx").delete();
                              }
                              if (widget.dataDump.wordCountBar.isNotEmpty) {
                                firebaseStorage.ref().child(firebaseAuth.currentUser!.uid).child("wordCountBar").child(widget.dataDump.id).child("${widget.dataDump.name}_WC_bar.png").delete();
                              }
                              if (widget.dataDump.wordCloud.isNotEmpty) {
                                firebaseStorage.ref().child(firebaseAuth.currentUser!.uid).child("wordCloud").child(widget.dataDump.id).child("${widget.dataDump.name}_word_cloud.png").delete();
                              }
                              firestore.collection("data").doc(firebaseAuth.currentUser!.uid).collection("user_dumps").doc(widget.dataDump.id).delete();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("There was an error removing the item")));
                            }
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context).pop();
                          }, child: isLoading ? const Center(child: CircularProgressIndicator()) : const Text("YES"))
                        ],
                      )
                    ],
                  );
                });
              },
            ))
        ],
      ),
    );
  }
}