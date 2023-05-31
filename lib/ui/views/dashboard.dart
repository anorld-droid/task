import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task/domain/custom/notification_services.dart';
import 'package:task/domain/firebase/auth_methods.dart';
import 'package:task/domain/use_cases/user_model.dart';
import 'package:task/models/user.dart';
import 'package:task/ui/views/login_screen.dart';
import 'package:task/ui/widgets/follow_button.dart';
import 'package:task/ui/widgets/text_field_input.dart';
import 'package:task/utils/colors.dart';
import 'package:task/utils/constants.dart';
import 'package:task/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.

class Dashboard extends StatefulWidget {
  final String uid;
  const Dashboard({Key? key, required this.uid}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // initialize notification services
  NotificationServices notificationServices = NotificationServices();
  final TextEditingController _messageController = TextEditingController();

  TaskUser? userData;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
    // permission function call
    notificationServices.requestFirebasePermission();

    // firebase message listen
    notificationServices.firebaseInitialize(context);

    // message show in terminate / background state
    notificationServices.setUpInteractMessage(context);

    // device token function call
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  @override
  void dispose() {
    //dispose the controllers
    super.dispose();
    _messageController.dispose();
  }

  void sendNotification() {
    // get token
    notificationServices.getDeviceToken().then((value) async {
      var data = {
        'to': value.toString(),
        'priority': 'high',
        // notification
        'notification': {
          'title': 'Notification',
          'body': _messageController.text
        },
        // payload
        'data': {
          'type': 'message',
          'id': '123456',
          'name': 'Talha',
          'status': 'false',
        }
      };

      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Authorization': 'key=${Constants.serverKey}',
          });
    });
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await UserUseCase().get(widget.uid);
      //get post length
      userData = userSnap!;
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> displayMessageBox(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Notification Message'),
            content: TextFieldInput(
              hintText: "Enter your message",
              textInputType: TextInputType.text,
              textEditingController: _messageController,
            ),
            actions: <Widget>[
              MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    sendNotification();
                    Navigator.pop(context);
                  },
                  child: const Text('SEND')),
            ],
          );
        });
  }

  Future<void> openWhatsapp({required BuildContext context}) async {
    String whatsapp = '+254757913481';
    String message =
        'jithvar://task/#/${FirebaseAuth.instance.currentUser!.uid}';
    String whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$message";
    String whatsappURLIos =
        "https://wa.me/$whatsapp?text=${Uri.parse(message)}";
    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(whatsappURLIos));
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar("whatsapp not installed", context);
      }
    } else {
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar("whatsapp no installed", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: primaryColor,
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(Constants.appName),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () async =>
                          await openWhatsapp(context: context),
                      icon: Icon(Icons.share)),
                )
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData?.name ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Email: ${userData?.email}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Mobile: ${userData?.mobile}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Gender: ${userData?.gender}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text("DOB: ${userData?.dob}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24)),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FollowButton(
                        text: "Notification",
                        bgColor: blueColor,
                        textColor: primaryColor,
                        borderColor: Colors.grey,
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        function: () async {
                          displayMessageBox(context);
                        },
                      ),
                      FollowButton(
                        text: "Sign Out",
                        bgColor: mobileBackgroundColor,
                        textColor: primaryColor,
                        borderColor: Colors.grey,
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.4,
                        function: () async {
                          AuthMethods().signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                      )
                    ]),
              ],
            ),
          );
  }

  Column buildStartColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
