import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ShiftDialogue extends StatefulWidget {
  const ShiftDialogue({Key? key}) : super(key: key);

  @override
  State<ShiftDialogue> createState() => _ShiftDialogueState();
}

class _ShiftDialogueState extends State<ShiftDialogue> {
  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().initData();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<AuthController>(
          builder: (authController) {
            return SizedBox(
              width: 500, height: MediaQuery.of(context).size.height * 0.6,
              child: Column(children: [

                Container(
                  width: 500,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Column(children: [
                    Text(
                      'select_shift'.tr,
                      style: IBMPlexSansArabicMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  ]),
                ),

                Expanded(
                  child: authController.shifts != null ? authController.shifts!.isNotEmpty
                    ? ListView.builder(
                      itemCount: authController.shifts!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: ListTile(
                            onTap: (){
                              // orderController.setOrderCancelReason(orderController.orderCancelReasons[index].reason);
                              authController.setShiftId(authController.shifts![index].id);
                            },
                            title: Row(
                              children: [
                                Icon(authController.shifts![index].id == authController.shiftId ? Icons.radio_button_checked : Icons.radio_button_off, color: Theme.of(context).primaryColor, size: 18),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(authController.shifts![index].name!, style: IBMPlexSansArabicMedium, maxLines: 1, overflow: TextOverflow.ellipsis),

                                    Text(
                                      '${DateConverter.onlyTimeShow(authController.shifts![index].startTime!)} - ${DateConverter.onlyTimeShow(authController.shifts![index].endTime!)}',
                                      style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }) : Center(child: Text('no_reasons_available'.tr)) : const Center(child: CircularProgressIndicator()),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeDefault, vertical: Dimensions.paddingSizeSmall),
                  child: !authController.shiftLoading ? Row(children: [
                    Expanded(child: CustomButton(
                      buttonText: 'skip'.tr, backgroundColor: Theme.of(context).disabledColor, radius: 50,
                      onPressed: () {
                        authController.updateActiveStatus(isUpdate: true).then((success) {
                          if(success){
                            Get.back();
                            Future.delayed(const Duration(seconds: 2), (){
                              Get.back();
                            });
                          }
                        });
                      },
                    )),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: CustomButton(
                      buttonText: 'submit'.tr,  radius: 50,
                      onPressed: (){
                        if(authController.shiftId != null ){
                          authController.updateActiveStatus(shiftId: authController.shiftId, isUpdate: true).then((success) {
                            if(success){
                              Get.back();
                              Future.delayed(const Duration(seconds: 2), ()=> Get.back());
                            }
                          });
                        }else{
                          authController.updateActiveStatus(isUpdate: true).then((success) {
                            if(success){
                              Get.back();
                                Future.delayed(const Duration(seconds: 2), (){
                                    Get.back();
                                });
                            }
                          });
                        }
                      },
                    )),
                  ]) : const Center(child: CircularProgressIndicator()),
                ),
              ]),
            );
          }
      ),
    );
  }
}
