import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/controller/theme_controller.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_driver/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:efood_multivendor_driver/view/screens/profile/widget/profile_button.dart';
import 'package:efood_multivendor_driver/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<AuthController>(builder: (authController) {
        return authController.profileModel == null ? const Center(child: CircularProgressIndicator()) : ProfileBgWidget(
          backButton: false,
          circularImage: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Theme.of(context).cardColor),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ClipOval(child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder,
              image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}'
                  '/${authController.profileModel != null ? authController.profileModel!.image : ''}',
              height: 100, width: 100, fit: BoxFit.cover,
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 100, width: 100, fit: BoxFit.cover),
            )),
          ),
          mainWidget: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Center(child: Container(
            width: 1170, color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [

              Text(
                '${authController.profileModel!.fName} ${authController.profileModel!.lName}',
                style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),

              authController.profileModel!.shiftName != null ? RichText(text: TextSpan(children: [
                TextSpan(text: '${'shift'.tr}: ', style: IBMPlexSansArabicMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall)),
                TextSpan(text: ' ${authController.profileModel!.shiftName}', style: IBMPlexSansArabicMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                TextSpan(text: ' (${DateConverter.onlyTimeShow(authController.profileModel!.shiftStartTime!)} - ${DateConverter.onlyTimeShow(authController.profileModel!.shiftEndTime!)})',
                    style: IBMPlexSansArabicMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
              ])) : const SizedBox(),
              const SizedBox(height: 30),

              Row(children: [
                ProfileCard(title: 'since_joining'.tr, data: '${authController.profileModel!.memberSinceDays} ${'days'.tr}'),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                ProfileCard(title: 'total_order'.tr, data: authController.profileModel!.orderCount.toString()),
              ]),
              const SizedBox(height: 30),

              ProfileButton(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButton(
                icon: Icons.notifications, title: 'notification'.tr,
                isButtonActive: authController.notification, onTap: () {
                  authController.setNotificationActive(!authController.notification);
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButton(icon: Icons.chat_bubble, title: 'conversation'.tr, onTap: () {
                Get.toNamed(RouteHelper.getConversationListRoute());
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              // Get.find<SplashController>().configModel.toggleDmRegistration
              //     ? ProfileButton(icon: Icons.delivery_dining, title: 'join_as_a_delivery_man'.tr, onTap: () {
              //   Get.toNamed(RouteHelper.getDeliverymanRegistrationRoute());
              // }) : SizedBox(),
              // SizedBox(height: Get.find<SplashController>().configModel.toggleDmRegistration ? Dimensions.PADDING_SIZE_SMALL : 0.0),

              ProfileButton(icon: Icons.language, title: 'language'.tr, onTap: () {
                Get.toNamed(RouteHelper.getLanguageRoute('profile'));
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButton(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButton(icon: Icons.edit, title: 'edit_profile'.tr, onTap: () {
                Get.toNamed(RouteHelper.getUpdateProfileRoute());
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButton(icon: Icons.local_offer_rounded, title: 'incentive_offers'.tr, onTap: () {
                Get.toNamed(RouteHelper.getIncentiveRoute());
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButton(icon: Icons.list, title: 'terms_condition'.tr, onTap: () {
                Get.toNamed(RouteHelper.getTermsRoute());
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButton(icon: Icons.privacy_tip, title: 'privacy_policy'.tr, onTap: () {
                Get.toNamed(RouteHelper.getPrivacyRoute());
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButton(
                icon: Icons.delete, title: 'delete_account'.tr,
                onTap: () {
                  Get.dialog(ConfirmationDialog(icon: Images.warning, title: 'are_you_sure_to_delete_account'.tr,
                      description: 'it_will_remove_your_all_information'.tr, isLogOut: true,
                      onYesPressed: () => authController.removeDriver()),
                      useSafeArea: false);
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButton(icon: Icons.logout, title: 'logout'.tr, onTap: () {
                Get.back();
                Get.dialog(ConfirmationDialog(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () {
                  Get.find<AuthController>().clearSharedData();
                  Get.find<AuthController>().stopLocationRecord();
                  Get.offAllNamed(RouteHelper.getSignInRoute());
                }));
              }),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${'version'.tr}:', style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(AppConstants.appVersion.toString(), style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
              ]),

            ]),
          ))),
        );
      }),
    );
  }
}
