import 'package:flutter/material.dart';

class StepperPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประวัติกิจกรรมขาย',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                    child: Text(
                  'วันที่ 17-06-2021',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
              ),
            ],
          ),
          Divider(
            height: 5,
          ),
          // Theme(
          //   data: ThemeData(primaryColor: Colors.orangeAccent),
          //   child: Stepper(
          //     controlsBuilder: (BuildContext context,
          //         {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          //       return Text('');
          //       // return Row(
          //       //     children: <Widget>[
          //       //       FlatButton(
          //       //         onPressed: onStepContinue,
          //       //         child: const Text('Weiter',
          //       //             style: TextStyle(color: Colors.white)),
          //       //         color: Colors.blue,
          //       //       ),
          //       //       new Padding(
          //       //         padding: new EdgeInsets.all(10),
          //       //       ),
          //       //       FlatButton(
          //       //         onPressed: onStepCancel,
          //       //         child: const Text(
          //       //           'Zurück',
          //       //           style: TextStyle(color: Colors.white),
          //       //         ),
          //       //         color: Colors.blue,
          //       //       ),
          //       //     ],
          //       //   );
          //     },
          //     currentStep: _index,
          //     onStepCancel: () {
          //       if (_index > 0) {
          //         setState(() {
          //           _index -= 1;
          //         });
          //       }
          //     },
          //     onStepContinue: () {
          //       if (_index <= 0) {
          //         setState(() {
          //           _index += 1;
          //         });
          //       }
          //     },
          //     onStepTapped: (int index) {
          //       setState(() {
          //         _index = index;
          //       });
          //     },
          //     steps: <Step>[
          //       Step(
          //         title: const Text('เจ้าหน้าที่สร้างใบเบิกขั้นรถ',
          //             style: TextStyle(fontSize: 16)),
          //         subtitle: Text(
          //           '18:34',
          //           style: TextStyle(fontSize: 12),
          //         ),
          //         content: Container(
          //             alignment: Alignment.centerLeft, child: const Text('')),
          //       ),
          //       const Step(
          //         title: Text('พนักงานรับของขึ้นรถ',
          //             style: TextStyle(fontSize: 16)),
          //         subtitle: Text(
          //           '19:04',
          //           style: TextStyle(fontSize: 12),
          //         ),
          //         content: Text(''),
          //       ),
          //       const Step(
          //         isActive: true,
          //         title: Text('จบการขาย', style: TextStyle(fontSize: 16)),
          //         subtitle: Text(
          //           '23:25',
          //           style: TextStyle(fontSize: 12),
          //         ),
          //         content: Text(''),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
