import 'dart:convert';

class PaginatedOrderModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<OrderModel>? orders;

  PaginatedOrderModel({this.totalSize, this.limit, this.offset, this.orders});

  PaginatedOrderModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = json['offset'].toString();
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders!.add(OrderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class OrderModel {
  int? id;
  int? userId;
  double? orderAmount;
  double? couponDiscountAmount;
  String? paymentStatus;
  String? orderStatus;
  double? totalTaxAmount;
  String? paymentMethod;
  String? transactionReference;
  int? deliveryAddressId;
  int? deliveryManId;
  String? orderType;
  int? restaurantId;
  String? createdAt;
  String? updatedAt;
  double? deliveryCharge;
  double? originalDeliveryCharge;
  double? dmTips;
  String? scheduleAt;
  String? restaurantName;
  double? restaurantDiscountAmount;
  String? restaurantAddress;
  String? restaurantLat;
  String? restaurantLng;
  String? restaurantLogo;
  String? restaurantPhone;
  String? restaurantDeliveryTime;
  int? vendorId;
  int? detailsCount;
  String? orderNote;
  DeliveryAddress? deliveryAddress;
  Customer? customer;
  int? processingTime;
  int? chatPermission;
  String? restaurantModel;
  bool? cutlery;
  String? unavailableItemNote;
  String? deliveryInstruction;
  List<String>? orderProof;
  List<Payments>? payments;
  double? storeDiscountAmount;
  bool? taxStatus;
  double? additionalCharge;

  OrderModel(
      {this.id,
        this.userId,
        this.orderAmount,
        this.couponDiscountAmount,
        this.paymentStatus,
        this.orderStatus,
        this.totalTaxAmount,
        this.paymentMethod,
        this.transactionReference,
        this.deliveryAddressId,
        this.deliveryManId,
        this.orderType,
        this.restaurantId,
        this.createdAt,
        this.updatedAt,
        this.deliveryCharge,
        this.originalDeliveryCharge,
        this.dmTips,
        this.scheduleAt,
        this.restaurantName,
        this.restaurantDiscountAmount,
        this.restaurantAddress,
        this.restaurantLat,
        this.restaurantLng,
        this.restaurantLogo,
        this.restaurantPhone,
        this.restaurantDeliveryTime,
        this.vendorId,
        this.detailsCount,
        this.orderNote,
        this.deliveryAddress,
        this.customer,
        this.processingTime,
        this.chatPermission,
        this.restaurantModel,
        this.cutlery,
        this.unavailableItemNote,
        this.deliveryInstruction,
        this.orderProof,
        this.payments,
        this.storeDiscountAmount,
        this.taxStatus,
        this.additionalCharge,
      });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderAmount = json['order_amount'].toDouble();
    couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = json['total_tax_amount'].toDouble();
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    deliveryAddressId = json['delivery_address_id'];
    deliveryManId = json['delivery_man_id'];
    orderType = json['order_type'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryCharge = json['delivery_charge'].toDouble();
    originalDeliveryCharge = json['original_delivery_charge'].toDouble();
    dmTips = json['dm_tips'].toDouble();
    scheduleAt = json['schedule_at'];
    restaurantName = json['restaurant_name'];
    restaurantDiscountAmount = json['restaurant_discount_amount'].toDouble();
    restaurantAddress = json['restaurant_address'];
    restaurantLat = json['restaurant_lat'];
    restaurantLng = json['restaurant_lng'];
    restaurantLogo = json['restaurant_logo'];
    restaurantPhone = json['restaurant_phone'];
    restaurantDeliveryTime = json['restaurant_delivery_time'];
    vendorId = json['vendor_id'];
    detailsCount = json['details_count'];
    orderNote = json['order_note'];
    deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    processingTime = json['processing_time'];
    chatPermission = json['chat_permission'];
    restaurantModel = json['restaurant_model'];
    cutlery = json['cutlery'];
    unavailableItemNote = json['unavailable_item_note'];
    deliveryInstruction = json['delivery_instruction'];
    if(json['order_proof'] != null && json['order_proof'] != "null"){
      if(json['order_proof'].toString().startsWith('[')){
        orderProof = [];
        if(json['order_proof'] is String) {
          jsonDecode(json['order_proof']).forEach((v) {
            orderProof!.add(v);
          });
        }else{
          json['order_proof'].forEach((v) {
            orderProof!.add(v);
          });
        }
      }else{
        orderProof = [];
        orderProof!.add(json['order_proof'].toString());
      }
    }
    if (json['payments'] != null) {
      payments = <Payments>[];
      json['payments'].forEach((v) {
        payments!.add(Payments.fromJson(v));
      });
    }
    storeDiscountAmount = json['restaurant_discount']?.toDouble();
    taxStatus = json['tax_status'] == 'included' ? true : false;
    additionalCharge = json['additional_charge']?.toDouble() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_amount'] = orderAmount;
    data['coupon_discount_amount'] = couponDiscountAmount;
    data['payment_status'] = paymentStatus;
    data['order_status'] = orderStatus;
    data['total_tax_amount'] = totalTaxAmount;
    data['payment_method'] = paymentMethod;
    data['transaction_reference'] = transactionReference;
    data['delivery_address_id'] = deliveryAddressId;
    data['delivery_man_id'] = deliveryManId;
    data['order_type'] = orderType;
    data['restaurant_id'] = restaurantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['delivery_charge'] = deliveryCharge;
    data['original_delivery_charge'] = originalDeliveryCharge;
    data['dm_tips'] = dmTips;
    data['schedule_at'] = scheduleAt;
    data['restaurant_name'] = restaurantName;
    data['restaurant_discount_amount'] = restaurantDiscountAmount;
    data['restaurant_address'] = restaurantAddress;
    data['restaurant_lat'] = restaurantLat;
    data['restaurant_lng'] = restaurantLng;
    data['restaurant_logo'] = restaurantLogo;
    data['restaurant_phone'] = restaurantPhone;
    data['restaurant_delivery_time'] = restaurantDeliveryTime;
    data['vendor_id'] = vendorId;
    data['details_count'] = detailsCount;
    data['order_note'] = orderNote;
    if (deliveryAddress != null) {
      data['delivery_address'] = deliveryAddress!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['processing_time'] = processingTime;
    data['chat_permission'] = chatPermission;
    data['restaurant_model'] = restaurantModel;
    data['cutlery'] = cutlery;
    data['unavailable_item_note'] = unavailableItemNote;
    data['delivery_instruction'] = deliveryInstruction;
    data['order_proof'] = orderProof;
    if (payments != null) {
      data['payments'] = payments!.map((v) => v.toJson()).toList();
    }
    data['store_discount_amount'] = storeDiscountAmount;
    data['additional_charge'] = additionalCharge;
    return data;
  }
}

class DeliveryAddress {
  int? id;
  String? addressType;
  String? contactPersonNumber;
  String? address;
  String? latitude;
  String? longitude;
  int? userId;
  String? contactPersonName;
  String? createdAt;
  String? updatedAt;
  int? zoneId;
  String? streetNumber;
  String? house;
  String? floor;

  DeliveryAddress(
      {this.id,
        this.addressType,
        this.contactPersonNumber,
        this.address,
        this.latitude,
        this.longitude,
        this.userId,
        this.contactPersonName,
        this.createdAt,
        this.updatedAt,
        this.zoneId,
        this.streetNumber,
        this.house,
        this.floor});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    contactPersonNumber = json['contact_person_number'];
    address = json['address'];
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    userId = json['user_id'];
    contactPersonName = json['contact_person_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    zoneId = json['zone_id'];
    streetNumber = json['road'];
    house = json['house'];
    floor = json['floor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_type'] = addressType;
    data['contact_person_number'] = contactPersonNumber;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['user_id'] = userId;
    data['contact_person_name'] = contactPersonName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['zone_id'] = zoneId;
    data['road'] = streetNumber;
    data['house'] = house;
    data['floor'] = floor;
    return data;
  }
}

class Customer {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? cmFirebaseToken;

  Customer(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.cmFirebaseToken});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cmFirebaseToken = json['cm_firebase_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['cm_firebase_token'] = cmFirebaseToken;
    return data;
  }
}

class Payments {
  int? id;
  int? orderId;
  double? amount;
  String? paymentStatus;
  String? paymentMethod;
  String? createdAt;
  String? updatedAt;

  Payments({this.id,
    this.orderId,
    this.amount,
    this.paymentStatus,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt});

  Payments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    amount = json['amount']?.toDouble();
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['amount'] = amount;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}