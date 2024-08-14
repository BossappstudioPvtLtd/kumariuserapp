import 'package:flutter/material.dart';
import 'package:new_app/components/animation_mbutton.dart';
import 'package:new_app/components/m_buttons.dart';
import 'package:new_app/new/model/location.dart';
import 'package:new_app/new/widget/stars_widget.dart';

class ExpandedContentWidget extends StatelessWidget {
  final Location location;

  const ExpandedContentWidget({
    required this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(location.addressLine1),
            const SizedBox(height: 8),
            buildAddressRating(location: location),
            const SizedBox(height: 12),
            buildReview(location: location)
          ],
        ),
      );

  Widget buildAddressRating({
    required Location location,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            location.addressLine2,
            style: const TextStyle(color: Colors.black45),
          ),
          StarsWidget(stars: location.starRating),
        ],
      );

  Widget buildReview({
    required Location location,
  }) =>
      Row(
        mainAxisAlignment:MainAxisAlignment.spaceAround,
        children: [
          
          ...location.reviews.map((review) {
            return Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor:Colors.white,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black12,
                    backgroundImage: AssetImage(review.urlImage),
                  ),
                ),
              ],
            );
          }).toList(),
          const SizedBox(width:20),
          MaterialButtonsAnimation(
            containerheight: 30,
            containerwidth: 80,
            borderRadius: BorderRadius.circular(6),
            meterialColor: const Color.fromARGB(255, 3, 22, 60),
            onPressed: () {
              // Handle button press
            },
            elevationsize: 20,
            text: 'Book now',
            textcolor: Colors.white,
            
          ),
        ],
      );
}
