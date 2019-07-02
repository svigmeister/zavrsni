import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parcel.dart';
import '../screens/parcel_form.dart';
import '../screens/parcel_detail.dart';
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
            navigateToParcelForm(
                Parcel('', 0, 'Kukuruz', formattedDate), 'Nova parcela');
            setState(() {});
          }),
    );
  }

  Widget getParcelListView() {
    debugPrint('Entered getParcelListView [parcel_list]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    return FutureBuilder<List<Parcel>>(
      future: dbHelper.getAllParcels(),
      builder: (BuildContext context, AsyncSnapshot<List<Parcel>> snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot.hasData = true [parcel_list]\nLista parcela: ' +
              snapshot.toString() +
              '\nsnapshot length: ' +
              snapshot.data.length.toString());
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                debugPrint('treuntni index u item builderu: $index');
                Parcel listedParcel = snapshot.data[index];
                debugPrint('Parcela u item builderu: [parcel_list]\n' +
                    listedParcel.toString());
                return ListTile(
                    title: Text(
                        listedParcel.parcelName,
                        style: TextStyle(fontSize: 16.0)),
                    onTap: () {
                      navigateToParcelDetail(
                          listedParcel, listedParcel.parcelName);
                      setState(() {});
                    });
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void navigateToParcelForm(Parcel parcel, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ParcelForm(title, parcel);
    }));

    if (result == true) {
      getParcelListView();
    }
  }

  void navigateToParcelDetail(Parcel parcel, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ParcelDetail(title, parcel);
    }));

    if (result == true) {
      getParcelListView();
    }
  }
}
