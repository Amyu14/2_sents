import 'package:cloud_firestore/cloud_firestore.dart';

class DataDump {
  final String id;
  final String uid;
  final String name;
  final DateTime datePublished;
  final String fileUrl;
  final String contentHeader;
  final String analysisExcel;
  final String analysisPie;
  final String wordCountExcel;
  final String wordCountBar;
  final String wordCloud;
  final Map<String, dynamic> preview;

  const DataDump({
    required this.id,
    required this.uid,
    required this.datePublished,
    required this.name,
    required this.contentHeader,
    required this.fileUrl,
    required this.preview,
    this.analysisExcel = "",
    this.analysisPie = "",
    this.wordCountExcel = "",
    this.wordCountBar = "",
    this.wordCloud = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uid": uid,
      "datePublished": datePublished,
      "name": name,
      "contentHeader": contentHeader,
      "fileUrl": fileUrl,
      "analysisExcel": analysisExcel,
      "analysisPie": analysisPie,
      "wordCountExcel": wordCountExcel,
      "wordCountBar": wordCountBar,
      "wordCloud": wordCloud,
      "preview" : preview
    };
  }

  static DataDump fromSnap(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    return DataDump(
        id: snap["id"],
        uid: snap["uid"],
        datePublished: snap["datePublished"].toDate(),
        name: snap["name"],
        contentHeader: snap["contentHeader"],
        fileUrl: snap["fileUrl"],
        analysisExcel: snap["analysisExcel"],
        analysisPie: snap["analysisPie"],
        wordCountExcel: snap["wordCountExcel"],
        wordCountBar: snap["wordCountBar"],
        wordCloud: snap["wordCloud"],
        preview: snap["preview"]
        );
  }
}