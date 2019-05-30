import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

import '../models/parcel.dart';
import 'package:my_crop/screens/parcel_form.dart';
import '../utils/database_helper.dart';

// Create a List Widget
class ParcelList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ParcelListState();
  }
}

class ParcelListState extends State<ParcelList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popis parcela'),
      ),
      body: getParcelListView(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('yyyy-MM-dd').format(now);
            navigateToParcelForm(Parcel('Moja Parcela', 1, 'Mrkva', formattedDate),
                'Nova parcela');
            setState(() {});
          }
          ),
    );
  }

  Widget getParcelListView() {
    debugPrint('Entered getParcelListView [parcel_list]');
    TextStyle textStyle = Theme.of(context).textTheme.title;
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    return FutureBuilder<List<Parcel>>(
      future: dbHelper.getAllParcels(),
      builder: (BuildContext context, AsyncSnapshot<List<Parcel>> snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot.hasData = true [parcel_list]\nLista parcela: '
          + snapshot.toString() + '\nsnapshot length: ' + snapshot.data.length.toString());
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              debugPrint('treuntni index u item builderu: $index');
              Parcel par = snapshot.data[index];
              debugPrint('Parcela u item builderu: [parcel_list]\n' + par.toString());
              return ListTile(
                title: Text('${par.parcelName}, ${par.crop}, ${par.startTime}'),
                leading: Text(par.id.toString()),
                /*onTap: navigateToParcelForm(parcel, parcel.parcelName);
                         setState(() {});*/
              );
            }
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
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