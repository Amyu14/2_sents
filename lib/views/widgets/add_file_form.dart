import 'dart:typed_data';
import 'package:two_sents/constants.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:two_sents/models/data_dump.dart';
import 'package:two_sents/views/widgets/header_tag.dart';

class AddFileForm extends StatefulWidget {
  const AddFileForm({super.key});

  @override
  State<AddFileForm> createState() => _AddFileFormState();
}

class _AddFileFormState extends State<AddFileForm> {
  TextEditingController fileNameController = TextEditingController();

  Uint8List? pickedFileBytes;
  bool isLoading = false;
  bool isSubmitting = false;
  Map<String, List>? preview;

  List<String>? fileHeaders;
  int selectedHeader = 0;

  final formKey = GlobalKey<FormState>();

  void submitForm(BuildContext context) async {

    if (pickedFileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text("Please provide a file!"),))
      );
      return;
    }

    if (formKey.currentState!.validate()) {

      setState(() {
        isSubmitting = true;
      });

      String dumpId = uuidGen.v4();
      final fileRef =
        firebaseStorage.ref().child(firebaseAuth.currentUser!.uid).child("file").child(dumpId).child("${fileNameController.text}.xlsx");
      await fileRef.putData(pickedFileBytes!);
      final fileUrl = await fileRef.getDownloadURL();

      DataDump newDump = DataDump(
        id: dumpId, 
        fileUrl: fileUrl,
        uid: firebaseAuth.currentUser!.uid, 
        datePublished: DateTime.now(), 
        name: fileNameController.text, 
        contentHeader: fileHeaders![selectedHeader],
        preview: preview!
        );

      await firestore.collection("data").doc(firebaseAuth.currentUser!.uid).collection("user_dumps").doc(dumpId).set(newDump.toJson());

      setState(() {
        isSubmitting = false;
      });
      Navigator.of(context).pop();
    }
    
  }

  void pickFile() async {
    preview = {};
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["xlsx"],
        allowMultiple: false);

    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      pickedFileBytes = pickedFile.files.single.bytes;

      try {
        var excelFile = Excel.decodeBytes(pickedFileBytes!);
        final table = excelFile.tables[excelFile.getDefaultSheet()]!;
        fileHeaders = table.rows[0].map((e) {
          return e!.value.toString();
        }).toList();

        for (int i = 0; i < 11; i++) {
          preview!["$i"] = table.rows[i].map((e) {
          return e!.value.toString();
        }).toList();
        }

        String filename = pickedFile.files.single.name;
        if (fileNameController.text.isEmpty) {
          fileNameController.text =
              filename.substring(0, filename.indexOf(".xls"));
      }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("There was an error uploading the file!")));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: size.width * 0.3,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: InkWell(
                  onTap: pickFile,
                  child: Card(
                    elevation: 2,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Icon(
                            Icons.upload_file_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                ),
              ),
              TextFormField(
                controller: fileNameController,
                decoration: const InputDecoration(
                  hintText: "Give your file a name:",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide a name!";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              if (fileHeaders != null)
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose the content column:",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              if (fileHeaders != null)
                const SizedBox(
                  height: 5,
                ),
              if (fileHeaders != null)
                GridView.builder(
                  itemCount: fileHeaders!.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      childAspectRatio: 4),
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            selectedHeader = index;
                          });
                        },
                        child: HeaderTag(
                            fileHeaders![index], index == selectedHeader));
                  },
                ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: isSubmitting ? null : () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel")),
                  ElevatedButton(
                      onPressed: isSubmitting ? null : () {
                        submitForm(context);
                      },
                      child: isSubmitting ? const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Center(child: CircularProgressIndicator(),),
                      ): const Text("Add File"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
