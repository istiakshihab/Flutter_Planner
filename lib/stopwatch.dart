import 'package:flutter/material.dart';
import 'dart:async';

class StopWidget extends StatefulWidget {
  StopwatchState createState() => new StopwatchState(); 
}

class StopwatchState extends State<StopWidget>{
  String _startText = "Start";
  String _stopwatchText = "00:00:00";
  final _stopWatch = new Stopwatch(); 
  final _timeout = const Duration(milliseconds: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Stopwatch",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: _mainWatch(),
      ); 
  }

  Widget _mainWatch(){
    return Column(
      children: <Widget>[
        Center(
          child: FittedBox(
            fit: BoxFit.none,
            child: Text(_stopwatchText,
            style: TextStyle(fontSize: 80),),
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            RaisedButton(
            onPressed: _buttonPressed,
            child: Text(_startText , style: TextStyle(color: Colors.white),),
            color: Colors.blue,
          ),
          RaisedButton(
            onPressed: _resetButtonPressed,
            child: Text("Reset", style: TextStyle(color: Colors.white),)
            ,color: Colors.red,
            ),
            ],
            )
        ),
      ],
    );
  }

  void _buttonPressed(){
    setState(() {
      if(_stopWatch.isRunning){
        _startText = "Start";
        _stopWatch.stop();
      }
      else{
        _startText = "Stop";
        _stopWatch.start();
        _startTimeout();
      }
    });
  }

  void _resetButtonPressed(){
    if(_stopWatch.isRunning){
      _buttonPressed();
    }
    setState(() {
      _stopWatch.reset();
      _setStopwatchText();
    });
  }

  void _setStopwatchText() { 
    _stopwatchText =
                    (_stopWatch.elapsed.inMinutes%60).toString().padLeft(2, "0") + ":" +
                    (_stopWatch.elapsed.inSeconds%60).toString().padLeft(2, "0")+":"+
                    (_stopWatch.elapsed.inMilliseconds%100).toString().padLeft(2,"0");
  }

  void _startTimeout() {
    new Timer(_timeout, _handleTimeout); 
  }

  void _handleTimeout() {
    if (_stopWatch.isRunning) {
      _startTimeout();
    }
    setState(() {
      _setStopwatchText();
    });
  }
}