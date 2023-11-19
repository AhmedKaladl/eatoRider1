import 'package:efood_multivendor_driver/helper/price_converter.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class EarningWidget extends StatelessWidget {
  final String title;
  final double? amount;
  const EarningWidget({Key? key, required this.title, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Text(
        title,
        style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),
      amount != null ? Text(
        PriceConverter.convertPrice(amount),
        style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
        maxLines: 1, overflow: TextOverflow.ellipsis,
      ) : Shimmer(
        duration: const Duration(seconds: 2),
        enabled: amount == null,
        color: Colors.grey[500]!,
        child: Container(height: 20, width: 40, color: Colors.white),
      ),
    ]));
  }
}
