import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relay_simulator/global.dart';
import 'package:intl/intl.dart';

class DocumentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Received Documents')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(Paths.collectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
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
    DateTime dateGenerated =
        DateTime.parse(report.text.split("time:").last.trim());

    return ListTile(
      title: Text(report.fileName),
      subtitle:
          Text(DateFormat('dd-MMM-yyyy - hh:mm aa').format(dateGenerated)),
      leading: CircleAvatar(foregroundColor: Colors.white,
        backgroundColor: ThemeColors.primaryColor,
        child: Text(report.fileName
            .substring(report.fileName.length - 7, report.fileName.length - 4)),
      ),
      onTap: () => _showPopUp(context, report),
    );
  }

  _showPopUp(BuildContext context, Report report) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Blood test report'),
          content: Text(report.text),
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
  final DocumentReference reference;

  Report.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['text'] != null),
        assert(map['fileName'] != null),
        fileName = map['fileName'],
        text = map['text'];

  Report.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$fileName: $text>";
}
