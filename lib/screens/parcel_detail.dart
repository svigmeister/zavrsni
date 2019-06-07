import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parcel.dart';
import '../models/record.dart';
import '../screens/parcel_form.dart';
import '../screens/record_list.dart';
import '../screens/activity_list.dart';
import '../utils/database_helper.dart';

// Create a Widget
class ParcelDetail extends StatefulWidget {
  final String appBarTitle;
  final Parcel parcel;

  ParcelDetail(this.appBarTitle, this.parcel);

  @override
  State<StatefulWidget> createState() {
    return ParcelDetailState(this.parcel, this.appBarTitle);
  }
}

// This class will hold the data related to the parcel details
class ParcelDetailState extends State<ParcelDetail> {
  Parcel parcel;
  String appBarTitle;

  ParcelDetailState(this.parcel, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    List<Widget> gridList = <Widget> [
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Usjev:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(parcel.crop)
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Površina:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(parcel.m2.toString() + ' m^2')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Početak radova:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(parcel.startTime)))
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Ukupna količina:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(parcel.totalQuantity.toStringAsFixed(2) + ' kg')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Trenutna količina:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(parcel.currentQuantity.toStringAsFixed(2) + ' kg')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Očekivana ukupna ulaganja :')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(parcel.expectedExpense.toStringAsFixed(2) + ' HRK')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Ukupna zarada:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(parcel.income.toStringAsFixed(2) + ' HRK')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: RaisedButton(
              onPressed: () {
                debugPrint('User clicked button obavljeno [parcel detail]');
                navigateToRecordList(parcel);
              },
              child: Text('Obavljeno')
          )
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: RaisedButton(
              onPressed: () {
                debugPrint('User clicked button zadaci [parcel detail]');
                navigateToActivityList(parcel);
              },
              child: Text('Zadaci')
          )
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
            onPressed: () {
              debugPrint('User clicked button uredi [parcel detail]');
              navigateToParcelForm(parcel, parcel.parcelName);
            },
            child: Text('Uredi parcelu')
        ),
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: RaisedButton(
              onPressed: () {
                debugPrint('User clicked button obriši [parcel detail]');
                _deleteParcel(parcel);
                moveToLastScreen();
              },
              child: Text('Obriši parcelu')
          )
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: RaisedButton(
              onPressed: () {
                debugPrint('User clicked button obriši zapise [parcel detail]');
                _deleteParcelRecords(parcel);
                },
              child: Text('Obriši zapise')
          )
      )
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
                  debugPrint('User clicked back [parcel detail]');
                  moveToLastScreen();
                }),
          ),
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 8),
            ),
            itemCount: gridList.length,
            itemBuilder: (context, index) {
              return GridTile(child: gridList[index]);
              },
          )
        )
    );
  }

  void _deleteParcel(Parcel parcelToDelete) async {
    debugPrint('Entered _deleteParcel method [parcel_detail]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    int nbr = await dbHelper.deleteAllRecords(parcelToDelete.parcelName);
    debugPrint('Delete records returned: $nbr [parcel_detail]');

    debugPrint('parcelToDelete: [parcel_detail]\n' + parcelToDelete.toString());
    int i = await dbHelper.deleteParcel(parcelToDelete.id);
    debugPrint('Delete returned: $i [parcel_detail]');
  }

  void _deleteParcelRecords(Parcel parcel) async {
    debugPrint('Entered _deleteParcelRecords method [parcel_detail]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    int nbr = await dbHelper.deleteAllRecords(parcel.parcelName);
    debugPrint('Delete records returned: $nbr [parcel_detail]');

    int id2 = await dbHelper.refreshParcelInfo(parcel);
    debugPrint('Refresh returned id: $id2 [record_form]');
  }

  void navigateToParcelForm(Parcel parcel, String title) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ParcelForm(title, parcel);
    }));
  }

  void navigateToRecordList(Parcel parcel) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RecordList(parcel);
    }));
  }

  void navigateToActivityList(Parcel parcel) async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    List<Record> parcelRecords = await dbHelper.getParcelRecords(parcel.parcelName);
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ActivityList(parcel, parcelRecords);
    }));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
