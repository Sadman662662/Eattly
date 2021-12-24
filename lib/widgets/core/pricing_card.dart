import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import './pricing_item_tile.dart';

class PricingCard extends StatelessWidget {
  const PricingCard({
    Key key,
    @required this.priceText,
    @required this.premiumText,
    @required this.expiryDate,
    @required this.plusBadge,
    @required this.features,
    @required this.buttonText,
    @required this.onPressed,
  }) : super(key: key);

  final String priceText;
  final String premiumText;
  final String expiryDate;
  final bool plusBadge;
  final List<String> features;
  final String buttonText;
  final Function() onPressed;

  Widget populateFeatures() {
    List<Widget> featureList = [];

    featureList.add(PricingItemTile(itemText: features[0]));

    for (var i = 1; i < features.length; i++) {
      featureList.add(PricingItemTile(
        iconContainerColor: Color(0xFF787C80),
        iconColor: Colors.black,
        itemText: features[i],
        itemTextColor: Color(0xFF787C80),
      ));
    }

    return ListView(children: featureList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Stack(
        children: [
          Container(
            height: 330,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              elevation: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 20,
                    ),
                    child: Text(
                      priceText,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      premiumText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Expires in $expiryDate',
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                    trailing: plusBadge
                        ? Badge(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 8,
                            ),
                            toAnimate: false,
                            shape: BadgeShape.square,
                            badgeColor: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(25),
                            badgeContent: Text(
                              'Plus',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          )
                        : null,
                  ),
                  Container(height: 150, child: populateFeatures())
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 20,
            child: RaisedButton(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: onPressed,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
