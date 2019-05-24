import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../models/parcel.dart';
import '../forms/parcel_form.dart';

// Create a List Widget
class ParcelList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ParcelListState();
  }
}

//
class ParcelListState extends State<ParcelList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popis parcela'),
      ),
      // body: getParcelListView(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            navigateToParcelForm(Parcel('Moja Parcela', 1, 'Mrkva'), 'Dodaj parcelu');
          }
          ),
    );
  }

  void navigateToParcelForm(Parcel parcel, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ParcelForm(title, parcel);
    }));

    // if (result == true) {
    //   updateListView();
    // }
  }
}