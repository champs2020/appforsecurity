import 'package:local_auth_device_credentials/auth_strings.dart';
import 'package:local_auth_device_credentials/error_codes.dart';
import 'package:local_auth_device_credentials/local_auth.dart';
import 'package:flutter/services.dart';

class Fingerprint{


  final LocalAuthentication auth = LocalAuthentication();

  Future checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      return canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future getAvailableBiometrics() async {
    try {
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      return availableBiometrics;

    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(

          localizedReason: 'Autenticação por impressão digital',
          useErrorDialogs: true,
          stickyAuth: true
      );

      return authenticated;

    } on PlatformException catch (e) {
      print(e);
    }
  }

  void cancelAuthentication() {
    auth.stopAuthentication();
  }

}