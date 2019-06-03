import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parcel.dart';
import '../models/record.dart';
import '../screens/record_form.dart';
import '../utils/database_helper.dart';

// Create a Widget
class RecordDetail extends StatefulWidget {
  final Parcel parcel;
  final Record record;

  RecordDetail(this.parcel, this.record);

  @override
  State<StatefulWidget> createState() {
    return RecordDetailState(this.record, this.parcel);
  }
}

// This class will hold the data related to the parcel details
class RecordDetailState extends State<RecordDetail> {
  Record record;
  Parcel parcel;

  RecordDetailState(this.record, this.parcel);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    List<Widget> gridList = <Widget> [
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Parcela:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(parcel.parcelName)
      ),
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
          child: Text('Posao odrađen:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(record.date)
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Dobivena/prodana količina:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(record.quantity.toString() + ' kg')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Troškovi:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(record.expense.toString() + ' HRK')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text('Zarada:')
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(record.income.toString() + ' HRK')
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
            onPressed: () {
              debugPrint('User clicked button uredi [record detail]');
              navigateToRecordForm(record, parcel,
                  '${parcel.parcelName} : ${record.activityType}');
            },
            child: Text('Uredi')
        ),
      ),
      Padding(
          padding: EdgeInsets.all(4.0),
          child: RaisedButton(
              onPressed: () {
                debugPrint('User clicked button obriši [record detail]');
                _deleteRecord(record);
                moveToLastScreen();
              },
              child: Text('Obriši')
          )
      )
    ];

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Detalji aktivnosti'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    debugPrint('User clicked back [record detail]');
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

  void _deleteRecord(Record recordToDelete) async {
    debugPrint('Entered _deleteRecord method [record_detail]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    debugPrint('recordToDelete: [record_detail]\n' + recordToDelete.toString());
    int i = await dbHelper.deleteRecord(recordToDelete.id);
    debugPrint('Delete returned: $i [record_detail]');
  }

  void navigateToRecordForm(Record record, Parcel parcel, String title) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RecordForm(title, parcel, record);
    }));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
