
class GlobalVariables {
  GlobalVariables._internal(); // Private constructor for singleton pattern

  static final GlobalVariables _instance = GlobalVariables._internal();

  factory GlobalVariables() {
    return _instance;
  }

  String BackEndUri = "https://2d0b-196-234-169-54.ngrok-free.app";


  String getSomeValue() {
    return BackEndUri;
  }

  void setSomeValue(String newValue) {
    // Add validation or logic here if needed
    BackEndUri = newValue;
  }
}
