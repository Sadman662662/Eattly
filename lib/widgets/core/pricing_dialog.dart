import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eattlystefan/models/User.dart';
import 'package:flutter/material.dart';

import './pricing_card.dart';

class PricingDialog extends StatelessWidget {
  final Users currentUser;

  PricingDialog({Key key, @required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      child: Container(
        width: double.infinity,
        height: 450,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/eattly.png',
                ),
              ),
              title: Text(
                'Lorem ipsum dolor amet consectetu tgr kslssds adi elitiuim smod rdfi fiuh nmk pl tempor',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
            SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                height: 350,
                aspectRatio: 1,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
              ),
              items: [
                PricingCard(
                  priceText: '\$4.97 USD/monthly',
                  premiumText: 'Purchase Premium',
                  expiryDate: '24/04/2022',
                  plusBadge: true,
                  features: [
                    'Meal Planner',
                    'Shopping List',
                    'Search By Ingredients',
                    'Calories, Fat, Sodium Counters',
                  ],
                  buttonText: 'Buy',
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(this.currentUser.id)
                          .update({'userType': 'PremiumOne'});

                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Subscribed to Premium')),
                      );

                      Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                    }
                    // try {
                    //   Offerings offerings = await Purchases.getOfferings();
                    //   print('Current Offerings: ${offerings.current}');
                    //
                    //   if (offerings.current != null) {
                    //     PurchaserInfo purchaserInfo =
                    //         await Purchases.purchasePackage(
                    //             offerings.current.monthly);
                    //     var isPro =
                    //         purchaserInfo.entitlements.all['premium'].isActive;
                    //     if (isPro) {
                    //       FirebaseFirestore.instance
                    //           .collection('users')
                    //           .doc(this.currentUser.id)
                    //           .update({'userType': 'PremiumOne'});
                    //     }
                    //   }
                    // } on PlatformException catch (e) {
                    //   var errorCode = PurchasesErrorHelper.getErrorCode(e);
                    //   if (errorCode !=
                    //       PurchasesErrorCode.purchaseCancelledError) {
                    //     print(e);
                    //   }
                    // }
                  },
                ),
                PricingCard(
                  priceText: '\$0.00 USD',
                  premiumText: 'Free',
                  expiryDate: '24/04/2022',
                  plusBadge: true,
                  features: [
                    'Save Recipe',
                    'Add Favorites',
                    'Search Meals',
                  ],
                  buttonText: 'Select',
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.id)
                          .update({'userType': 'Free'});

                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Subscribed to Free')),
                      );

                      Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
