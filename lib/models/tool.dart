class Tool {

  int _id;
  String _toolName;
  String _cropName;
  String _activityType;
  double _price;

  Tool(this._toolName, this._cropName, this._activityType, this._price);

  Tool.withId(this._id, this._toolName, this._cropName, this._activityType, this._price);

  int get id => _id;
  String get toolName => _toolName;
  String get cropName => _cropName;
  String get activityType => _activityType;
  double get price => _price;

  set toolName(nName) {
    this._toolName = nName;
  }
  set cropName(nCrop) {
    this._cropName = nCrop;
  }
  set activityType(nActivityType) {
    this._activityType = nActivityType;
  }
  set price(nPrice) {
    this._price = nPrice;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['_id'] = _id;
    }
    map['toolName'] = _toolName;
    map['cropName'] = _cropName;
    map['activityType'] = _activityType;
    map['price'] = _price;

    return map;
  }

  Tool.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._toolName = map['toolName'];
    this._cropName = map['cropName'];
    this._activityType = map['activityType'];
    this._price = map['price'];
  }
}