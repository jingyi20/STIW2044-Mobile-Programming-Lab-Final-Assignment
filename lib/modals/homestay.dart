class Homestay {
  String? homestayId;
  String? userId;
  String? homestayName;
  String? homestayDesc;
  String? homestayPrice;
  String? homestayAddress;
  String? homestayOwner;
  String? homestayContact;
  String? homestayState;
  String? homestayLocal;
  String? homestayLat;
  String? homestayDate;

  Homestay(
      {this.homestayId,
      this.userId,
      this.homestayName,
      this.homestayDesc,
      this.homestayPrice,
      this.homestayAddress,
      this.homestayOwner,
      this.homestayContact,
      this.homestayState,
      this.homestayLocal,
      this.homestayLat,
      this.homestayDate});

  Homestay.fromJson(Map<String, dynamic> json) {
    homestayId = json['homestay_id'];
    userId = json['user_id'];
    homestayName = json['homestay_name'];
    homestayDesc = json['homestay_desc'];
    homestayPrice = json['homestay_price'];
    homestayAddress = json['homestay_address'];
    homestayOwner = json['homestay_owner'];
    homestayContact = json['homestay_contact'];
    homestayState = json['homestay_state'];
    homestayLocal = json['homestay_local'];
    homestayLat = json['homestay_lat'];
    homestayDate = json['homestay_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['homestay_id'] = homestayId;
    data['user_id'] = userId;
    data['homestay_name'] = homestayName;
    data['homestay_desc'] = homestayDesc;
    data['homestay_price'] = homestayPrice;
    data['homestay_address'] = homestayAddress;
    data['homestay_owner'] = homestayOwner;
    data['homestay_contact'] = homestayContact;
    data['homestay_state'] = homestayState;
    data['homestay_local'] = homestayLocal;
    data['homestay_lat'] = homestayLat;
    data['homestay_date'] = homestayDate;
    return data;
  }
}