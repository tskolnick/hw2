import 'package:hw2/drawing_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
      title: 'Drawing App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DrawingPage(),
    )
  
  );

