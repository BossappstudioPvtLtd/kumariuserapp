import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_app/components/m_buttons.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final bool _switch = true;
  final bool _switch1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        
      backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
             //Account

              const Row(
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Account",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Column(
                    children: <Widget>[
                      
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text(
                          
                          "Edit Profile",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                      ListTile(
                        leading: Text(
                          "Change Password",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                    
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Row(
                children: <Widget>[
                  Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),

                  //Notification

                  Text(
                    "Notification",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Text(
                          "Notification",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: Switch(
                            value: _switch,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeColor: Colors.green,
                            onChanged: (bool val) {}),
                      ),
                      ListTile(
                        leading: const Text(
                          "App Notification",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: Switch(
                            value: _switch1,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeColor: Colors.green,
                            onChanged: (bool val) {}),
                      ),
                    ],
                  ),
                ),
              ),

            //More

              const SizedBox(
                height: 40,
              ),
              const Row(
                children: <Widget>[
                  Icon(
                    Icons.expand_more,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "More",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Material(
                
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Column(
                    children: <Widget>[
                      ListTile(
                        leading: Text(
                          "Language",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                      ListTile(
                        leading: Text(
                          "Country",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              MaterialButtons(
                onPressed: () {},
                containerheight: 40,
                borderRadius: BorderRadius.circular(10),
               meterialColor: Colors.white,
                text: 'Sign Out',
                textcolor: Colors.red,
                elevationsize: 20,
                
              )
            ],
          ),
        ),
      ),
    );
  }
}
