import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mallige/Constant/color.dart';
import 'package:mallige/Constant/toast.dart';
import 'package:mallige/Home.dart';
import 'package:mallige/load.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool isloading = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: formkey,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 200),
                      child: Center(
                          child: Image.asset(
                        'assets/images/mallige1.png',
                        //height: 100,
                        width: 280,
                        fit: BoxFit.cover,
                      )),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mobile Number',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          // onChanged: (value) {
                          //   context
                          //       .read<LoginBloc>()
                          //       .add(EmailEvent(value));
                          // },

                          keyboardType: TextInputType.phone,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Please enter Mobilenumber";
                            }

                            return null;
                          },
                          controller: phone,
                          autocorrect: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: green, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: box),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: green, width: 2),
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 24, top: 14, bottom: 13),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Enter your Mobile number",
                              hintStyle:
                                  const TextStyle(color: grey, fontSize: 14),
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: green,
                              )),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: green,
                                minimumSize: const Size.fromHeight(44),
                              ),
                              onPressed: () {
                                setState(() {
                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //     MaterialPageRoute(
                                  //         builder: (BuildContext context) =>
                                  //             MyHomePage()),
                                  //     (Route<dynamic> route) => false);
                                  if (formkey.currentState!.validate()) {
                                    isloading = true;
                                    data();
                                  }
                                });
                              },
                              child: isloading == true
                                  ? Container(
                                      width: 24,
                                      height: 24,
                                      padding: const EdgeInsets.all(2.0),
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
  // void data() async {
  //   var url =
  //       // 'https://irmdesk.com/mcheck.ashx?id=8088868254&mkey=dfgfgfgdfgdfgdfg';
  //       'https://irmdesk.com/mregister.ashx?id=8088868254&mkey=trytryrtytryrtrty';
  //   var data = {
  //     "phone": phone.text,
  //   };
  //   print(data);
  //   var urlparse = Uri.parse(url);
  //   http.Response response = await http.post(
  //     urlparse,
  //     body: data,
  //   );
  //   print(urlparse);
  //   var response_data = json.decode(response.body);
  //   print(response_data);
  //   print(response_data[0]['Status']);
  //   if (response.statusCode == 200) {
  //     if (response_data.isNotEmpty && response_data[0]['Status'] == 1) {
  //       setState(() {
  //         isloading = false;
  //       });
  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
  //         (Route<dynamic> route) => false,
  //       );
  //       print('Success');
  //       toastInfo(mesg: 'Login Successful');
  //     } else {
  //       setState(() {
  //         isloading = false;
  //       });
  //       print('Fail');
  //       toastInfo(mesg: 'Mobile Number Does not Exist');
  //     }
  //   } else {
  //     // Handle other HTTP status codes if needed
  //     print('Error: ${response.statusCode}');
  //     toastInfo(mesg: 'Error: ${response.statusCode}');
  //   }
  // }

  void data() async {
    //bool isLoading = true;
    var mobilenumber = phone.text;
    //String? deviceId = await _getId();
    String? token = await FirebaseMessaging.instance.getToken();
    var url = 'https://ssdesk.in/v2/mcheck.ashx?id=$mobilenumber&mkey=$token';

    var data = {
      "id": phone.text,
      "mkey": token.toString(),
    };
    print(data);
    var urlparse = Uri.parse(url);
    http.Response response = await http.get(
      urlparse,
      //body: data,
    );
    print(urlparse);
    if (response.statusCode == 200) {
      var response_data = json.decode(response.body.toString());
      print(response_data);
      print(response_data[0]['Status']);
      if (int.parse(response_data[0]['Status']) == 1) {
        final session = await SharedPreferences.getInstance();
        await session.setString(
            'status', response_data[0]['Status'].toString());

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Load()),
          (Route<dynamic> route) => false,
        );
        print('Success');
        toastInfo(mesg: 'Login Successful');
      } else {
        setState(() {
          isloading = false;
        });
        print('Fail');
        toastInfo(mesg: 'Mobile Number Does not Exist');
      }
    } else {
      // Handle other HTTP status codes if needed
      print('Error: ${response.statusCode}');
      toastInfo(mesg: 'Error: ${response.statusCode}');
    }
  }

  Future<void> callSecondURL() async {
    var secondUrl =
        'https://malligedesk.com/mregister.ashx?id=8088868254&mkey=trytryrtytryrtrty';
    var secondResponse = await http.get(Uri.parse(secondUrl));
    var secondResponse_data = json.decode(secondResponse.body);
    print(secondResponse_data);
    print(secondResponse_data[0]['Status']);
    if (secondResponse.statusCode == 200) {
      if (secondResponse_data.isNotEmpty &&
          secondResponse_data[0]['Status'] == 1) {
        // Assuming setState is used for UI updates, use it here if needed
        setState(() {
          isloading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
          (Route<dynamic> route) => false,
        );
        print('Success');
        toastInfo(mesg: 'Login Successful');
      } else {
        // Assuming setState is used for UI updates, use it here if needed
        setState(() {
          isloading = false;
        });
        print('Fail');
        toastInfo(mesg: 'Mobile Number Does not Exist');
      }
    } else {
      // Handle other HTTP status codes if needed
      print('Error: ${secondResponse.statusCode}');
      toastInfo(mesg: 'Error: ${secondResponse.statusCode}');
    }
  }

  // Future<String?> _getId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     // import 'dart:io'
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else if (Platform.isAndroid) {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.id; // unique ID on Android
  //   }
  // }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }
}
