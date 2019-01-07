import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relay_simulator/global.dart';
import 'package:intl/intl.dart';

class StatisticsPage extends StatelessWidget {
  final List<DocumentSnapshot> snapshot;

  StatisticsPage(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.error,
              color: Colors.white,
            ),
            onPressed: () {
              int avgLatency = 0;
              snapshot.forEach((data) {
                var report = Report.fromSnapshot(data);
                avgLatency = avgLatency + report.latency;
              });
              avgLatency = (avgLatency / snapshot.length).round();
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Average latency'),
                    content: Text('$avgLatency milliseconds'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return _buildList(context, snapshot);
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.separated(
      itemCount: snapshot.length,
      separatorBuilder: (context, index) => Divider(height: 0.0),
      itemBuilder: (context, index) {
        return _buildListItem(
            context, snapshot.elementAt((snapshot.length - 1) - index));
      },
      padding: const EdgeInsets.only(top: 8.0),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final report = Report.fromSnapshot(data);
    DateTime dateGenerated = DateTime.parse(report.generationDate);
    DateTime dateReceived = DateTime.parse(report.receivedDate);

    return ExpansionTile(
      title: Text(report.fileName),
      children: <Widget>[
        ListTile(
          title: Text(
              '${DateFormat('dd-MMM-yyyy - HH:mm:ss').format(dateGenerated)}'),
          subtitle: Text('Generated'),
        ),
        ListTile(
          title: Text(
              '${DateFormat('dd-MMM-yyyy - HH:mm:ss').format(dateReceived)}'),
          subtitle: Text('Received'),
        ),
        ListTile(
          title: Text('${report.latency} milliseconds'),
          subtitle: Text('Latency'),
        ),
      ],
      leading: CircleAvatar(
        foregroundColor: Colors.white,
        backgroundColor: ThemeColors.primaryColor,
        child: Text(report.fileName
            .substring(report.fileName.length - 7, report.fileName.length - 4)),
      ),
    );
  }

  _showPopUp(BuildContext context, List<DocumentSnapshot> snapshot) {
    int avgLatency = 0;
    snapshot.forEach((data) {
      var report = Report.fromSnapshot(data);
      avgLatency = avgLatency + report.latency;
    });
    avgLatency = (avgLatency / snapshot.length).round();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Average latency'),
          content: Text('$avgLatency milliseconds'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Report {
  final String text;
  final String fileName;
  final String generationDate;
  final String receivedDate;
  final int latency;
  final DocumentReference reference;

  Report.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['text'] != null),
        assert(map['fileName'] != null),
        assert(map['generationDate'] != null),
        assert(map['receivedDate'] != null),
        assert(map['latency'] != null),
        fileName = map['fileName'],
        text = map['text'],
        generationDate = map['generationDate'],
        receivedDate = map['receivedDate'],
        latency = map['latency'];

  Report.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$fileName: $text>";
}
