class EventsData {
  List<EventsArray> listEvents;

  EventsData({
    this.listEvents
  });

  factory EventsData.fromJson(Map<String, dynamic> parseJson){
    var response = parseJson['Response'];
    var listEvent = response['arrayOfEventDetails'] as List;

    List<EventsArray> listArrayData = listEvent.map((i) =>
        EventsArray.fromJson(i)).toList();
    return EventsData(
        listEvents: listArrayData
    );
  }
}

class EventsArray {
  String eventId;
  String schoolId;
  String teacherId;
  String eventTitle;
  String eventDesc;
  String eventDate;
  String eventTime;
  String eventImage;
  String eventPostedBy;
  String eventLink;
  String eventPostedOn;
  String eventFlag;

  EventsArray({
    this.eventId,
    this.eventTitle,
    this.eventDesc,
    this.eventDate,
    this.eventTime,
    this.eventImage,
    this.eventPostedBy,
    this.eventLink,
    this.teacherId,
    this.schoolId,
    this.eventPostedOn,
    this.eventFlag
  });

  factory EventsArray.fromJson(Map<String, dynamic> parseJson){
    return EventsArray(
        eventId: parseJson.containsKey('event_id')
            ? parseJson['event_id']
            : parseJson['athilatic_id'],
        eventTitle: parseJson.containsKey('event_title')
            ? parseJson['event_title']
            : parseJson['atheltics_name'],
        eventDesc: parseJson.containsKey('event_description')
            ? parseJson['event_description']
            : parseJson['atheltics_description'],
        eventPostedOn: parseJson['posted_on'],
        eventImage: parseJson.containsKey('event_image')
            ? parseJson['event_image']
            : parseJson['atheltics_image'],
        eventPostedBy: parseJson.containsKey('posted_by')
            ? parseJson['posted_by']
            : parseJson['posted_date'],
        eventLink: parseJson['link'],
        teacherId: parseJson['teacher_id'],
        schoolId: parseJson.containsKey('school_id')
            ? parseJson['school_id']
            : parseJson['atheltics_school'],
        eventDate: parseJson['event_date'],
        eventTime: parseJson['event_time'],
        eventFlag: parseJson.containsKey('event_id') ? 'event' : 'athletic'
    );
  }
}