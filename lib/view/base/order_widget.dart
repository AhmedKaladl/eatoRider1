import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool isRunningOrder;
  final int orderIndex;
  const OrderWidget({Key? key, required this.orderModel, required this.isRunningOrder, required this.orderIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
      ),
      child: Column(children: [

        Row(children: [
          Text('${'order_id'.tr}:', style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text('#${orderModel.id}', style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
          const Expanded(child: SizedBox()),
          Container(width: 7, height: 7, decoration: BoxDecoration(
            color: orderModel.paymentMethod == 'cash_on_delivery' ? Colors.red : Colors.green,
            shape: BoxShape.circle,
          )),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(
            orderModel.paymentMethod == 'cash_on_delivery' ? 'cod'.tr : 'digitally_paid'.tr,
            style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset(orderModel.orderStatus == 'picked_up' ? Images.user : Images.house, width: 20, height: 15),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(
            orderModel.orderStatus == 'picked_up' ? 'customer_location'.tr :'restaurant_location'.tr,
            style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
          const Icon(Icons.location_on, size: 20),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Expanded(child: Text(
            orderModel.orderStatus == 'picked_up' ? orderModel.deliveryAddress!.address.toString() : orderModel.restaurantAddress ?? '',
            style: IBMPlexSansArabicRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          )),
        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [
          Expanded(child: TextButton(
            onPressed: () {
              Get.toNamed(
                RouteHelper.getOrderDetailsRoute(orderModel.id),
                arguments: OrderDetailsScreen(orderId: orderModel.id, isRunningOrder: isRunningOrder, orderIndex: orderIndex),
              );
            },
            style: TextButton.styleFrom(minimumSize: const Size(1170, 45), padding: EdgeInsets.zero, shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall), side: BorderSide(width: 2, color: Theme.of(context).disabledColor),
            )),
            child: Text('details'.tr, textAlign: TextAlign.center, style: IBMPlexSansArabicBold.copyWith(
              color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeLarge,
            )),
          )),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(child: CustomButton(
            height: 45,
            onPressed: () async {
              String url;
              if(orderModel.orderStatus == 'picked_up') {
                url = 'https://www.google.com/maps/dir/?api=1&destination=${orderModel.deliveryAddress!.latitude}'
                    ',${orderModel.deliveryAddress!.longitude}&mode=d';
              }else  {
                url = 'https://www.google.com/maps/dir/?api=1&destination=${orderModel.restaurantLat ?? '0'}'
                    ',${orderModel.restaurantLng ?? '0'}&mode=d';
              }
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url, mode: LaunchMode.externalApplication);
              } else {
                showCustomSnackBar('${'could_not_launch'.tr} $url');
              }
            },
            buttonText: 'direction'.tr,
            icon: Icons.directions,
          )),
        ]),

      ]),
    );
  }
}
