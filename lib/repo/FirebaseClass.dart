import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/ModelUser.dart';

/// this class is created to do all firebase operations
class FirebaseRepository {
  /// here we define the table name
  static DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref("user");

  static FirebaseAuth auth = FirebaseAuth.instance;

  /// this method is used to check where the given mobile number is already added or not
  static Future<DatabaseEvent> checkMobileNumberExist(String mobileNumber) {
    return databaseReference
        .orderByChild("mobileNumber")
        .equalTo(mobileNumber)
        .once();
  }

  // here once user is login then simply we insert the data in firebase database
  static Future addDataToFirebase(String mobileNumber) {
    return databaseReference
        .child(auth.currentUser!.uid)
        .push()
        .set({"userId": auth.currentUser!.uid, "mobileNumber": mobileNumber});
  }

  // suppose user is new then we simply update the information of user which is logged in
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

  // here we do login
  static Future login(String verificationId, String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    return await (await FirebaseAuth.instance.signInWithCredential(credential));
  }

  // this method is created to get the information of user logged in
  static Future<DataSnapshot> getLoggedInUserData() {
    return databaseReference.child(auth.currentUser!.uid).get();
  }
}
