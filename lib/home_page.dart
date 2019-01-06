import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relay_simulator/documents_page.dart';
import 'package:relay_simulator/global.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _documentCount = 0;
  Color _iconTextColor = ThemeColors.primaryColor;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Relay Simulator')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(Paths.collectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        if (_documentCount == 0) {
          _documentCount = snapshot.data.documents.length;
        } else {
          if (_documentCount != snapshot.data.documents.length) {
            _documentCount = snapshot.data.documents.length;
            _showSnackBar(context);
            _calcTime(context, snapshot.data.documents.last);
          }
        }

        return ListView(
          padding: const EdgeInsets.only(top: 8.0),
          children: <Widget>[
            //Card no.1 for received documents.
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Card(
                child: ListTile(
                    leading: Icon(
                      Icons.library_books,
                      color: ThemeColors.primaryColor,
                    ),
                    title: Text('Received documents'),
                    trailing: Container(alignment: Alignment.center,
                      width: _documentCount > 9 ? 24.0 : 18.0,
                      height: _documentCount > 9 ? 24.0 : 18.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _iconTextColor),
                      ),
                      child: Text(
                        _documentCount.toString(),
                        style: TextStyle(color: _iconTextColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _iconTextColor = Colors.grey;
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DocumentsPage()));
                    }),
              ),
            ),
            //Card no.2 statistics of received files.
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Card(
                child: ListTile(
                    leading: Icon(
                      Icons.insert_chart,
                      color: ThemeColors.primaryColor,
                    ),
                    title: Text('Statistics'),
                    onTap: () {}),
              ),
            ),
            //Card no.3 upload to cloud.
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Card(
                child: ListTile(
                    leading: Icon(
                      Icons.cloud_upload,
                      color: ThemeColors.primaryColor,
                    ),
                    title: Text('Cloud upload'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/widget');
                    }),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSnackBar(BuildContext context) async {
    _iconTextColor = ThemeColors.primaryColor;
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('New document received.')));
  }

  Future<void> _calcTime(BuildContext context, DocumentSnapshot data) async {
    String dateString = data['text'].split("time:").last.trim();
    DateTime generationDate =
        DateTime.parse(dateString.substring(0, dateString.length - 1));
    DateTime receivedDate = DateTime.now();
    var latency = receivedDate.difference(generationDate).inMilliseconds;

    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(data.reference, {
        'generationDate': generationDate.toString(),
        'receivedDate': receivedDate.toString(),
        'latency': latency,
      });
    });
  }
}
