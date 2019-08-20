import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klassmind/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceSheet extends StatelessWidget {
  final studentCollection = Firestore.instance
      .collection('classes')
      .document('sk1100')
      .collection('students');
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: studentCollection.snapshots(),
      child: Consumer<QuerySnapshot>(
        builder: (BuildContext context, snapshot, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Class 1a'),
            ),
            body: SafeArea(
              child: snapshot?.documents == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: StudentColumn(
                            studentCollection: studentCollection,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class StudentColumn extends StatelessWidget {
  const StudentColumn({
    Key key,
    @required this.studentCollection,
  }) : super(key: key);

  final CollectionReference studentCollection;

  @override
  Widget build(BuildContext context) {
    final snapshot = Provider.of<QuerySnapshot>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        snapshot.documents.length,
        (index) {
          final String studentId = snapshot.documents[index].documentID;
          final String names = snapshot.documents[index].data['name'];
          return Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => StudentProfile()));
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black)),
                      color: Colors.blue),
                  child: FittedBox(
                    child: Column(
                      children: [
                        Icon(Icons.account_circle),
                        Text(names),
                      ],
                    ),
                  ),
                ),
              ),
              ...List.generate(1, (buttonIndex) {
                final studentAttendance = studentCollection
                    .document(studentId)
                    .collection('lessons')
                    .document('2019-08-18');
                // final newDocLocation = Firestore.instance.collection(
                //     'organisations/citc/terms/aug-oct-2019/skpl/sun-1100-sc/classes/2019-08-18/students');
                return StreamBuilder<DocumentSnapshot>(
                    stream: studentAttendance.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      final isPresent = snapshot.data.data['present'];
                      final data = snapshot.data.data;
                      return Container(
                        width: 50,
                        child: Checkbox(
                          onChanged: (bool value) {
                            return studentAttendance
                                .setData({'present': !isPresent});
                          },
                          value: isPresent,
                        ),
                      );
                    });
              })
            ],
          );
        },
      ),
    );
  }
}
