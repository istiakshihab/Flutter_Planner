import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Memoire extends StatefulWidget {
  List<String> _todoItems = [];
  @override
  createState() => new TodoState();
}

class TodoState extends State<Memoire> {
  final databaseReference = Firestore.instance;
  final todoInput = TextEditingController();
  DateTime selectedDate;
  void _addTodoItem() async {
    final enteredTask = todoInput.text;
    await databaseReference.collection("ToDo").add({
      'name': enteredTask,
      'date': selectedDate,
    });
    Navigator.of(context).pop();
  }

  Widget _buildTodoList() {
    return StreamBuilder(
        stream: Firestore.instance.collection('ToDo').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading.....');
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
                _buildTodoItem(context, snapshot.data.documents[index]),
          );
        });
  }

  String _getTime(Timestamp timestamp) {
    var now = new DateTime.now();
    var formate = new DateFormat('HH:mm a');
    var date = timestamp.toDate();
    print(date);
    var diff = now.difference(date);
    print(diff);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = formate.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' day ago';
      } else {
        time = diff.inDays.toString() + ' days ago';
      }
    }
    return time;
  }

  Widget _buildTodoItem(BuildContext context, DocumentSnapshot document) {
    return Card( 
      child: ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              document['name'],
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Text(
            _getTime(document['date']),
          )
        ],
      ),
     onTap: ()=>_promptRemoveItem(document.documentID, document),
    ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Todo",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add Task',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _presentDatePicker() {
    DatePicker.showDateTimePicker(context, 
      showTitleActions: true,
      onChanged: (date) {
      print('change $date');
      selectedDate = date;
      setState(() {
        selectedDate = date;
      });
    }, onConfirm: (date) {
      selectedDate = date;
      setState(() {
        selectedDate = date;
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  void _pushAddTodoScreen() {
    setState(() {
      selectedDate= null;
    });
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Card(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: "Todo Title"),
                      controller: todoInput,
                      keyboardType: TextInputType.text,
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Todo Date'),
                          ),
                          FlatButton(
                            textColor: Colors.black,
                            child: Text(selectedDate == null
                                ? "Choose Date"
                                : 'Picked Date: ${DateFormat('yyyy-MM-dd kk:mm').format(selectedDate)}'),
                            onPressed: _presentDatePicker,
                          )
                        ],
                      ),
                    ),
                    RaisedButton(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Add Todo',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _addTodoItem,
                      color: Colors.lightBlueAccent,
                    )
                  ],
                )),
          );
        });
  }

  void _removeTodoItem(String docID) {
    try{
      databaseReference.collection("ToDo").document(docID).delete();
    }
    catch(e){
      print(e.toString());
          }
  }

  void _promptRemoveItem(String docID, DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(('Mark "${document['name']}" as done?')),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              new FlatButton(
                child: new Text('Mark as Done'),
                onPressed: () {
                  _removeTodoItem(docID);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}
