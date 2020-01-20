import 'package:LifeTracker/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:LifeTracker/memoire.dart';
import 'package:LifeTracker/stopwatch.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'manrope',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontSize: 25,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Welcome to Daylio?',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 19,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Memoire'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Memoire(),
                      ),);
                },
              ),
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Account'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Account(),
                  ),
                );
              },
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('StopWatch'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StopWidget(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
