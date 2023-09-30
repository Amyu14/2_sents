import 'package:flutter/material.dart';
import 'package:two_sents/constants.dart';
import 'package:two_sents/models/data_dump.dart';
import 'package:two_sents/views/widgets/wc_option.dart';

class WordCountScreen extends StatefulWidget {
  final DataDump dataDump;
  const WordCountScreen(this.dataDump, {super.key});

  @override
  State<WordCountScreen> createState() => _WordCountScreenState();
}

class _WordCountScreenState extends State<WordCountScreen> {
  bool isLoading = false;
  bool isAnalysing = false;
  late String excelUrl;
  late String barUrl;
  late String wordCloudUrl;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getValues().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Future getValues() async {
    final data = await firestore
        .collection("data")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("user_dumps")
        .doc(widget.dataDump.id)
        .get();
    excelUrl = data["wordCountExcel"];
    barUrl = data["wordCountBar"];
    wordCloudUrl = data["wordCloud"];
  }

  Widget preCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Your file is yet to be processed. ",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: width / 35,
                fontWeight: FontWeight.w200,
                color: Theme.of(context).colorScheme.secondary),
          ),
          SizedBox(
            width: width / 340,
          ),
          InkWell(
            onTap: () async {
              setState(() {
                isAnalysing = true;
              });
              try {
                await fireFuncs.httpsCallable("getwordcounts").call({
                "fileUrl": widget.dataDump.fileUrl,
                "contentHeader": widget.dataDump.contentHeader,
                "dumpId": widget.dataDump.id,
                "name": widget.dataDump.name
              });
              excelUrl = await firebaseStorage
                  .ref()
                  .child(firebaseAuth.currentUser!.uid)
                  .child("wordCountExcel")
                  .child(widget.dataDump.id)
                  .child("${widget.dataDump.name}_WC_spreadsheet.xlsx")
                  .getDownloadURL();
              barUrl = await firebaseStorage
                  .ref()
                  .child(firebaseAuth.currentUser!.uid)
                  .child("wordCountBar")
                  .child(widget.dataDump.id)
                  .child("${widget.dataDump.name}_WC_bar.png")
                  .getDownloadURL();
              wordCloudUrl = await firebaseStorage
                  .ref()
                  .child(firebaseAuth.currentUser!.uid)
                  .child("wordCloud")
                  .child(widget.dataDump.id)
                  .child("${widget.dataDump.name}_word_cloud.png")
                  .getDownloadURL();

              await firestore
                  .collection("data")
                  .doc(firebaseAuth.currentUser!.uid)
                  .collection("user_dumps")
                  .doc(widget.dataDump.id)
                  .update({
                "wordCloud": wordCloudUrl,
                "wordCountBar": barUrl,
                "wordCountExcel": excelUrl
              });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("There was an error in analysis your file. Please try again later or upload a new spreadsheet.")));
              }
              setState(() {
                isAnalysing = false;
              });
            },
            child: Text(
              "Extract word frequencies now.",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: width / 35,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget postCount(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          WordCountOption(
              Icons.cloud_outlined, "GET WORD CLOUD", 100, wordCloudUrl),
          const SizedBox(
            width: 10,
          ),
          WordCountOption(
            Icons.table_chart,
            "GET FREQUENCY TABLE",
            300,
            excelUrl,
          ),
          const SizedBox(width: 10),
          WordCountOption(Icons.bar_chart, "GET BAR CHART", 500, barUrl),
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
          title: const Text("Analyse this File's Word Frequencies")),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : isAnalysing
              ? fetchingData()
              : excelUrl.isEmpty
                  ? preCount(context)
                  : postCount(context),
    );
  }
}