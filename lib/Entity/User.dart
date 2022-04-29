class User {
  String name;
  String mail;
  String mobile;

  User({
    required this.name,
    required this.mail,
    required this.mobile,
  });

  fromJson(var jsonObj) {
    name = jsonObj['name'];
    mail = jsonObj['mail'];
    mobile = jsonObj['mobile'];
    return this;
  }
}
