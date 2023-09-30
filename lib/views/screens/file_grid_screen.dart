import 'package:flutter/material.dart';
import 'package:two_sents/constants.dart';
import 'package:two_sents/views/widgets/file_grid.dart';

class FileGridScreen extends StatefulWidget {
  const FileGridScreen({super.key});

  @override
  State<FileGridScreen> createState() => _FileGridScreenState();
}

class _FileGridScreenState extends State<FileGridScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top:16),
        child: IconButton(icon: const Icon(Icons.exit_to_app), onPressed: () {firebaseAuth.signOut();},),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("YOUR FILES", style: Theme.of(context).textTheme.titleLarge!.copyWith(color: 
              Theme.of(context).colorScheme.secondary),),
              const SizedBox(height: 10,),
              const FileGrid(),
            ],
          ),
        ),
      ),
    );
  }
}