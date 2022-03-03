// To parse this JSON data, do
//
//     final loginReqModel = loginReqModelFromJson(jsonString);

import 'dart:convert';

LoginReqModel loginReqModelFromJson(String str) =>
    LoginReqModel.fromJson(json.decode(str));

String loginReqModelToJson(LoginReqModel data) => json.encode(data.toJson());

class LoginReqModel {
  LoginReqModel({
    this.id,
    this.username,
    this.firstname,
    this.lastname,
    this.password,
    this.deviceTokens,
    this.email,
    this.phone,
    this.address,
    this.preferences,
    this.vendor,
    this.guardian,
    this.children,
  });

  String id;
  String username;
  String firstname;
  String lastname;
  String password;
  DeviceTokens deviceTokens;
  String email;
  String phone;
  String address;
  Preferences preferences;
  Vendor vendor;
  String guardian;
  List<String> children;

  factory LoginReqModel.fromJson(Map<String, dynamic> json) => LoginReqModel(
        id: json["_id"] == null ? null : json["_id"],
        username: json["username"] == null ? null : json["username"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        password: json["password"] == null ? null : json["password"],
        deviceTokens: json["deviceTokens"] == null
            ? null
            : DeviceTokens.fromJson(json["deviceTokens"]),
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        address: json["address"] == null ? null : json["address"],
        preferences: json["preferences"] == null
            ? null
            : Preferences.fromJson(json["preferences"]),
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
        guardian: json["guardian"] == null ? null : json["guardian"],
        children: json["children"] == null
            ? null
            : List<String>.from(json["children"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "username": username == null ? null : username,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "password": password == null ? null : password,
        "deviceTokens": deviceTokens == null ? null : deviceTokens.toJson(),
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "address": address == null ? null : address,
        "preferences": preferences == null ? null : preferences.toJson(),
        "vendor": vendor == null ? null : vendor.toJson(),
        "guardian": guardian == null ? null : guardian,
        "children": children == null
            ? null
            : List<dynamic>.from(children.map((x) => x)),
      };
}

class Preferences {
  Preferences({
    this.transport,
    this.travel,
    this.accessibleTransport,
    this.walkingSpeed,
  });

  Transport transport;
  Travel travel;
  AccessibleTransport accessibleTransport;
  WalkingSpeed walkingSpeed;

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        transport: json["transport"] == null
            ? null
            : Transport.fromJson(json["transport"]),
        travel: json["travel"] == null ? null : Travel.fromJson(json["travel"]),
        accessibleTransport: json["accessibleTransport"] == null
            ? null
            : AccessibleTransport.fromJson(json["accessibleTransport"]),
        walkingSpeed: json["walkingSpeed"] == null
            ? null
            : WalkingSpeed.fromJson(json["walkingSpeed"]),
      );

  Map<String, dynamic> toJson() => {
        "transport": transport == null ? null : transport.toJson(),
        "travel": travel == null ? null : travel.toJson(),
        "accessibleTransport":
            accessibleTransport == null ? null : accessibleTransport.toJson(),
        "walkingSpeed": walkingSpeed == null ? null : walkingSpeed.toJson(),
      };
}

class AccessibleTransport {
  AccessibleTransport({
    this.guideDogFriendly,
    this.stepFreeAccess,
    this.platformAssistance,
  });

  bool guideDogFriendly;
  bool stepFreeAccess;
  bool platformAssistance;

  factory AccessibleTransport.fromJson(Map<String, dynamic> json) =>
      AccessibleTransport(
        guideDogFriendly:
            json["guideDogFriendly"] == null ? null : json["guideDogFriendly"],
        stepFreeAccess:
            json["stepFreeAccess"] == null ? null : json["stepFreeAccess"],
        platformAssistance: json["platformAssistance"] == null
            ? null
            : json["platformAssistance"],
      );

  Map<String, dynamic> toJson() => {
        "guideDogFriendly": guideDogFriendly == null ? null : guideDogFriendly,
        "stepFreeAccess": stepFreeAccess == null ? null : stepFreeAccess,
        "platformAssistance":
            platformAssistance == null ? null : platformAssistance,
      };
}

class Transport {
  Transport({
    this.private,
    this.public,
  });

  String private;
  String public;

  factory Transport.fromJson(Map<String, dynamic> json) => Transport(
        private: json["private"] == null ? null : json["private"],
        public: json["public"] == null ? null : json["public"],
      );

  Map<String, dynamic> toJson() => {
        "private": private == null ? null : private,
        "public": public == null ? null : public,
      };
}

class Travel {
  Travel({
    this.rideSharing,
    this.routingPreference,
    this.distance,
  });

  bool rideSharing;
  String routingPreference;
  int distance;

  factory Travel.fromJson(Map<String, dynamic> json) => Travel(
        rideSharing: json["rideSharing"] == null ? null : json["rideSharing"],
        routingPreference: json["routingPreference"] == null
            ? null
            : json["routingPreference"],
        distance: json["distance"] == null ? null : json["distance"],
      );

  Map<String, dynamic> toJson() => {
        "rideSharing": rideSharing == null ? null : rideSharing,
        "routingPreference":
            routingPreference == null ? null : routingPreference,
        "distance": distance == null ? null : distance,
      };
}

class WalkingSpeed {
  WalkingSpeed({
    this.rapid,
    this.average,
    this.relaxed,
  });

  bool rapid;
  bool average;
  bool relaxed;

  factory WalkingSpeed.fromJson(Map<String, dynamic> json) => WalkingSpeed(
        rapid: json["rapid"] == null ? null : json["rapid"],
        average: json["average"] == null ? null : json["average"],
        relaxed: json["relaxed"] == null ? null : json["relaxed"],
      );

  Map<String, dynamic> toJson() => {
        "rapid": rapid == null ? null : rapid,
        "average": average == null ? null : average,
        "relaxed": relaxed == null ? null : relaxed,
      };
}

class Vendor {
  Vendor({
    this.locations,
    this.name,
    this.logo,
  });

  List<Location> locations;
  String name;
  String logo;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        locations: json["locations"] == null
            ? null
            : List<Location>.from(
                json["locations"].map((x) => Location.fromJson(x))),
        name: json["name"] == null ? null : json["name"],
        logo: json["logo"] == null ? null : json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "locations": locations == null
            ? null
            : List<dynamic>.from(locations.map((x) => x.toJson())),
        "name": name == null ? null : name,
        "logo": logo == null ? null : logo,
      };
}

class Location {
  Location({
    this.locationId,
    this.products,
  });

  String locationId;
  List<String> products;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationId: json["locationId"] == null ? null : json["locationId"],
        products: json["products"] == null
            ? null
            : List<String>.from(json["products"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "locationId": locationId == null ? null : locationId,
        "products": products == null
            ? null
            : List<dynamic>.from(products.map((x) => x)),
      };
}

class DeviceTokens {
  DeviceTokens({
    this.maaS,
    this.faaS,
    this.connie,
  });

  String maaS;
  String faaS;
  String connie;

  factory DeviceTokens.fromJson(Map<String, dynamic> json) => DeviceTokens(
        maaS: json["MaaS"] == null ? null : json["MaaS"],
        faaS: json["FaaS"] == null ? null : json["FaaS"],
        connie: json["Connie"] == null ? null : json["Connie"],
      );

  Map<String, dynamic> toJson() => {
        "MaaS": maaS == null ? null : maaS,
        "FaaS": faaS == null ? null : faaS,
        "Connie": connie == null ? null : connie,
      };
}
