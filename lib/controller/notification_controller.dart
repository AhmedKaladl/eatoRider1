import 'package:efood_multivendor_driver/data/api/api_checker.dart';
import 'package:efood_multivendor_driver/data/model/response/notification_model.dart';
import 'package:efood_multivendor_driver/data/repository/notification_repo.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  List<NotificationModel>? _notificationList;
  List<NotificationModel>? get notificationList => _notificationList;

  Future<void> getNotificationList() async {
    Response response = await notificationRepo.getNotificationList();
    if (response.statusCode == 200) {
      _notificationList = [];
    response.body.forEach((notify) {
        NotificationModel notification = NotificationModel.fromJson(notify);
        notification.title = notify['data']['title'];
        notification.description = notify['data']['description'];
        notification.image = notify['data']['image'];
        _notificationList!.add(notification);
      });
      _notificationList!.sort((a, b) {
        return DateConverter.isoStringToLocalDate(a.updatedAt!).compareTo(DateConverter.isoStringToLocalDate(b.updatedAt!));
      });
      Iterable iterable = _notificationList!.reversed;
      _notificationList = iterable.toList() as List<NotificationModel>?;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void saveSeenNotificationCount(int count) {
    notificationRepo.saveSeenNotificationCount(count);
  }

  int? getSeenNotificationCount() {
    return notificationRepo.getSeenNotificationCount();
  }

}
