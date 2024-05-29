import 'dart:async';
//import 'dart:js_interop';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mechprojectdcm/utils/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

String serial = '';
bool isLoading = false;
double temperature = 30;
double newTemp = 30;
double pwm = 50, newpwm = 50;
double voltage = 0,
    rpm = 0,
    rps = 0,
    dtorque = 0,
    power = 0,
    eff = 0,
    damp = 0,
    resis = 0,
    ka = 0,
    kr = 0,
    inductance = 0,
    jm = 0,
    readTemp = 0,
    current = 0,
    maxRPM = 0,
    maxCurrent = 0,
    maxPower = 0,
    maxEff = 0,
    maxTorque = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController sliderController = TextEditingController();
  TextEditingController controller = TextEditingController();

  // ignore: unused_field
  late String _now;
  late Timer _everySecond;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    sliderController = TextEditingController();
    checkSerial(serial);
    if (serial != '') {
      getVars(serial);
      checkMax();
    }
    _now = DateTime.now().second.toString();

    // defines a timer
    _everySecond =
        Timer.periodic(const Duration(milliseconds: 1000), (Timer t) {
      setState(() {
        _now = DateTime.now().second.toString();
        checkSerial(serial);
        if (serial != '') {
          getVars(serial);
          checkMax();
        }
      });
    });
  }

  @override
  void dispose() {
    _everySecond.cancel();
    super.dispose();
  }

  //final db = FirebaseFirestore.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  //final Stream<QuerySnapshot> _dataStream =
  //    FirebaseFirestore.instance.collection('vars').snapshots();

  @override
  Widget build(BuildContext context) {
    // getLiveData();
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome to Group 3's",
                            style: Styles.headlineStyle3),
                        const Gap(5),
                        Text("DC Motor Test Stand App",
                            style: Styles.headlineStyle1)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20.0),
                labelText: "Serial Number",
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              onSubmitted: (String value) async {
                setState(() {
                  serial = controller.text;
                  createSerial(name: serial);
                  getVars(serial);
                  checkMax();
                });
              },
            ),
          ),
          // StreamBuilder(
          //     stream: readUsers(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasError) {
          //         return Text("Snapshot Error: ${snapshot.error}");
          //       } else if (snapshot.hasData) {
          //         final users = snapshot.data!;

          //         return ListView(
          //           children: users.map(buildUser).toList(),
          //         );
          //       } else {
          //         return const Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }
          //     }),
          const Gap(10),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                serial,
                style: Styles.headlineStyle3,
              )),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Motor Specs & Live Data:',
                style: Styles.headlineStyle1,
              )),
          const Gap(15),
          const Gap(15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Voltage: ${voltage.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                Row(
                  children: [
                    Text("Current: ${current.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                Row(
                  children: [
                    Text("RPM: ${rpm.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                Row(
                  children: [
                    Text("Torque (Dynamic): ${dtorque.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                Row(
                  children: [
                    Text("Power: ${power.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                Row(
                  children: [
                    Text("Efficency (%): ${eff.toStringAsFixed(1)} %",
                        style: Styles.headlineStyle2),
                  ],
                ),
                const Gap(10),
                Row(
                  children: [
                    Text("Constants: ", style: Styles.headlineStyle1),
                  ],
                ),
                Row(
                  children: [
                    Text("Damping: ${damp.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                Row(
                  children: [
                    Text("Resistance: ${resis.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                Row(
                  children: [
                    Text("Ka: ${ka.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                Row(
                  children: [
                    Text("Kr: ${kr.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                Row(
                  children: [
                    Text("Inductance: ${inductance.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                Row(
                  children: [
                    Text("Jm: ${jm.toStringAsFixed(1)} ",
                        style: Styles.headlineStyle2),
                  ],
                ),
                const Gap(20),
                Row(
                  children: [
                    Text("Temperature: ", style: Styles.headlineStyle2),
                    Text("${readTemp.toStringAsFixed(1)} C",
                        style: Styles.textStyle),
                  ],
                ),
                Row(
                  children: [
                    Text("Target Temperature: ", style: Styles.headlineStyle2),
                    Text(
                      temperature.toStringAsFixed(1),
                      style: Styles.textStyle,
                    )
                  ],
                ),
                Slider(
                    value: temperature,
                    onChanged: (newTemp) {
                      setState(() {
                        temperature = newTemp;
                      });
                      if (serial != "") {
                        final docUser =
                            FirebaseDatabase.instance.ref('vars/$serial');
                        docUser.update({'TempTarget': newTemp});
                      }
                    },
                    min: 0,
                    max: 100),
                Row(
                  children: [
                    Text("PWM Duty Cycle: ", style: Styles.headlineStyle2),
                    Text(
                      "${pwm.toStringAsFixed(1)} %",
                      style: Styles.textStyle,
                    )
                  ],
                ),
                Slider(
                    value: pwm,
                    onChanged: (newpwm) {
                      setState(() {
                        pwm = newpwm;
                      });
                      if (serial != "") {
                        final docUser =
                            FirebaseDatabase.instance.ref('vars/$serial');
                        docUser.update({'PWM': newpwm});
                      }
                    },
                    min: 0,
                    max: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future writeToDB() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("vars/$serial");

  await ref.set({
    "name": "John",
    "age": 18,
    "address": {"line1": "100 Mountain View"}
  });
}

// Widget buildUser(User user) => ListTile(
//       leading: CircleAvatar(child: Text('${user.dTorque}')),
//       title: Text(user.id),
//       subtitle: Text('${user.rPM}'),
//     );

// Stream<List<User>> readUsers() =>
//     FirebaseFirestore.instance.collection('vars').snapshots().map((snapshot) =>
//         snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

Future createSerial({required String name}) async {
  // Referance to document
  final docUser = FirebaseDatabase.instance.ref('vars/$name');
  // final SharedPreferences prefs = await SharedPreferences.getInstance();

  final user = User(
    id: name,
    dTorque: 0,
    damping: 0,
    efficiency: 0,
    inductance: 0,
    jm: 0,
    ka: 0,
    kr: 0,
    power: 0,
    rPM: 0,
    rPS: 0,
    resistance: 0,
    current: 0,
    tempRead: 0,
    tempTarget: 30,
    voltage: 0,
    pwm: 50,
  );
  final json = user.toJson();

  // Create Doc and Write Data
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // try {
  //   await docUser.set(json);
  //   await prefs.setString('serialKey', name);
  // } catch (e) {
  //   getVars(name);
  //
  // }
  if (name == prefs.getString('serialKey')) {
    getVars(name);
    checkMax();
  } else {
    await docUser.set(json);
    await prefs.setString('serialKey', name);
  }
}

class User {
  String id;
  double dTorque,
      damping,
      efficiency,
      inductance,
      jm,
      ka,
      kr,
      power,
      rPM,
      rPS,
      resistance,
      current,
      tempRead,
      tempTarget,
      pwm,
      voltage;

  User(
      {required this.id,
      required this.dTorque,
      required this.damping,
      required this.efficiency,
      required this.inductance,
      required this.jm,
      required this.ka,
      required this.kr,
      required this.power,
      required this.rPM,
      required this.rPS,
      required this.resistance,
      required this.current,
      required this.tempRead,
      required this.tempTarget,
      required this.pwm,
      required this.voltage});

  Map<String, dynamic> toJson() => {
        'id': id,
        'DTorque': dTorque,
        'Damping': damping,
        'Efficiency': efficiency,
        'Inductance': inductance,
        'Jm': jm,
        'Ka': ka,
        'Kr': kr,
        'Power': power,
        'RPM': rPM,
        'RPS': rPS,
        'Resistance': resistance,
        'Current': current,
        'TempRead': tempRead,
        'TempTarget': tempTarget,
        'Voltage': voltage,
        'PWM': pwm
      };

  static User fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      dTorque: json['DTorque'],
      damping: json['Damping'],
      efficiency: json['Efficiency'],
      inductance: json['Inductance'],
      jm: json['Jm'],
      ka: json['Ka'],
      kr: json['Kr'],
      power: json['Power'],
      rPM: json['RPM'],
      rPS: json['RPS'],
      resistance: json['Resistance'],
      current: json['Current'],
      tempRead: json['TempRead'],
      tempTarget: json['TempTarget'],
      voltage: json['Voltage'],
      pwm: json['PWM']);
}

Future getVars(String documentId) async {
  final db = FirebaseDatabase.instance;
  final docRef = db.ref("vars/$documentId");
  final voltsRef = await docRef.child('Voltage').get();
  final rpmRef = await docRef.child('RPM').get();
  final rpsRef = await docRef.child('RPS').get();
  final dtRef = await docRef.child('DTorque').get();
  final curRef = await docRef.child('Current').get();
  final powRef = await docRef.child('Power').get();
  final efRef = await docRef.child('Efficiency').get();
  final dampRef = await docRef.child('Damping').get();
  final resRef = await docRef.child('Resistance').get();
  final kaRef = await docRef.child('Ka').get();
  final krRef = await docRef.child('Kr').get();
  final indRef = await docRef.child('Inductance').get();
  final jmRef = await docRef.child('Jm').get();
  final rtRef = await docRef.child('TempRead').get();

  //final data = doc.data() as Map<String, dynamic>;
  try {
    voltage = double.parse(voltsRef.value.toString());
    rpm = double.parse(rpmRef.value.toString());
    rps = double.parse(rpsRef.value.toString());
    dtorque = double.parse(dtRef.value.toString());
    current = double.parse(curRef.value.toString());
    power = double.parse(powRef.value.toString());
    eff = double.parse(efRef.value.toString());
    damp = double.parse(dampRef.value.toString());
    resis = double.parse(resRef.value.toString());
    ka = double.parse(kaRef.value.toString());
    kr = double.parse(krRef.value.toString());
    inductance = double.parse(indRef.value.toString());
    jm = double.parse(jmRef.value.toString());
    readTemp = double.parse(rtRef.value.toString());
  } catch (e) {
    //print("Still Loading DB...");
  }
}

Future checkSerial(String serial) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? serialSP = prefs.getString('serialKey');
  if (serialSP != null) serial = serialSP;
}

Future checkMax() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (dtorque > maxTorque) {
    maxTorque = dtorque;
    await prefs.setDouble('maxTorque', maxTorque);
  }
  if (current > maxCurrent) {
    maxCurrent = current;
    await prefs.setDouble('maxCurrent', maxCurrent);
  }
  if (rpm > maxRPM) {
    maxRPM = rpm;
    await prefs.setDouble('maxRPM', maxRPM);
  }
  if (eff > maxEff) {
    maxEff = eff;
    await prefs.setDouble('maxEff', maxEff);
  }
  if (power > maxPower) {
    maxPower = power;
    await prefs.setDouble('maxEff', maxPower);
  }
}

// Future getLiveData() async {
//   final voltRef =
//       FirebaseDatabase.instance.ref('vars/$serial/Voltage').get();
//     final data = voltRef.snapshot.value.toString();
//     voltage = double.parse(data);

//   DatabaseReference rpmRef = FirebaseDatabase.instance.ref('vars/$serial/RPM');
//   rpmRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     rpm = double.parse(data);
//   });
//   DatabaseReference rpsRef = FirebaseDatabase.instance.ref('vars/$serial/RPS');
//   rpsRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     rps = double.parse(data);
//   });
//   DatabaseReference dtRef =
//       FirebaseDatabase.instance.ref('vars/$serial/DTorque');
//   dtRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     dtorque = double.parse(data);
//   });
//   DatabaseReference curRef =
//       FirebaseDatabase.instance.ref('vars/$serial/Current');
//   curRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     current = double.parse(data);
//   });
//   DatabaseReference powRef =
//       FirebaseDatabase.instance.ref('vars/$serial/Power');
//   powRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     power = double.parse(data);
//   });
//   DatabaseReference efRef =
//       FirebaseDatabase.instance.ref('vars/$serial/Efficiency');
//   efRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     eff = double.parse(data);
//   });
//   DatabaseReference dampRef =
//       FirebaseDatabase.instance.ref('vars/$serial/Damping');
//   dampRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     damp = double.parse(data);
//   });
//   DatabaseReference resRef =
//       FirebaseDatabase.instance.ref('vars/$serial/Resistance');
//   resRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     resis = double.parse(data);
//   });
//   DatabaseReference kaRef = FirebaseDatabase.instance.ref('vars/$serial/Ka');
//   kaRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     ka = double.parse(data);
//   });
//   DatabaseReference krRef = FirebaseDatabase.instance.ref('vars/$serial/Kr');
//   krRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     kr = double.parse(data);
//   });
//   DatabaseReference indRef =
//       FirebaseDatabase.instance.ref('vars/$serial/Inductance');
//   indRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     inductance = double.parse(data);
//   });
//   DatabaseReference jmRef = FirebaseDatabase.instance.ref('vars/$serial/Jm');
//   jmRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     jm = double.parse(data);
//   });
//   DatabaseReference rtRef =
//       FirebaseDatabase.instance.ref('vars/$serial/TempRead');
//   rtRef.onValue.listen((event) {
//     final data = event.snapshot.value.toString();
//     readTemp = double.parse(data);
//   });
// }
