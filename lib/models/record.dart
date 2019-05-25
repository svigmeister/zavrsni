class Record {

  int _id;
  String _parcelName;
  String _activityType;
  DateTime _date;
  double _income;
  double _quantity;

  Record(this._parcelName, this._activityType, this._date, this._income,
    this._quantity);

  Record.withId(this._id, this._parcelName, this._activityType, this._date,
      this._income, this._quantity);

  int get id => _id;
  String get parcelName => _parcelName;
  String get activityType => _activityType;
  DateTime get date => _date;
  double get income => _income;
  double get quantity => _quantity;

  set parcelName(nName) {
    this._parcelName = nName;
  }
  set activityType(nType) {
    this._activityType = nType;
  }
  set date(nDate) {
    this._date = nDate;
  }
  set income(nIncome) {
    this._income = nIncome;
  }
  set quantity(nQuantity) {
    this._quantity = nQuantity;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['_id'] = _id;
    }
    map['parcelName'] = _parcelName;
    map['activityType'] = _activityType;
    map['date'] = _date;
    map['income'] = _income;
    map['quantity'] = _quantity;

    return map;
  }

  Record.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._parcelName = map['parcelName'];
    this._activityType = map['activityType'];
    this._date = map['date'];
    this._income = map['income'];
    this._quantity = map['quantity'];
  }
}