import 'package:flutter/material.dart';
import 'package:two_sents/constants.dart';
import 'package:two_sents/models/data_dump.dart';
import 'package:two_sents/views/widgets/wc_option.dart';

class AnalysisScreen extends StatefulWidget {
  final DataDump dataDump;

  const AnalysisScreen(this.dataDump, {super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool isLoading = false;
  bool isAnalysing = false;

  late String spreadsheetLink;
  late String pieLink;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getLinks().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Future getLinks() async {
    final userData = await firestore
        .collection("data")
        .doc(widget.dataDump.uid)
        .collection("user_dumps")
        .doc(widget.dataDump.id)
        .get();
    spreadsheetLink = userData["analysisExcel"];
    pieLink = userData["analysisPie"];
  }

  Widget preAnalysis(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Your file is yet to be processed. ",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: width / 30,
                fontWeight: FontWeight.w200,
                color: Theme.of(context).colorScheme.secondary),
          ),
          SizedBox(
            width: width / 300,
          ),
          InkWell(
            onTap: () async {
              setState(() {
                isAnalysing = true;
              });

              try {
                await fireFuncs.httpsCallable("getanalysis").call({
                  "fileUrl": widget.dataDump.fileUrl,
                  "contentHeader": widget.dataDump.contentHeader,
                  "dumpId": widget.dataDump.id,
                  "name": widget.dataDump.name
                });
                spreadsheetLink = await firebaseStorage
                    .ref()
                    .child(firebaseAuth.currentUser!.uid)
                    .child("analysisExcel")
                    .child(widget.dataDump.id)
                    .child("${widget.dataDump.name}_sentiments.xlsx")
                    .getDownloadURL();
                pieLink = await firebaseStorage
                    .ref()
                    .child(firebaseAuth.currentUser!.uid)
                    .child("analysisPie")
                    .child(widget.dataDump.id)
                    .child("${widget.dataDump.name}_pie.png")
                    .getDownloadURL();
                await firestore
                    .collection("data")
                    .doc(firebaseAuth.currentUser!.uid)
                    .collection("user_dumps")
                    .doc(widget.dataDump.id)
                    .update({
                  "analysisExcel": spreadsheetLink,
                  "analysisPie": pieLink
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("There was an error in analysis your file. Please try again later or upload a new spreadsheet.")));
              }
              setState(() {
                isAnalysing = false;
              });
            },
            child: Text(
              "Analyse Now.",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: width / 30,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget postAnalysis(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          WordCountOption(
              Icons.table_chart, "GET SPREADSHEET", 200, spreadsheetLink),
          const SizedBox(width: 40),
          WordCountOption(Icons.pie_chart, "GET PIE CHART", 600, pieLink),
        ],
      ),
    );
  }

  Widget fetchingData() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text("Processing your file. Do not close this tab.")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            title: Text(
                "Analyse Sentiments in ${widget.dataDump.name} with Deep Learning")),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : isAnalysing
                ? fetchingData()
                : spreadsheetLink.isEmpty
                    ? preAnalysis(context)
                    : postAnalysis(context));
  }
}
