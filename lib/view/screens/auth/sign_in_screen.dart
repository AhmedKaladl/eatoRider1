import 'package:country_code_picker/country_code_picker.dart';
import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/localization_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class SignInScreen extends StatelessWidget {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
        : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    _phoneController.text =  Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();

    return Scaffold(
      body: SafeArea(child: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: GetBuilder<AuthController>(builder: (authController) {

                  return Column(children: [

                    Image.asset(Images.logo, width: 100),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Image.asset(Images.logoName, width: 100),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Text('sign_in'.tr.toUpperCase(), style: IBMPlexSansArabicBlack.copyWith(fontSize: 30)),
                    const SizedBox(height: 50),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color: Theme.of(context).cardColor,
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                      ),
                      child: Column(children: [

                        CustomTextField(
                          titleText: 'enter_phone_number'.tr,
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          nextFocus: _passwordFocus,
                          inputType: TextInputType.phone,
                          isPhone: true,
                          showBorder: false,
                          divider: true,
                          onCountryChanged: (CountryCode countryCode) {
                            countryDialCode = countryCode.dialCode;
                          },
                          countryDialCode: countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                              : Get.find<LocalizationController>().locale.countryCode,
                        ),

                        CustomTextField(
                          showBorder: false,
                          hintText: 'password'.tr,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          onSubmit: (text) => GetPlatform.isWeb ? _login(
                            authController, _phoneController, _passwordController, countryDialCode!, context,
                          ) : null,
                        ),

                      ]),
                    ),
                    const SizedBox(height: 10),

                    Row(children: [
                      Expanded(
                        child: ListTile(
                          onTap: () => authController.toggleRememberMe(),
                          leading: Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            value: authController.isActiveRememberMe,
                            onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                          ),
                          title: Text('remember_me'.tr),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          horizontalTitleGap: 0,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute()),
                        child: Text('${'forgot_password'.tr}?'),
                      ),
                    ]),
                    const SizedBox(height: 50),

                    !authController.isLoading ? CustomButton(
                      buttonText: 'sign_in'.tr,
                      onPressed: () => _login(authController, _phoneController, _passwordController, countryDialCode!, context),
                    ) : const Center(child: CircularProgressIndicator()),
                    SizedBox(height: Get.find<SplashController>().configModel!.toggleDmRegistration! ? Dimensions.paddingSizeSmall : 0),

                    Get.find<SplashController>().configModel!.toggleDmRegistration! ? TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(1, 40),
                      ),
                      onPressed: () async {
                        // if(await canLaunchUrlString('${AppConstants.BASE_URL}/deliveryman/apply')) {
                        //   launchUrlString('${AppConstants.BASE_URL}/deliveryman/apply', mode: LaunchMode.externalApplication);
                        // }
                        Get.toNamed(RouteHelper.getDeliverymanRegistrationRoute());
                      },
                      child: RichText(text: TextSpan(children: [
                        TextSpan(text: '${'join_as_a'.tr} ', style: IBMPlexSansArabicRegular.copyWith(color: Theme.of(context).disabledColor)),
                        TextSpan(text: 'delivery_man'.tr, style: IBMPlexSansArabicMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                      ])),
                    ) : const SizedBox(),

                  ]);
                }),
              ),
            ),
          ),
        ),
      )),
    );
  }

  void _login(AuthController authController, TextEditingController phoneCtlr, TextEditingController passCtlr, String countryCode, BuildContext context) async {
    String phone = phoneCtlr.text.trim();
    String password = passCtlr.text.trim();

    String numberWithCountryCode = countryCode+phone;
    bool isValid = GetPlatform.isAndroid ? false : true;
    if(GetPlatform.isAndroid) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(numberWithCountryCode);
        numberWithCountryCode = '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
        isValid = true;
      } catch (_) {}
    }

    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else {
      authController.login(numberWithCountryCode, password).then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(phone, password, countryCode);
          } else {
            authController.clearUserNumberAndPassword();
          }
          await Get.find<AuthController>().getProfile();
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }

    /*print('------------1');
    final _imageData = await Http.get(Uri.parse('https://cdn.dribbble.com/users/1622791/screenshots/11174104/flutter_intro.png'));
    print('------------2');
    String _stringImage = base64Encode(_imageData.bodyBytes);
    print('------------3 {$_stringImage}');
    SharedPreferences _sp = await SharedPreferences.getInstance();
    _sp.setString('image', _stringImage);
    print('------------4');
    Uint8List _uintImage = base64Decode(_sp.getString('image'));
    authController.setImage(_uintImage);
    //await _thetaImage.writeAsBytes(_imageData.bodyBytes);
    print('------------5');*/
  }
}
