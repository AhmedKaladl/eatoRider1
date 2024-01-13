import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialog extends StatelessWidget {
  final String icon;
  final double iconSize;
  final String? title;
  final String description;
  final Function onYesPressed;
  final bool isLogOut;
  final bool hasCancel;
  const ConfirmationDialog({Key? key, 
    required this.icon, this.iconSize = 50, this.title, required this.description, required this.onYesPressed,
    this.isLogOut = false, this.hasCancel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Image.asset(icon, width: iconSize, height: iconSize),
          ),

          title != null ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              title!, textAlign: TextAlign.center,
              style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
            ),
          ) : const SizedBox(),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Text(description, style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          GetBuilder<AuthController>(builder: (authController) {
              return GetBuilder<OrderController>(builder: (orderController) {
                return (orderController.isLoading || authController.isLoading) ? const Center(child: CircularProgressIndicator()) : Row(children: [
                  hasCancel ? Expanded(child: TextButton(
                    onPressed: () => isLogOut ? onYesPressed() : Get.back(),
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                    ),
                    child: Text(
                      isLogOut ? 'yes'.tr : 'no'.tr, textAlign: TextAlign.center,
                      style: IBMPlexSansArabicBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                  )) : const SizedBox(),
                  SizedBox(width: hasCancel ? Dimensions.paddingSizeLarge : 0),

                  Expanded(child: CustomButton(
                    buttonText: isLogOut ? 'no'.tr : hasCancel ? 'yes'.tr : 'next'.tr,
                    onPressed: () => isLogOut ? Get.back() : onYesPressed(),
                    height: 40,
                  )),
                ]);
              });
            }
          ),

        ]),
      ),
    );
  }
}