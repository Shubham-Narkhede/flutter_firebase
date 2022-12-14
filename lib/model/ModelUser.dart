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
