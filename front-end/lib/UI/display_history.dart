import 'package:cattleplus/UI/web_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryObject {
  DateTime createdAt;
  String predictionType;
  String publicURL;
  // HistoryObject(this.createdAt, this.predictionType);
  HistoryObject(this.createdAt, this.predictionType, this.publicURL);
}

Future<List<HistoryObject>> fetchHistory(String documentId) async {
  final firestoreInstance = FirebaseFirestore.instance;

  // Get a reference to the specific document
  DocumentSnapshot docSnapshot =
      await firestoreInstance.collection('catteles').doc(documentId).get();

  if (docSnapshot.exists) {
    dynamic historySnapshot = docSnapshot.get("history");
    if (historySnapshot.length == 0) return [];
    historySnapshot[0]["lastState"] = docSnapshot.get("lastState");
    if (historySnapshot.length == 0) return [];
    List<HistoryObject> historyList = historySnapshot
        .map<HistoryObject>((element) => HistoryObject(
            element['createdAt'].toDate() ?? "",
            element['predictionType'].toLowerCase() ?? "",
            element['publicUrl'] ?? ""))
        .toList();
    return historyList;
  } else {
    print('Document with ID $documentId does not exist.');
    return []; // Return an empty list when document doesn't exist
  }
}

class DisplayHistory extends StatelessWidget {
  final String? name;
  final String documentId;

  DisplayHistory(this.documentId, {Key? key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name ?? ""),
      ),
      body: FutureBuilder<List<HistoryObject>>(
        future: fetchHistory(documentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching history"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("There is no history"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                HistoryObject historyItem = snapshot.data![index];
                DateTime dt = historyItem.createdAt;
                String date = "${dt.day}/${dt.month}/${dt.year}";
                String time = "${dt.hour}:${dt.minute}:${dt.second}";
                return ListTile(
                  onTap: () {
                    print(historyItem.publicURL);
                    if (!historyItem.publicURL.isEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WebView(URL: historyItem.publicURL)));
                    }
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Row(
                    children: [
                      get_icon(historyItem.predictionType),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        historyItem.predictionType,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        date,
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        time,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

Icon get_icon(String state) {
  dynamic color = Colors.black;
  if (state == "natural" || state == "LFC" || state == "healthy")
    return Icon(
      FontAwesomeIcons.smile,
      color: Colors.green[800],
    );
  else if (state == "unknown") {
    return Icon(
      Icons.signal_cellular_0_bar,
      color: Colors.grey,
    );
  } else if (state == 'unnatural' || state == 'distress')
    return Icon(
      Icons.add_alert,
      color: Colors.orange[800],
    );
  else
    return Icon(
      Icons.warning,
      color: Colors.red[800],
    );
}
