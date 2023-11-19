import 'package:flutter/foundation.dart';

void customPrint(var text){
  if (kDebugMode) {
    print(text);
  }
}