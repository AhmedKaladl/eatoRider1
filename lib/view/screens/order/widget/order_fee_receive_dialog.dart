import 'package:efood_multivendor_driver/helper/price_converter.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderFeeReceiveDialog extends StatelessWidget {
  final double totalAmount;
  const OrderFeeReceiveDialog({Key? key, required this.totalAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Image.asset(Images.money, height: 100, width: 100),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(
            'collect_money_from_customer'.tr, textAlign: TextAlign.center,
            style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              '${'order_amount'.tr}:', textAlign: TextAlign.center,
              style: IBMPlexSansArabicBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              PriceConverter.convertPrice(totalAmount), textAlign: TextAlign.center,
              style: IBMPlexSansArabicBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          CustomButton(
            buttonText: 'ok'.tr,
            onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute()),
          ),

        ]),
      ),
    );
  }
}
