import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parcel.dart';
import '../models/record.dart';
import '../screens/record_detail.dart';
import '../utils/database_helper.dart';

// Create a List Widget
class RecordList extends StatefulWidget {
  final String appBarTitle;
  final Parcel parcel;

  RecordList(this.appBarTitle, this.parcel);

  @override
  State<StatefulWidget> createState() {
    return RecordListState(this.parcel, this.appBarTitle);
  }
}

class RecordListState extends State<RecordList> {
  Parcel parcel;
  String appBarTitle;

  RecordListState(this.parcel, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Popis obavljenih zadataka za parcelu: $appBarTitle'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    debugPrint('User clicked back [record list]');
                    moveToLastScreen();
                  }),
            ),
            body: getRecordListView()
        )
    );
  }

  Widget getRecordListView() {
    debugPrint('Entered getRecordListView [record_list]');
    TextStyle textStyle = Theme.of(context).textTheme.title;
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    return FutureBuilder<List<Record>>(
      future: dbHelper.getParcelRecords(parcel.parcelName),
      builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Record listedRecord = snapshot.data[index];
                return ListTile(
                  title: Text(listedRecord.activityType),
                  onTap: () {
                    navigateToRecordDetail(listedRecord, parcel);
                    setState(() {});
                  },
                  trailing: Text((listedRecord.income - listedRecord.expense).toString()),
                );
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void navigateToRecordDetail(Record record, Parcel parcel) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RecordDetail(parcel, record);
    }));

    if (result == true) {
      getRecordListView();
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}