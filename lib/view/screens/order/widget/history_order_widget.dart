import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryOrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool isRunning;
  final int index;
  const HistoryOrderWidget({Key? key, required this.orderModel, required this.isRunning, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        RouteHelper.getOrderDetailsRoute(orderModel.id),
        arguments: OrderDetailsScreen(orderId: orderModel.id, isRunningOrder: isRunning, orderIndex: index),
      ),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5)],
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Row(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder, height: 70, width: 70, fit: BoxFit.cover,
              image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                  '/${orderModel.restaurantLogo ?? ''}',
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 70, width: 70, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                Text('${'order_id'.tr}:', style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  '#${orderModel.id}',
                  style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                orderModel.restaurantName ?? 'no_restaurant_data_found'.tr,
                style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(children: [
                const Icon(Icons.access_time, size: 15),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  DateConverter.dateTimeStringToDateTime(orderModel.createdAt!),
                  style: IBMPlexSansArabicRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                ),
              ]),

            ]),
          ),

        ]),
      ),
    );
  }
}
