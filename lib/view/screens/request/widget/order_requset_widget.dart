import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/order_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:efood_multivendor_driver/helper/price_converter.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderRequestWidget extends StatelessWidget {
  final OrderModel orderModel;
  final int index;
  final bool fromDetailsPage;
  final Function onTap;
  const OrderRequestWidget({Key? key, required this.orderModel, required this.index, required this.onTap, this.fromDetailsPage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Column(children: [

          Row(children: [
            ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder, height: 45, width: 45, fit: BoxFit.cover,
              image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${orderModel.restaurantLogo ?? ''}',
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 45, width: 45, fit: BoxFit.cover),
            )),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                orderModel.restaurantName ?? 'no_restaurant_data_found'.tr, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              Text(
                orderModel.restaurantAddress ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              ),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Theme.of(context).primaryColor, width: 1),
              ),
              child: Column(children: [
                (Get.find<SplashController>().configModel!.showDmEarning! && Get.find<AuthController>().profileModel!.earnings == 1) ? Text(
                  PriceConverter.convertPrice(orderModel.originalDeliveryCharge! + orderModel.dmTips!),
                  style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                ) : const SizedBox(),
                Text(
                  orderModel.paymentMethod == 'cash_on_delivery' ? 'cod'.tr : 'digitally_paid'.tr,
                  style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                ),
              ]),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            '${orderModel.detailsCount} ${orderModel.detailsCount! > 1 ? 'items'.tr : 'item'.tr}',
            style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
          Text(
            '${DateConverter.timeDistanceInMin(orderModel.createdAt!)} ${'mins_ago'.tr}',
            style: IBMPlexSansArabicBold.copyWith(color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            orderModel.orderType == 'wdelivery' ? 'woman_delivery'.tr : orderModel.orderType == 'delivery' ? 'delivery'.tr : '',
            style: TextStyle(
              fontSize: 16,
              color: orderModel.orderType  == 'wdelivery' ? Colors.red : Colors.black,
              shadows: orderModel.orderType == 'wdelivery' ? [
                const Shadow(
                  color: Colors.red,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ] : null,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),



          Row(children: [
            Expanded(child: TextButton(
              onPressed: () => Get.dialog(ConfirmationDialog(
                icon: Images.warning, title: 'are_you_sure_to_ignore'.tr, description: 'you_want_to_ignore_this_order'.tr, onYesPressed: () {
                  orderController.ignoreOrder(index);
                  Get.back();
                  showCustomSnackBar('order_ignored'.tr, isError: false);
                },
              ), barrierDismissible: false),
              style: TextButton.styleFrom(
                minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  side: BorderSide(width: 1, color: Theme.of(context).textTheme.bodyLarge!.color!),
                ),
              ),
              child: Text('ignore'.tr, textAlign: TextAlign.center, style: IBMPlexSansArabicRegular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: Dimensions.fontSizeLarge,
              )),
            )),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(child: CustomButton(
              height: 40,
              buttonText: 'accept'.tr,
              onPressed: () => Get.dialog(ConfirmationDialog(
                icon: Images.warning, title: 'are_you_sure_to_accept'.tr, description: 'you_want_to_accept_this_order'.tr, onYesPressed: () {
                  orderController.acceptOrder(orderModel.id, index, orderModel).then((isSuccess) {
                    if(isSuccess) {
                      onTap();
                      orderModel.orderStatus = (orderModel.orderStatus == 'pending' || orderModel.orderStatus == 'confirmed')
                          ? 'accepted' : orderModel.orderStatus;
                      Get.toNamed(
                        RouteHelper.getOrderDetailsRoute(orderModel.id),
                        arguments: OrderDetailsScreen(
                          orderId: orderModel.id, isRunningOrder: true, orderIndex: orderController.currentOrderList!.length-1,
                        ),
                      );
                    }else {
                      Get.find<OrderController>().getLatestOrders();
                    }
                  });
                },
              ), barrierDismissible: false),
            )),
          ]),

        ]);
      }),
    );
  }
}
