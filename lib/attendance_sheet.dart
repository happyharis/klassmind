import 'package:klassmind/student_profile.dart';
import 'package:flutter/material.dart';

class AttendanceSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class 1a'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  15,
                  (index) => Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    StudentProfile())),
                        child: Container(
                          width: 50,
                          height: 50,
                          color:
                              (index != 0) ? Colors.blue : Colors.transparent,
                          child: Row(
                            children: [
                              if (index != 0) Text(index.toString()),
                              if (index != 0) Icon(Icons.account_circle)
                            ],
                          ),
                        ),
                      ),
                      ...List.generate(
                          6,
                          (buttonIndex) => Container(
                                width: 50,
                                child: index != 0
                                    ? Radio(
                                        groupValue: null,
                                        onChanged: (Null value) {},
                                        value: null,
                                      )
                                    : Text(
                                        '${buttonIndex.toString()}/4',
                                        textAlign: TextAlign.center,
                                      ),
                              ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
