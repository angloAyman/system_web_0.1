import 'package:flutter/material.dart';
import 'package:system/main.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({Key? key}) : super(key: key);

  @override
  TimeScreenState createState() => TimeScreenState();
}

class TimeScreenState extends State<TimeScreen> {
  String timeIn = '', timeOut = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30.0),
              Row(
                children:  [
                  ElevatedButton.icon(onPressed: (){
                    Navigator.pop(context);
                  }, label: Text(' Mobile'),),
                  Text(
                    'Atendance',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.flutter_dash,
                        size: 40.0,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                '[Display Name]',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 32.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Time In',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  timeIn.isEmpty ? '--/--' : timeIn,
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Time Out',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  timeOut.isEmpty ? '--/--' : timeIn,
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              const Center(
                child: Text(
                  'Time Time Widget',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 45.0,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orange),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          color: Colors.orange,
                          style: BorderStyle.solid,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Time In',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () => createStartTime(),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 45.0,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orange),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          color: Colors.orange,
                          style: BorderStyle.solid,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Time Out',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () => createEndTime(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createStartTime() {
    /** Implement your logic to save time data */
    setState(() {
      timeIn = TimeOfDay.now().format(context);
    });
  }

  createEndTime() {
    /** Implement your logic to save time data */
    setState(() {
      timeOut = TimeOfDay.now().format(context);
    });
  }
}