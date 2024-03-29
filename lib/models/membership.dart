import 'package:cloud_firestore/cloud_firestore.dart';

class Membership {
  String? id;
  DateTime dateOfStart;
  DateTime dateOfEnd;
  int numberOfVisits;
  int visitCounter;
  String userId;
  DateTime creationDate;

  Membership({
    this.id,
    required this.dateOfStart,
    required this.dateOfEnd,
    required this.numberOfVisits,
    required this.visitCounter,
    required this.userId,
    required this.creationDate,
  });

  factory Membership.fromDocument(DocumentSnapshot doc) {
    return Membership(
        id: doc.id,
        dateOfStart: doc.data().toString().contains('dateOfStart') ? DateTime.fromMillisecondsSinceEpoch(doc.get('dateOfStart')) : DateTime.now(),
        dateOfEnd: doc.data().toString().contains('dateOfEnd') ? DateTime.fromMillisecondsSinceEpoch(doc.get('dateOfEnd')) : DateTime.now(),
        numberOfVisits: doc.data().toString().contains('numberOfVisits') ? doc.get('numberOfVisits') : 0,
        visitCounter: doc.data().toString().contains('visitCounter') ? doc.get('visitCounter') : 0,
        userId: doc.data().toString().contains('userId') ? doc.get('userId') : '',
        creationDate: doc.data().toString().contains('creationDate') ? DateTime.fromMillisecondsSinceEpoch(doc.get('creationDate')) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'dateOfStart': dateOfStart.millisecondsSinceEpoch,
    'dateOfEnd': dateOfEnd.millisecondsSinceEpoch,
    'numberOfVisits': numberOfVisits,
    'visitCounter': visitCounter,
    'creationDate': creationDate.millisecondsSinceEpoch,
  };

  @override
  String toString() {
    return 'Membership{id: $id, dateOfStart: $dateOfStart,'
        ' dateOfEnd: $dateOfEnd, numberOfVisits: $numberOfVisits,'
        ' visitCounter: $visitCounter, userId: $userId,'
        ' creationDate: $creationDate}';
  }
}
