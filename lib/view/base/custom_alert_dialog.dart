import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialog extends StatelessWidget {
  final String description;
  final Function onOkPressed;
  const CustomAlertDialog({Key? key, required this.description, required this.onOkPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Icon(Icons.info, size: 80, color: Theme.of(context).primaryColor),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text(
              description, textAlign: TextAlign.center,
              style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),

          CustomButton(
            buttonText: 'next'.tr,
            onPressed: onOkPressed,
            height: 40,
          ),

        ]),
      ),
    );
  }
}
