class Parcel {

  int _id;
  String _parcelName;
  double _m2;
  String _crop;
  double _income;
  double _quantity;

  Parcel(this._parcelName, this._m2, this._crop, [this._income, this._quantity]);

  String get parcelName => _parcelName;
  double get m2 => _m2;
  String get crop => _crop;
  double get income => _income;
  double get quantity => _quantity;
}