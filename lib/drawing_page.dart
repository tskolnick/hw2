import 'dart:async';
import 'package:hw2/sketcher.dart';


import 'package:hw2/drawn_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<DrawnLine> lines = <DrawnLine>[];
  late DrawnLine line = DrawnLine([Offset(0, 0)], selectedColor, selectedWidth);
  Color selectedColor = Colors.black;
  double selectedWidth = 5.0;

  StreamController<List<DrawnLine>> linesStreamController = StreamController<List<DrawnLine>>.broadcast();
  StreamController<DrawnLine> currentLineStreamController = StreamController<DrawnLine>.broadcast();

void onPanStart(DragStartDetails details) {
  print('User started drawing');
  final box = context.findRenderObject() as RenderBox;
  final point = box.globalToLocal(details.globalPosition);
  setState((){
    line = DrawnLine([point], selectedColor, selectedWidth);
  });

}

void onPanUpdate(DragUpdateDetails details) {
  final box = context.findRenderObject() as RenderBox;
  final point = box.globalToLocal(details.globalPosition);
  final path = line.path..add(point);
  setState((){
    line = DrawnLine(path, selectedColor, selectedWidth);
  });

}


void onPanEnd(DragEndDetails details) {
  print('User ended drawing');
   _startLineAnimation();
}

void _startLineAnimation() {


  Timer.periodic(Duration(milliseconds: 5), (timer) {
    setState(() {
      if (line.path.length > 1) {
        line = DrawnLine(line.path.sublist(1), selectedColor, selectedWidth);
      } else {
        timer.cancel();
      }
    });
  });


}

GestureDetector buildCurrentPath(BuildContext context) {
  return GestureDetector(
    onPanStart: onPanStart,
    onPanUpdate: onPanUpdate,
    onPanEnd: onPanEnd,
    child: RepaintBoundary(
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // CustomPaint widget will go here
        child: CustomPaint(
          painter: Sketcher(lines: [line]),
        ),
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: Stack(
        children: [
                buildCurrentPath(context),
        ],
      ),
    );
  }


  @override
  void dispose() {
    //linesStreamController.close();
    //currentLineStreamController.close();
    super.dispose();
  }
}
