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

  ActivityList(this.parcel);

  @override
  State<StatefulWidget> createState() {
    return ActivityListState(this.parcel);
  }
}

class ActivityListState extends State<ActivityList> {
  Parcel parcel;

  ActivityListState(this.parcel);

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
    TextStyle textStyle = Theme.of(context).textTheme.title;
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    return FutureBuilder<List<Activity>>(
      future: dbHelper.getCropActivities(parcel.crop),
      builder: (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Activity listedActivity = snapshot.data[index];
                return ListTile(
                    title: Text(listedActivity.activityType),
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
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ActivityDetail(title, activity);
    }));

    if (result == true) {
      getActivityListView();
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
