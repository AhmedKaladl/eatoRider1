import 'package:efood_multivendor_driver/data/model/response/order_model.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String image;
  final String? name;
  final DeliveryAddress? addressModel;
  final String? phone;
  final String? latitude;
  final String? longitude;
  final bool showButton;
  final bool isDelivery;
  final OrderModel? orderModel;
  final Function? messageOnTap;

  const InfoCard({Key? key, required this.title, required this.image, required this.name, required this.addressModel, required this.phone,
    required this.latitude, required this.longitude, required this.showButton, this.isDelivery = false, this.orderModel, this.messageOnTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(title, style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        (name != null && name!.isNotEmpty) ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipOval(child: FadeInImage.assetNetwork(
            placeholder: Images.placeholder, height: 40, width: 40, fit: BoxFit.cover,
            image: image,
            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 40, width: 40, fit: BoxFit.cover),
          )),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(name!, style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(
              addressModel!.address!,
              style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
            ),

            isDelivery ? Wrap(children: [

              (addressModel!.streetNumber != null && addressModel!.streetNumber!.isNotEmpty)? Text('${'street_number'.tr}: ${addressModel!.streetNumber!}, ',
                maxLines: 1, overflow: TextOverflow.ellipsis, style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ) : const SizedBox(),

              (addressModel!.house != null && addressModel!.house!.isNotEmpty) ? Text('${'house'.tr}: ${addressModel!.house!}, ',
                maxLines: 1, overflow: TextOverflow.ellipsis, style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ) : const SizedBox(),

              (addressModel!.floor != null && addressModel!.floor!.isNotEmpty) ? Text('${'floor'.tr}: ${addressModel!.floor!}',
                maxLines: 1, overflow: TextOverflow.ellipsis, style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ) : const SizedBox(),
            ]) : const SizedBox(),

            showButton ? Row(children: [

              TextButton.icon(
                onPressed: () async {
                  if(await canLaunchUrlString('tel:$phone')) {
                    launchUrlString('tel:$phone', mode: LaunchMode.externalApplication);
                  }else {
                    showCustomSnackBar('invalid_phone_number_found');
                  }
                },
                icon: Icon(Icons.call, color: Theme.of(context).primaryColor, size: 20),
                label: Text(
                  'call'.tr,
                  style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                ),
              ),

              orderModel != null ? TextButton.icon(
                onPressed: messageOnTap as void Function()?,
                icon: Icon(Icons.chat_rounded, color: Theme.of(context).primaryColor, size: 20),
                label: Text(
                  'message'.tr,
                  style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                ),
              ) : const SizedBox(),

              TextButton.icon(
                onPressed: () async {
                  String url ='https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&mode=d';
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw '${'could_not_launch'.tr} $url';
                  }
                },
                icon: Icon(Icons.directions, color: Theme.of(context).disabledColor, size: 20),
                label: Text(
                  'direction'.tr,
                  style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
              ),

            ]) : const SizedBox(height: Dimensions.paddingSizeDefault),

          ])),

        ]) : Center(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Text('no_restaurant_data_found'.tr, style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
        ),),

      ]),
    );
  }
}
