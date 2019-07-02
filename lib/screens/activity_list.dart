import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parcel.dart';
import '../models/activity.dart';
import '../models/record.dart';
import '../screens/record_form.dart';
import '../screens/activity_detail.dart';
import '../utils/database_helper.dart';

// Create a List Widget
class ActivityList extends StatefulWidget {
  final Parcel parcel;
  final List<Record> parcelRecords;

  ActivityList(this.parcel, this.parcelRecords);

  @override
  State<StatefulWidget> createState() {
    return ActivityListState(this.parcel, this.parcelRecords);
  }
}

class ActivityListState extends State<ActivityList> {
  Parcel parcel;
  List<Record> parcelRecords;

  ActivityListState(this.parcel, this.parcelRecords);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Popis zadataka za parcelu'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    debugPrint('User clicked back [activity list]');
                    moveToLastScreen();
                  }),
            ),
            body: getActivityListView()
        )
    );
  }

  Widget getActivityListView() {
    debugPrint('Entered getActivityListView [activity_list]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    return FutureBuilder<List<Activity>>(
      future: dbHelper.getCropActivities(parcel.crop),
      builder: (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Activity listedActivity = snapshot.data[index];
                int recordCount = parcelRecords.length;
                int activityRepeat = listedActivity.repeatTimes;

                // Check all parcel's records and count the number of times this
                // activity has already been done
                for(int i = 0; i < recordCount; i++) {
                  if(parcelRecords[i].activityType == listedActivity.activityType) {
                    activityRepeat -= 1;
                  }
                }

                // If we did the activity enough times don't show it in the list
                if(activityRepeat < 1) {
                  return Padding(padding: EdgeInsets.only(top: 1.0));
                } else {
                  return ListTile(
                    title: Text(
                        listedActivity.activityType,
                        style: TextStyle(fontSize: 16.0)),
                    onTap: () {
                      navigateToActivityDetail(listedActivity, listedActivity.activityType);
                      setState(() {});
                    },
                    trailing: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          debugPrint('User clicked "check" on an activity [activity list]');
                          DateTime now = DateTime.now();
                          String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                          navigateToRecordForm(
                              Record(parcel.parcelName, listedActivity.activityType, formattedDate, 0, 0, 0),
                              parcel, 'Novi zapis');
                        }),
                  );
                }
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void navigateToRecordForm(Record record, Parcel parcel, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RecordForm(title, parcel, record);
    }));

    if (result == true) {
      getActivityListView();
    }
  }

  void navigateToActivityDetail(Activity activity, String title) async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    List<Record> parcelRecords = await dbHelper.getParcelRecords(parcel.parcelName);
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ActivityDetail(title, activity, parcel, parcelRecords);
    }));

    if (result == true) {
      getActivityListView();
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
