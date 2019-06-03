import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tool.dart';
import '../models/activity.dart';
import '../utils/database_helper.dart';

// Create a Widget
class ActivityDetail extends StatefulWidget {
  final String appBarTitle;
  final Activity activity;

  ActivityDetail(this.appBarTitle, this.activity);

  @override
  State<StatefulWidget> createState() {
    return ActivityDetailState(this.activity, this.appBarTitle);
  }
}

// This class will hold the data related to the parcel details
class ActivityDetailState extends State<ActivityDetail> {
  Activity activity;
  String appBarTitle;

  ActivityDetailState(this.activity, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
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
          child: Text(activity.description)
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
                        return Center(
                            child: Text(listedTool.toolName)
                        );
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
          )
      ),
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

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}