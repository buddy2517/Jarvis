import "package:flutter/material.dart";
import "package:jarvis/pallete.dart";

class FeatureBox extends StatelessWidget{
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureBox({super.key,required this.color, required this.headerText, required this.descriptionText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical:5,horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15,right: 20,top: 15,bottom: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(headerText,
                style: const TextStyle(
                  fontFamily:'Cera Pro',
                  color: Pallete.blackColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Text(descriptionText,
              style: const TextStyle(
                  fontFamily:'Cera Pro',
                  color: Pallete.blackColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
