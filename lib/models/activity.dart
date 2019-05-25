class Activity {

  int _id;
  String _activityType;
  String _cropName;
  int _startTime;
  String _tips;

  Activity(this._activityType, this._cropName, this._startTime, this._tips);

  Activity.withId(this._id, this._activityType, this._cropName, this._startTime,
      this._tips);

  int get id => _id;
  String get activityType => _activityType;
  String get cropName => _cropName;
  int get startTime => _startTime;
  String get tips => _tips;

  set activityType(nType) {
    this._activityType = nType;
  }
  set cropName(nName) {
    this._cropName = nName;
  }
  set startTime(nTime) {
    this._startTime = nTime;
  }
  set tips(nTips) {
    this._tips = nTips;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['_id'] = _id;
    }
    map['activityType'] = _activityType;
    map['cropName'] = _cropName;
    map['startTime'] = _startTime;
    map['tips'] = _tips;

    return map;
  }

  Activity.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._activityType = map['activityType'];
    this._cropName = map['cropName'];
    this._startTime = map['startTime'];
    this._tips = map['tips'];
  }
}