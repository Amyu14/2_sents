import 'package:flutter/material.dart';
import 'package:two_sents/constants.dart';
import 'package:two_sents/models/data_dump.dart';
import 'package:two_sents/views/screens/file_detail_screen.dart';
import 'package:two_sents/views/widgets/add_file.dart';
import 'package:two_sents/views/widgets/add_file_form.dart';
import 'package:two_sents/views/widgets/file_grid_item.dart';

class FileGrid extends StatefulWidget {
  const FileGrid({super.key});

  @override
  State<FileGrid> createState() => _FileGridState();
}

class _FileGridState extends State<FileGrid> {
  void showAddFileForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return const SimpleDialog(
            title: Text("ADD A FILE"),
            children: [AddFileForm()],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore
            .collection("data")
            .doc(firebaseAuth.currentUser!.uid)
            .collection("user_dumps").orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.85,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.85,
                child: Center(
                    child:
                        SizedBox(
                          width: 300,
                          height: 300,
                          child: AddFile(startAddFile: () => showAddFileForm(context), elevation: 2,))));
          }

          return GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
                childAspectRatio: 3 / 2,
              ),
              itemCount: snapshot.data!.docs.length + 1,
              itemBuilder: (ctx, index) {
                if (index == 0) {
                  return AddFile(
                    startAddFile: () => showAddFileForm(context),
                  );
                } else {
                  DataDump dataDump =
                      DataDump.fromSnap(snapshot.data!.docs[index - 1]);

                  return FileGridItem(
                    dataDump: dataDump,
                    toFileDetailScreen: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileDetailScreen(
                          dataDump: dataDump,
                        );
                      }));
                    },
                  );
                }
              });
        });
  }
}