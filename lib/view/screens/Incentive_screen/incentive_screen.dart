import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/helper/price_converter.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class IncentiveScreen extends StatefulWidget {
  const IncentiveScreen({Key? key}) : super(key: key);

  @override
  State<IncentiveScreen> createState() => _IncentiveScreenState();
}

class _IncentiveScreenState extends State<IncentiveScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'incentive'.tr),
      body: GetBuilder<AuthController>(
        builder: (authController) {
          for (var incentive in authController.profileModel!.incentiveList!) {
            if(incentive.earning! < authController.profileModel!.todaysEarning!){
              selectedIndex = authController.profileModel!.incentiveList!.indexOf(incentive);
            }
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150, width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Center(child: Text(
                    '${'you_have_total_incentive'.tr}\n${PriceConverter.convertPrice(authController.profileModel!.totalIncentiveEarning)}',
                    textAlign: TextAlign.center, style: IBMPlexSansArabicBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).cardColor),
                  )),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: Text('current_incentive_offers'.tr, style: IBMPlexSansArabicMedium),
                ),

                authController.profileModel!.incentiveList!.isNotEmpty ? ListView.builder(
                  shrinkWrap: true,
                    itemCount: authController.profileModel!.incentiveList!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: selectedIndex == index ? Colors.green : Theme.of(context).cardColor, width: 2),
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('earning'.tr, style: IBMPlexSansArabicMedium),
                          Text('incentive'.tr, style: IBMPlexSansArabicMedium),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(PriceConverter.convertPrice(authController.profileModel!.incentiveList![index].earning), style: IBMPlexSansArabicMedium),
                          Text(PriceConverter.convertPrice(authController.profileModel!.incentiveList![index].incentive), style: IBMPlexSansArabicMedium),
                        ]),
                      ]),
                      // child: Text('earn_per_day'.tr + ' ' + PriceConverter.convertPrice(authController.profileModel.incentiveList[index].earning) +', ' + 'you_will_get'.tr +
                      //     PriceConverter.convertPrice(authController.profileModel.incentiveList[index].incentive) +' '+'incentive'.tr),
                    ),
                  );
                }) : Text('no_offer_available'.tr, style: IBMPlexSansArabicBold),
              ],
            ),
          );
        }
      ),
    );
  }
}
