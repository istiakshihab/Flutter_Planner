import 'package:LifeTracker/widgets/chart.dart';
import 'package:LifeTracker/widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/transaction_list.dart';
import 'models/transaction.dart' as trx;
import 'package:cloud_firestore/cloud_firestore.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final databaseReference = Firestore.instance;
  List<trx.Transaction> _userTransactions = [
    // Transaction(
    //   id: 'ID00001',
    //   title: 'AC Cool',
    //   amount: 23.00,
    //   date: DateTime.now(),
    // ),
  ];

  void setList(List<trx.Transaction> trax){
    _userTransactions = trax;
  }
  void _createTransaction(trx.Transaction newTransaction) async{
  await databaseReference.collection("account")
      .add({
        'id':newTransaction.id,
        'title': newTransaction.title,
        'amount': newTransaction.amount,
        'date': newTransaction.date,
      });
  }

  Future<List<trx.Transaction>> _recentTransactionX() async{
    QuerySnapshot querySnapshot = await databaseReference.collection('account').where(
      'date', isGreaterThan: DateTime.now().subtract(Duration(days: 7)),
    ).getDocuments();
    return querySnapshot.documents.map(
      (doc)=> trx.Transaction(
        id: doc.data['id'],
        title: doc.data['title'],
        date: doc.data['date'].toDate(),
        amount: doc.data['amount']
      )
    ).toList();
  }
  mainLoop() async{
    List <trx.Transaction> trax = await _recentTransactionX();
    setList(trax);
  }

  // List<trx.Transaction> get _recentTransaction {
  //   return _userTransactions.where((test) {
  //     return test.date.isAfter(
  //       DateTime.now().subtract(
  //         Duration(days: 7),
  //       ),
  //     );
  //   }).toList();
  // }

  void _addTransaction(String title, double amount, DateTime chosenDate) {
    final newTransaction = trx.Transaction(
      title: title,
      amount: amount,
      id: DateTime.now().toString(),
      date: chosenDate,
    );
    setState(() {
      // _userTransactions.add(newTransaction);
      _createTransaction(newTransaction);
    });
  }

  void _deleteTransaction(String id){
    setState(() {
      try{
        databaseReference.collection("account").document(id).delete();
      }
      catch(e){
        print(e.toString());
      }
      // _userTransactions.removeWhere((transaction){
      //   return transaction.id == id;
      // });
    });
  }

  void _startAddNewTrx(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    mainLoop();
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: Colors.black),
        actions: <Widget>[  
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () => _startAddNewTrx(context),
          )
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Expenses",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_userTransactions),
            TransactionList(_deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTrx(context),
      ),
    );
  }
}
