import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parcel.dart';
import '../screens/parcel_form.dart';
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
    TextStyle textStyle = Theme.of(context).textTheme.title;
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
          /*body: Padding(
              padding: EdgeInsets.only(
                  top: 15.0, bottom: 15.0, left: 10.0, right: 10.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      // First row
                      Row(children: <Widget>[
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: 'Usjev:',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        ),
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: parcel.crop,
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        )
                      ]),
                      // Second row
                      Row(children: <Widget>[
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: 'Površina:',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        ),
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: parcel.m2.toString(),
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        )
                      ]),
                      // Third row
                      Row(children: <Widget>[
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: 'Početak radova:',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        ),
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: parcel.startTime,
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        )
                      ]),
                      // Fourth row
                      Row(children: <Widget>[
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: 'Ukupna količina:',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        ),
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: parcel.totalQuantity.toString(),
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        )
                      ]),
                      // Fifth row
                      Row(children: <Widget>[
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: 'Trenutna količina:',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        ),
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: parcel.currentQuantity.toString(),
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        )
                      ]),
                      // Sixth row
                      Row(children: <Widget>[
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: 'Ukupna zarada:',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        ),
                        TextField(
                          style: textStyle,
                          decoration: InputDecoration(
                              labelText: parcel.income.toString(),
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5))),
                        )
                      ]),
                    ],
                    // End of first (left) column
                  ),
                  Column(
                    children: <Widget>[
                      RaisedButton(
                          onPressed: () {
                            debugPrint('User clicked button obavljeno [parcel detail]');
                          },
                          child: Text('Obavljeno')
                      ),
                      RaisedButton(
                          onPressed: () {
                            debugPrint('User clicked button zadaci [parcel detail]');
                          },
                          child: Text('Zadaci')
                      ),
                      Row(
                        children: <Widget>[
                          RaisedButton(
                              onPressed: () {
                                debugPrint('User clicked button uredi [parcel detail]');
                                navigateToParcelForm(parcel, parcel.parcelName);
                              },
                              child: Text('Uredi')
                          ),
                          RaisedButton(
                              onPressed: () {
                                debugPrint('User clicked button obriši [parcel detail]');
                                _deleteParcel(parcel);
                                moveToLastScreen();
                              },
                              child: Text('Obriši')
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
          */
        )
    );
  }

  void _deleteParcel(Parcel parcelToDelete) async {
    debugPrint('Entered _deleteParcel method [parcel_detail]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    // TODO: i sve recordse obrisati

    debugPrint('parcelToDelete: [parcel_detail]\n' + parcelToDelete.toString());
    int i = await dbHelper.deleteParcel(parcelToDelete.id);
    debugPrint('Delete returned: $i [parcel_detail]');
  }

  void navigateToParcelForm(Parcel parcel, String title) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ParcelForm(title, parcel);
    }));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
