import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/response/notification_model.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationModel notificationModel;
  const NotificationDialog({Key? key, required this.notificationModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child:  SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            Container(
              height: 150, width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor.withOpacity(0.20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder,
                  image: '${Get.find<SplashController>().configModel!.baseUrls!.notificationImageUrl}/${notificationModel.image}',
                  height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                  imageErrorBuilder: (c, o, s) => Image.asset(
                    Images.placeholder, height: 150,
                    width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                notificationModel.title!,
                textAlign: TextAlign.center,
                style: IBMPlexSansArabicMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Text(
                notificationModel.description!,
                textAlign: TextAlign.center,
                style: IBMPlexSansArabicRegular.copyWith(color: Theme.of(context).disabledColor),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
