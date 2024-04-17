import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSaver {
  static const String NAMEKEY = 'NAMEKEKEY';
  static const String EMAILKEY = 'EMAILKEY';
  static const String WALLETKEY = 'WALLETKEY';

  LocalDataSaver() {
    _getSharedPreferencesInstance();
  }

  late SharedPreferences _sharedPreferences;
  Future<void> _getSharedPreferencesInstance() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }



  Future<bool?> saveName(String? name) async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    return _sharedPreferences.setString(NAMEKEY, name!);
  }

  Future<bool?> saveEmail(String? email) async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    return _sharedPreferences.setString(EMAILKEY, email!);
  }

  Future<bool?> saveWalletAmount(int? wallet) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.setInt(WALLETKEY, wallet!);
  }

  Future<String?> getName() async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    return _sharedPreferences.getString(NAMEKEY);
  }

  Future<String?> getEmail() async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    return _sharedPreferences.getString(EMAILKEY);
  }

  Future<int?> getWalletAmount() async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    return _sharedPreferences.getInt(WALLETKEY);
  }
}
