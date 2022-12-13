import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRepository {
  static DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref("user");

  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<DatabaseEvent> checkMobileNumberExist(String mobileNumber) {
    return databaseReference
        .orderByChild("mobileNumber")
        .equalTo(mobileNumber)
        .once();
  }

  static Future addDataToFirebase(String mobileNumber) {
    return databaseReference
        .child(auth.currentUser!.uid)
        .push()
        .set({"userId": auth.currentUser!.uid, "mobileNumber": mobileNumber});
  }

  static Future updateLoggedInUser(ModelUser user) {
    return databaseReference.child(auth.currentUser!.uid).update({
      "firstName": user.firstName,
      "lastName": user.lastName,
      "mobileNumber": user.mobileNumber,
      "addressLine": user.address.addressLine,
      "city": user.address.city,
      "country": user.address.country,
      "state": user.address.state,
      "pincode": user.address.pinCode
    });
  }

  static Future login(String verificationId, String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    return await (await FirebaseAuth.instance.signInWithCredential(credential));
  }

  static Future<DataSnapshot> getLoggedInUserData() {
    return databaseReference.child(auth.currentUser!.uid).get();
  }
}

class ModelUser {
  String? firstName;
  String? lastName;
  String? mobileNumber;
  ModelAddress address;

  ModelUser(
      {this.firstName,
      this.lastName,
      this.mobileNumber,
      required this.address});
}

class ModelAddress {
  String? addressLine;
  String? city;
  String? state;
  String? country;
  String? pinCode;

  ModelAddress(
      {this.country, this.addressLine, this.city, this.pinCode, this.state});
}
