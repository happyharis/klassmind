import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klassmind/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: Firestore.instance
          .collection('classes')
          .document('sk1100')
          .collection('students')
          .snapshots(),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              snapshot.documents.length,
                              (index) {
                                final String names =
                                    snapshot.documents[index].data['name'];
                                return Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  StudentProfile())),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.black)),
                                          color: (index != 0)
                                              ? Colors.blue
                                              : Colors.transparent,
                                        ),
                                        child: FittedBox(
                                          child: Column(
                                            children: [
                                              if (index != 0)
                                                Icon(Icons.account_circle),
                                              if (index != 0) Text(names),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    ...List.generate(
                                        1,
                                        (buttonIndex) => Container(
                                              width: 50,
                                              child: index != 0
                                                  ? Radio(
                                                      groupValue: null,
                                                      onChanged:
                                                          (Null value) {},
                                                      value: null,
                                                    )
                                                  : Text(
                                                      '${buttonIndex.toString()}/4',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                            ))
                                  ],
                                );
                              },
                            ),
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
