import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WordCountOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final int colorShade;
  final String url;

  const WordCountOption(this.icon, this.text, this.colorShade, this.url, {super.key});

  Future<void> _launchUrl() async {
    Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Cannot download the file at this time!');
  }
}
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () async {
        _launchUrl();
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          width: size.width / 3.5,
          height: size.height / 2,
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 150,
                  color: Colors.blue[colorShade],
                ),
                SizedBox(height: size.height / 100),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
