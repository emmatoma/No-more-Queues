import 'package:camara1/camarawidget.dart';
import 'package:flutter/material.dart';
import 'MyCrud.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); 
   await Firebase.initializeApp();
  runApp(MaterialApp(
    
    title: "app camara",
       home: camarawidget(),
  ));
}


