import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tool.dart';
import '../models/activity.dart';
import '../models/parcel.dart';
import '../models/record.dart';
import '../utils/database_helper.dart';

// Create a Widget
class ActivityDetail extends StatefulWidget {
  final String appBarTitle;
  final Activity activity;
  final Parcel parcel;
  final List<Record> parcelRecords;

  ActivityDetail(this.appBarTitle, this.activity, this.parcel, this.parcelRecords);

  @override
  State<StatefulWidget> createState() {
    return ActivityDetailState(this. parcelRecords, this. parcel, this.activity, this.appBarTitle);
  }
}

// This class will hold the data related to the parcel details
class ActivityDetailState extends State<ActivityDetail> {
  Activity activity;
  Parcel parcel;
  String appBarTitle;
  List<Record> parcelRecords;

  ActivityDetailState(this.parcelRecords, this.parcel, this.activity, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    List<Widget> gridList = <Widget> [
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Usjev:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(activity.cropName)
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Opis aktivnosti:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(activity.description)
              )
            ],
          )
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Popis alata:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: FutureBuilder<List<Tool>>(
            future: dbHelper.getActivityTools(activity),
              builder: (BuildContext context, AsyncSnapshot<List<Tool>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Tool listedTool = snapshot.data[index];
                        return Card(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(listedTool.toolName + ':  ' +
                                      listedTool.price.toStringAsFixed(2) +
                                      ' HRK'),
                                  flex: 1
                              )
                            ],
                          ),
                        );
                      });
                } else {
                  return ListTile(
                    // This isn't showing
                    title: Text(
                        'Za ovu aktivnost alati nisu potrebni.',
                        style: TextStyle(fontSize: 16.0))
                  );
                }
              }
          )
      ),
      // Dynamic view
      showExpectedExpense1(),
      showExpectedExpense2(),
      // Dynamic, show start date row only for some activities
      showStartDate1(),
      showStartDate2(),
    ];

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
          },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  debugPrint('User clicked back [activity detail]');
                  moveToLastScreen();
                }),
          ),
            body: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 4),
              ),
              itemCount: gridList.length,
              itemBuilder: (context, index) {
                return GridTile(child: gridList[index]);
              },
            )
        )
    );
  }

  Widget showStartDate1() {
    if(activity.activityType == 'Berba' || activity.activityType == 'Prodaja' ||
        activity.activityType == 'Dodatni troškovi') {
      return Padding(padding: EdgeInsets.all(1.0));
    } else {
      return Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Početak radova:')
      );
    }
  }

  Widget showStartDate2() {
    if(activity.activityType == 'Berba' || activity.activityType == 'Prodaja' ||
        activity.activityType == 'Dodatni troškovi') {
      return Padding(padding: EdgeInsets.all(1.0));
    } else {
      String activityWorkStart;
      DateTime latestWorkStart = DateTime.parse(parcel.startTime);
      int count = parcelRecords.length;

      for(int i = 0; i < count; i++) {
        if(parcelRecords[i].activityType == activity.activityType) {
          if(DateTime.parse(parcelRecords[i].date).isAfter(latestWorkStart)) {
            latestWorkStart = DateTime.parse(parcelRecords[i].date);
          }
        }
      }
      // If this activity has already been done, add repeatDays number of days
      // to the latest occurrence of the activity, else if this is the first
      // occurrence of the activity, add initial number of days to the parcel
      // startTime date
      if(latestWorkStart.isAfter(DateTime.parse(parcel.startTime))) {
        activityWorkStart = DateFormat('dd-MM-yyyy').format(
            latestWorkStart.add(new Duration(days: activity.repeatDays)));
      } else {
        activityWorkStart = DateFormat('dd-MM-yyyy').format(
            latestWorkStart.add(new Duration(days: activity.startDay)));
      }
      return Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(activityWorkStart)
      );
    }
  }

  Widget showExpectedExpense1() {
    if(activity.activityType == 'Berba' || activity.activityType == 'Prodaja' ||
        activity.activityType == 'Dodatni troškovi') {
      return Padding(padding: EdgeInsets.all(1.0));
    } else {
      return Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Troškovi materijala:')
      );
    }
  }

  Widget showExpectedExpense2() {
    if(activity.activityType == 'Berba' || activity.activityType == 'Prodaja' ||
        activity.activityType == 'Dodatni troškovi') {
      return Padding(padding: EdgeInsets.all(1.0));
    } else {
      return Padding(
          padding: EdgeInsets.all(4.0),
          child: RichText(
            text: TextSpan(
                text: (activity.expenseByM2 * parcel.m2).toStringAsFixed(2) + ' HRK',
                style: TextStyle(color: Colors.red, fontSize: 16.0)
            ),
          )
      );
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}