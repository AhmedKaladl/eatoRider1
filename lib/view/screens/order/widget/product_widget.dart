import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/response/order_details_model.dart';
import 'package:efood_multivendor_driver/helper/price_converter.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWidget extends StatelessWidget {
  final OrderDetailsModel orderDetailsModel;
  const ProductWidget({Key? key, required this.orderDetailsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Row(children: [

        ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), child: FadeInImage.assetNetwork(
          placeholder: Images.placeholder, height: 50, width: 50, fit: BoxFit.cover,
          image: '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${orderDetailsModel.foodDetails!.image}',
          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 50, width: 50, fit: BoxFit.cover),
        )),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Text('✕ ${orderDetailsModel.quantity}'),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(child: Text(
          orderDetailsModel.foodDetails!.name!, maxLines: 2, overflow: TextOverflow.ellipsis,
          style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
        )),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Text(
          PriceConverter.convertPrice(orderDetailsModel.price!-orderDetailsModel.discountOnFood!),
          style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
        ),

      ]),
    );
  }
}
