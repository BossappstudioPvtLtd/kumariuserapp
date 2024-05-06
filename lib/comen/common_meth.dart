import 'package:flutter/material.dart';

class CommonMethod {
  Widget header(String headerTitle, Widget widget) {
    return CircleAvatar(
      child: Column(
        children: [
          CircleAvatar(
            child: const Padding(
              padding: EdgeInsets.all(2),
            ),
          ),
         
        ],
      ),
    );
  }

  Widget data(int dataFlexValue, Widget widget) {
    return ClipRRect(

      child: Container(
        
        color: Colors.white,
        height: 50,
        width: 15,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: widget,
        ),
      ),
    );
  }

  static sendRequestToAPI(String apiPlacesUrl) {}
}