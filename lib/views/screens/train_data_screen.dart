import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:two_sents/constants.dart';

class TrainDataScreen extends StatefulWidget {
  const TrainDataScreen({super.key});

  @override
  State<TrainDataScreen> createState() => _TrainDataScreenState();
}

class _TrainDataScreenState extends State<TrainDataScreen> {
  bool isLoading = false;
  Uint8List? pickedFileBytes;
  String? pickedFileName;

  void pickFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["xlsx"],
        allowMultiple: false);

    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      pickedFileBytes = pickedFile.files.single.bytes;

      pickedFileName = pickedFile.files.single.name;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            firebaseAuth.signOut();
          },
        ),
      ),
      body: Center(
        child: SizedBox(
          width: pickedFileBytes == null ? 450 : 350,
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "IMPROVE 2 SENTS",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          onPressed: pickFile,
                          icon: Icon(
                            pickedFileBytes == null
                                ? Icons.upload_file_outlined
                                : Icons.check_box_outlined,
                            size: 120,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                  if (pickedFileName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(pickedFileName!),
                    ),
                  if (pickedFileBytes != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                pickedFileBytes = null;
                                pickedFileName = null;
                              });
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final ref = firebaseStorage
                                        .ref()
                                        .child("train_data")
                                        .child(DateFormat.yMMMMd()
                                            .format(DateTime.now()))
                                        .child(firebaseAuth.currentUser!.uid)
                                        .child(pickedFileName!);
                                    await ref.putData(pickedFileBytes!);
                                    setState(() {
                                      isLoading = false;
                                      pickedFileName = null;
                                      pickedFileBytes = null;
                                    });
                                  },
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                  )
                                : const Text("Submit"))
                      ],
                    ),
                  if (pickedFileName == null)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 16),
                          children: [
                            TextSpan(
                                text: "2 SENTS' ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.7))),
                            const TextSpan(text: "analyses are produced by "),
                            TextSpan(
                                text: "Machine Learning models",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.7))),
                            const TextSpan(
                                text:
                                    ". By uploading more labelled data, you can help train these models and improve their performance."),
                          ]),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
