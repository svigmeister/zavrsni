import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parcel.dart';
import '../models/record.dart';
import '../utils/database_helper.dart';

// Create a Form Widget
class RecordForm extends StatefulWidget {
  final String appBarTitle;
  final Parcel parcel;
  final Record record;

  RecordForm(this.appBarTitle, this.parcel, this.record);

  @override
  State<StatefulWidget> createState() {
    return RecordFormState(this.record, this.parcel, this.appBarTitle);
  }
}

// This class will hold the data related to the form
class RecordFormState extends State<RecordForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<RecordFormState>!
  final _recordFormKey = GlobalKey<FormState>();
  Record record;
  Parcel parcel;
  String appBarTitle;
  double oldExpense;
  double oldIncome;
  double oldQuantity;
  TextEditingController expenseController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  // State constructor
  RecordFormState(this.record, this.parcel, this.appBarTitle);

  // A method for date picker
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(record.date),
        firstDate: DateTime(2018),
        lastDate: DateTime(2096));
    if (picked != null)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _parcelFormKey we created above
    expenseController.text = record.expense.toString();
    incomeController.text = record.income.toString();
    quantityController.text = record.quantity.toString();

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
                  debugPrint('User clicked back [record form]');
                  moveToLastScreen();
                }),
          ),
          body: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: 15.0, bottom: 15.0, left: 10.0, right: 10.0),
                  child: recordFormUI()
              )
            ],
          )
        ),
    );
  }

  Widget recordFormUI() {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Form(
      key: _recordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextFormField(
              controller: expenseController,
              style: textStyle,
              decoration: InputDecoration(
                  labelText: 'Trošak',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5))),
              onEditingComplete: () {
                updateExpense();
              },
              validator: (value) {
                RegExp numRegex = new RegExp(r'^[0-9]+(\.[0-9]+)?$');
                if (value.isEmpty) {
                  return 'Unesite iznos troškova!';
                }
                if (!numRegex.hasMatch(value)) {
                  return 'Unesite brojčanu vrijednost (za decimalni zapis koristite točku)!';
                }
                if (double.parse(value) < 0) {
                  return 'Unesite pozitivan iznos!';
                }
              },
            ),
          ),

          // Dynamic view, show income field only for sell activity
          showIncomeInput(textStyle),

          // Dynamic view, show quantity field only for some activities/records
          showQuantityInput(textStyle),

          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(DateFormat('dd-MM-yyyy').format(selectedDate))
          ),
          RaisedButton(
            onPressed: () => _selectDate(context),
            child: Text('Odaberi datum'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                debugPrint('User clicked button spremi [record form]');
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_recordFormKey.currentState.validate()) {
                  _catchDateInput(selectedDate);
                  if (appBarTitle == 'Novi zapis') {
                    _saveRecord(record, parcel);
                    moveToLastScreen();
                  } else {
                    _updateRecord(record, parcel);
                    moveToLastScreen();
                  }
                }
              },
              child: Text('Spremi zapis'),
            ),
          ),
        ],
      ),
    );
  }

  Widget showQuantityInput(TextStyle ts) {
    if(record.activityType == 'Berba' || record.activityType == 'Prodaja') {
      return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: TextFormField(
          controller: quantityController,
          style: ts,
          decoration: InputDecoration(
              labelText: 'Količina',
              labelStyle: ts,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.5))),
          onEditingComplete: () {
            updateQuantity();
          },
          validator: (value) {
            RegExp numRegex = new RegExp(r'^[-]?[0-9]+(\.[0-9]+)?$');
            if (value.isEmpty) {
              return 'Unesite iznos količine!';
            }
            if (!numRegex.hasMatch(value)) {
              return 'Unesite brojčanu vrijednost (za decimalni zapis koristite točku)!';
            }
          },
        ),
      );
    } else {
      return Padding(padding: EdgeInsets.all(1.0));
    }
  }

  Widget showIncomeInput(TextStyle ts) {
    if(record.activityType == 'Prodaja') {
      return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: TextFormField(
          controller: incomeController,
          style: ts,
          decoration: InputDecoration(
              labelText: 'Zarada',
              labelStyle: ts,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.5))),
          onEditingComplete: () {
            updateIncome();
          },
          validator: (value) {
            RegExp numRegex = new RegExp(r'^[0-9]+(\.[0-9]+)?$');
            if (value.isEmpty) {
              return 'Unesite iznos zarade!';
            }
            if (!numRegex.hasMatch(value)) {
              return 'Unesite brojčanu vrijednost (za decimalni zapis koristite točku)!';
            }
            if (double.parse(value) < 0) {
              return 'Unesite pozitivan iznos!';
            }
          },
        ),
      );
    } else {
      return Padding(padding: EdgeInsets.all(1.0));
    }
  }

  void _saveRecord(Record recordToSave, Parcel recordsParcel) async {
    debugPrint('Entered _saveRecord method [record_form]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    if (recordToSave.quantity == null) {
      recordToSave.quantity = 0.0;
    }

    debugPrint('recordToSave: [record_form]\n' + recordToSave.toString());
    int id = await dbHelper.insertRecord(recordToSave.toMap());
    debugPrint('Save returned id: $id [record_form]');

    debugPrint('Parcel to be updated: [record form]\n' + recordsParcel.toString());
    int id2 = await dbHelper.refreshParcelInfo(recordsParcel);
    debugPrint('Refresh returned id: $id2 [record_form]');
  }

  void _updateRecord(Record recordToUpdate, Parcel recordsParcel) async {
    debugPrint('Entered _updateRecord method [record_form]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    debugPrint('recordToUpdate: [record_form]\n' + recordToUpdate.toString());
    int id = await dbHelper.updateRecord(recordToUpdate.toMap());
    debugPrint('Update returned id: $id [record_form]');

    // If the record is updated, we need to delete old and insert new data
    debugPrint('Parcel to be updated: [record form]\n' + recordsParcel.toString());
    int id2 = await dbHelper.refreshParcelInfo(recordsParcel);
    debugPrint('Refresh returned id: $id2 [record_form]');
  }

  void updateExpense() {
    oldExpense = record.expense;
    record.expense = double.parse(expenseController.text);
  }

  void updateIncome() {
    oldIncome = record.income;
    record.income = double.parse(incomeController.text);
  }

  void updateQuantity() {
    oldQuantity = record.quantity;
    double tmpQty = double.parse(quantityController.text);
    if (record.activityType == 'Prodaja') {
      tmpQty -= (2 * tmpQty);
    }
    record.quantity = tmpQty;
  }

  void _catchDateInput(DateTime date) {
    record.date = DateFormat('yyyy-MM-dd').format(date);
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}