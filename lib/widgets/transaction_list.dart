import 'package:LifeTracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionList extends StatelessWidget {
  final databaseReference = Firestore.instance;
  final Function deleteTransaction;
  TransactionList(this.deleteTransaction);
  Widget showWaitingImage(){
        return Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'No Transactions added yet.',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: StreamBuilder(
          stream: Firestore.instance.collection("account").snapshots(),
          builder:(context, snapshot){
          if(!snapshot.hasData)
          return showWaitingImage();
          return ListView.builder(
              itemBuilder: (ctx, index) {
                DocumentSnapshot document = snapshot.data.documents[index];
                if(snapshot.data.documents.length<1)
                  return showWaitingImage();
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: FittedBox(
                            child: Text(
                                '\$${document['amount'].toStringAsFixed(2)}')),
                      ),
                    ),
                    title: Text(
                      document['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(document['date'].toDate()),
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Theme.of(context).errorColor,
                      ),
                      onPressed: () => deleteTransaction(
                        document.documentID,
                      ),
                    ),
                  ),
                );
              },
             itemCount:  snapshot.data.documents.length,
            );
          }
    ),
    );
  }
}
