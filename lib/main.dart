import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Siemens ACM-200'),
            backgroundColor: Colors.white,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // If the screen width is greater than 600 (desktop)
                return DesktopLayout();
              } else {
                // Otherwise, display the ACM panel
                return ACM200Panel();
              }
            },
          ),
          backgroundColor: Colors.grey.shade700),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey, // Set the entire desktop layout background to white
      child: Center(
        child: Container(
          width: 400, // Set desired width
          height: 600, // Set desired height
          child:
              ACM200Panel(), // ACM200Panel will have its own background color
        ),
      ),
    );
  }
}

class ClearButton extends StatelessWidget {
  final VoidCallback handleClear;

  ClearButton({required this.handleClear});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: handleClear,
      child: Text('Clear'),
    );
  }
}

class ACM200Panel extends StatefulWidget {
  @override
  _ACM200PanelState createState() => _ACM200PanelState();
}

class _ACM200PanelState extends State<ACM200Panel> {
  final stateMap = {
    'RST': ['null'],
    'OK': [
      'null',
      'steady red',
      'flashing red',
      'flashing green',
      'steady green',
    ],
    'TVDS1': ['null', 'steady red', 'flashing red', 'flashing green'],
    'TVDS2': [
      'null',
      'steady red',
      'flashing green',
      'flashing red',
      'flashing yellow',
    ],
    'DS1.1': [
      'null',
      'steady red',
      'steady yellow',
      'flashing green',
      'flashing red',
      'flashing yellow',
    ],
    'DS1.2': [
      'null',
      'steady red',
      'steady yellow',
      'flashing green',
      'flashing red',
      'flashing yellow',
    ],
    'DS2.1': [
      'null',
      'steady red',
      'steady yellow',
      'flashing green',
      'flashing red',
      'flashing yellow',
    ],
    'DS2.2': [
      'null',
      'steady red',
      'steady yellow',
      'flashing green',
      'flashing red',
      'flashing yellow',
    ],
    'RR1': ['null', 'flashing red', 'steady green', 'steady red'],
    'RR2': ['null', 'flashing red', 'steady green', 'steady red'],
    'COM': ['null', 'flashing red', 'steady yellow'],
    'RST-RR1': ['null', 'flashing red', 'steady red', 'steady green'],
    'RST-RR2': ['null', 'flashing red', 'steady red', 'steady green'],
    'CAL': ['null', 'flashing red'],
    'DIR1': ['null', 'flashing red'],
    'DIR2': ['null', 'flashing red'],
    'SIM1': ['null'],
    'SIM2': ['null'],
    'F1': ['null'],
    'F2': ['null'],
  };

  Map<String, String?> selectedStates = {};
  late Timer timer;
  bool isLightOn = false;

  @override
  void initState() {
    super.initState();
    selectedStates = {for (var key in stateMap.keys) key: 'null'};
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      setState(() {
        isLightOn = !isLightOn;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void handleClear() {
    setState(() {
      selectedStates = {for (var key in stateMap.keys) key: 'null'};
    });
  }

  void handleSubmit() {
    // Get the selected states
    String okState = selectedStates['OK']!;
    String tvds1State = selectedStates['TVDS1']!;
    String tvds2State = selectedStates['TVDS2']!;
    String tvds2State1 = selectedStates['DS1.1']!;
    String tvds2State2 = selectedStates['DS1.2']!;
    String tvds2State3 = selectedStates['DS2.1']!;
    String tvds2State4 = selectedStates['DS2.2']!;
    String tvds2State5 = selectedStates['RR1']!;
    String tvds2State6 = selectedStates['RR2']!;
    String tvds2State7 = selectedStates['COM']!;
    String tvds2State8 = selectedStates['CAL']!;
    String tvds2State9 = selectedStates['DIR1']!;
    String tvds2State10 = selectedStates['DIR2']!;

    // Concatenate the states into a single variable
    String combinedStates =
        '$okState-$tvds1State-$tvds2State-$tvds2State1-$tvds2State2-$tvds2State3-$tvds2State4-$tvds2State5-$tvds2State6-$tvds2State7-$tvds2State8-$tvds2State9-$tvds2State10';

    switch (combinedStates) {
      case 'flashing green-null-null-null-null-null-null-null-null-null-null-null-null':
        showMessageDialog('Configuration acceptance mode',
            'https://drive.google.com/file/d/1YCMSu9hkKTb4g8J2K6wOYbicWgtHoW-5/view?usp=sharing');
        break;
      case 'steady red-null-null-null-null-null-null-null-null-null-null-null-null':
        showMessageDialog('ACM has failed ',
            'https://drive.google.com/file/d/1G_mbrOUS_oGah8s1taSGGqWmumkXgMsD/view?usp=sharing');
        break;
      case 'steady red-flashing red-flashing red-flashing red-flashing red-flashing red-flashing red-flashing red-flashing red-flashing red-flashing red-flashing red-flashing red':
        showMessageDialog('ID plug missing or faulty',
            'https://drive.google.com/file/d/1wXbX7bz95Jws9psCbZASuOn1Z0hVr1as/view?usp=sharing');
        break;
      case 'null-flashing green-flashing green-null-null-null-null-null-null-null-null-null-null':
      case 'null-flashing green-flashing yellow-null-null-null-null-null-null-null-null-null-null':
      case 'null-flashing yellow-flashing green-null-null-null-null-null-null-null-null-null-null':
      case 'null-flashing yellow-flashing yellow-null-null-null-null-null-null-null-null-null-null':
        showMessageDialog('Oscillation tolerance exceeded',
            'https://drive.google.com/file/d/1--ZoP50Ys7bGLKjKUnUKJFKJOW-6Pckr/view?usp=drive_link');
        break;

      case 'null-null-null-null-null-null-null-null-null-null-null-null-null':
        showMessageDialog('Power supply module has failed',
            'https://drive.google.com/file/d/1OMbe-ZWzxOBmZ0_XzllOftZMm6xfK2yl/view?usp=sharing');
        break;
      case 'null-steady red-steady red-null-null-null-null-null-null-null-null-null-null':
        showMessageDialog('TVDS permanently occupied',
            'https://drive.google.com/file/d/1T8vwKQK3vCsI19YeQEG5VcIeb6nZv72v/view?usp=sharing');
        break;
      case 'null-flashing red-flashing red-null-null-null-null-null-null-null-null-null-null':
        showMessageDialog('TVDS faulty ',
            'https://drive.google.com/file/d/1qZB7oZz6K-fdqWcWl7W7uwbL8pbLa9Nx/view?usp=sharing');
        break;
      case 'flashing red-null-null-null-null-null-null-null-null-null-flashing red-flashing red-flashing red':
        showMessageDialog('CAL or DIR faulty',
            'https://drive.google.com/file/d/1UWd7KYcittayNg44iHbQZ25KD6bq3oLN/view?usp=drive_link');
        break;
      case 'null-null-null-null-null-null-null-null-null-null-steady red-null-null':
        showMessageDialog('WDE not calibrated',
            'https://drive.google.com/file/d/1jiBBOjg-dkRCG0oWK5rJkvq7Q1GKqfeN/view?usp=drive_link');
        break;
      case 'flashing red-null-null-null-null-null-null-null-null-flashing red-null-null-null':
        showMessageDialog('Ethernet connection interrupted',
            'https://drive.google.com/file/d/1NZdKkW_0aJw3JJlHhDvpVnwb3EumRSYk/view?usp=drive_link');
        break;
      case 'flashing red-null-null-null-null-null-null-null-null-steady yellow-null-null-null':
        showMessageDialog('Connection to partner ACM has failed ',
            'https://drive.google.com/file/d/1XweaG9NPvHtyzu9I4SPDIU_MlqxUIg3-/view?usp=drive_link');
        break;
      case 'null-flashing red-flashing red-null-null-null-null-steady green-steady green-null-null-null-null':
        showMessageDialog('SRI has failed',
            'https://drive.google.com/file/d/1fyOiD_zhg_N5JzCIjpf2of4FvjRgbHgh/view?usp=sharing');
        break;
      case 'null-null-null-null-null-null-null-steady red-flashing red-null-null-null-null':
      case 'null-null-null-null-null-null-null-flashing red-steady red-null-null-null-null':
      case 'null-null-null-null-null-null-null-steady red-steady red-null-null-null-null':
      case 'null-null-null-null-null-null-null-flashing red-flashing red-null-null-null-null':
        showMessageDialog('Button Fault',
            'https://drive.google.com/file/d/19uWNEldXy24XlE1MMRBPIb6DvNdFpvwR/view?usp=sharing');
        break;
      case 'null-null-null-steady red-steady red-steady red-steady red-null-null-null-null-null-null':
        showMessageDialog('WDE or cable faulty',
            'https://drive.google.com/file/d/1xkJQV9JVuxcAt2eeMN0ofs0a28ZBmgr_/view?usp=sharing');
        break;
      case ' null-null-null-flashing green-flashing green-flashing green-flashing green-null-null-null-null-null-null':
      case 'null-null-null-flashing green-flashing green-flashing green-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing green-flashing green-flashing yellow-flashing green-null-null-null-null-null-null':
      case 'null-null-null-flashing green-flashing green-flashing yellow-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing green-flashing yellow-flashing green-flashing green-null-null-null-null-null-null':
      case 'null-null-null-flashing green-flashing yellow-flashing green-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing green-flashing yellow-flashing yellow-flashing green-null-null-null-null-null-null':
      case 'null-null-null-flashing green-flashing yellow-flashing yellow-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing green-flashing green-flashing green-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing green-flashing green-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing green-flashing yellow-flashing green-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing green-flashing yellow-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing yellow-flashing green-flashing green-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing yellow-flashing green-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing yellow-flashing yellow-flashing green-null-null-null-null-null-null':
        showMessageDialog('WDE faulty',
            'https://drive.google.com/file/d/10JvFPTZl702k9kqGkwekU7buVUNO8QDK/view?usp=sharing');
        break;
      case 'null-null-null-steady yellow-steady yellow-steady yellow-steady yellow-null-null-null-null-null-null':
      case 'null-null-null-steady yellow-steady yellow-steady yellow-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-steady yellow-steady yellow-flashing yellow-steady yellow-null-null-null-null-null-null':
      case 'null-null-null-steady yellow-steady yellow-flashing yellow-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-steady yellow-flashing yellow-steady yellow-steady yellow-null-null-null-null-null-null':
      case 'null-null-null-steady yellow-flashing yellow-steady yellow-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-steady yellow-flashing yellow-flashing yellow-steady yellow-null-null-null-null-null-null':
      case 'null-null-null-steady yellow-flashing yellow-flashing yellow-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-steady yellow-steady yellow-steady yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-steady yellow-steady yellow-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-steady yellow-flashing yellow-steady yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-steady yellow-flashing yellow-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing yellow-steady yellow-steady yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing yellow-steady yellow-flashing yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing yellow-flashing yellow-steady yellow-null-null-null-null-null-null':
      case 'null-null-null-flashing yellow-flashing yellow-flashing yellow-flashing yellow-null-null-null-null-null-null':
        showMessageDialog('Fuse Faulty',
            'https://drive.google.com/file/d/1gHkl0gPH-LvqQLVusLjGUmoJBF1ZW4S7/view?usp=sharing');
        break;
      default:
        String errorMessage = 'Unhandled state combination: $combinedStates';
        print('Exception occurred: $errorMessage');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        break;
    }
  }

  void showMessageDialog(String message, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                redirectToURL(url);
              },
              child: Text('Open Link'),
            ),
          ],
        );
      },
    );
  }

  void redirectToURL(String url) async {
    print('Redirecting to: $url');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Color getButtonColor(String? state) {
    if (state == 'flashing red' && isLightOn) {
      return Colors.red;
    } else if (state == 'flashing green' && isLightOn) {
      return Colors.green;
    } else if (state == 'flashing yellow' && isLightOn) {
      return Colors.yellow;
    } else {
      switch (state) {
        case 'steady red':
          return Colors.red;
        case 'steady green':
          return Colors.green;
        case 'steady yellow':
          return Colors.yellow;
        case 'null': // Handle null state
          return Colors.white;
        default:
          return Colors.grey;
      }
    }
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 8),
            buildLabel('SIEMENS', alignment: Alignment.center),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 9.0, left: 9.0),
                child: Container(
                  width: 130,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 115,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          'ID PLUG',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      for (var indicator in stateMap.keys.take(13))
                        buildIndicatorRow(indicator),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      for (var indicator in stateMap.keys.skip(13).take(7))
                        buildIndicatorRow(indicator),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'ACM-200',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: handleSubmit,
              child: Text('Submit'),
            ),
            SizedBox(height: 8.0),
            ClearButton(handleClear: handleClear),
            SizedBox(height: 8),
            Container(
              width: 50,
              height: 1,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String label,
      {Alignment alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildIndicatorRow(String indicator) {
    // Check if the indicator is a fuse indicator
    bool isFuseIndicator =
        indicator == 'RST-RR1' || indicator == 'RST-RR2' || indicator == 'RST';

    if (isFuseIndicator) {
      // If it's a fuse indicator, return the fuse indicator row
      return buildrstRow(indicator);
    } else if (indicator == 'SIM1' || indicator == 'SIM2') {
      // If it's SIM1 or SIM2, return the SIM row
      return buildSimRow(indicator);
    } else if (indicator == 'F1' || indicator == 'F2') {
      // If it's F1 or F2, return the fuse icon row
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: buildFuseIcon(),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 7,
              child: Text(
                '$indicator 0,2 A',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    } else {
      // Otherwise, return the circle avatar row
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => showDropdownMenu(context, indicator),
                child: CircleAvatar(
                  backgroundColor: getButtonColor(selectedStates[indicator]),
                  radius: 10,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 7,
              child: Text(
                indicator,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget buildrstRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          buildSmallCircle(),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildSimRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          buildSmallCircle(),
          buildSmallCircle(),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildSmallCircle() {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget buildFuseIcon() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Center(
            child: Transform.rotate(
              angle: 0.785398, // 45 degrees in radians
              child: Container(
                width: 2,
                height:
                    28, // Slightly larger than the container to ensure it spans across the circle
                color: Colors.black,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDropdownMenu(BuildContext context, String indicator) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                value: selectedStates[indicator],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStates[indicator] = newValue;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
                items: stateMap[indicator]!.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ).toList(),
              );
            },
          ),
        );
      },
    ).then((_) {
      // Update the state after the dialog is closed
      setState(() {});
    });
  }
}
