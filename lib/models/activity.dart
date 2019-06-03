class Activity {

  int _id;
  String _activityType;
  String _cropName;
  int _startDay;
  int _repeatTimes;
  int _repeatDays;
  String _description;

  Activity(this._activityType, this._cropName, this._startDay, this._repeatTimes,
      this._repeatDays, this._description);

  Activity.withId(this._id, this._activityType, this._cropName, this._startDay,
      this._repeatTimes, this._repeatDays, this._description);

  int get id => _id;
  String get activityType => _activityType;
  String get cropName => _cropName;
  int get startDay => _startDay;
  int get repeatTimes => _repeatTimes;
  int get repeatDays => _repeatDays;
  String get description => _description;

  set activityType(nType) {
    this._activityType = nType;
  }
  set cropName(nName) {
    this._cropName = nName;
  }
  set startDay(nDay) {
    this._startDay = nDay;
  }
  set repeatTimes(nTimes) {
    this._repeatTimes = nTimes;
  }
  set repeatDays(nDays) {
    this._repeatDays = nDays;
  }
  set description(nDesc) {
    this._description = nDesc;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['_id'] = _id;
    }
    map['activityType'] = _activityType;
    map['cropName'] = _cropName;
    map['startDay'] = _startDay;
    map['repeatTimes'] = _repeatTimes;
    map['repeatDays'] = _repeatDays;
    map['description'] = _description;

    return map;
  }

  Activity.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._activityType = map['activityType'];
    this._cropName = map['cropName'];
    this._startDay = map['startDay'];
    this._repeatTimes = map['repeatTimes'];
    this._repeatDays = map['repeatDays'];
    this._description = map['description'];
  }
}