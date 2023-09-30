import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:two_sents/views/screens/file_grid_screen.dart';
import 'package:two_sents/views/screens/train_data_screen.dart';
import 'package:uuid/uuid.dart';

List<Widget> pages = const [
  FileGridScreen(),
  TrainDataScreen()
];

final firebaseAuth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
final firebaseStorage = FirebaseStorage.instance;
final fireFuncs = FirebaseFunctions.instance;

const uuidGen = Uuid();