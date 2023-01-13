import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/models/login/return.dart';
import 'package:flutter_application_1/provider/result_state.dart';
import 'package:flutter/material.dart';

class ProviderLogin extends ChangeNotifier {
  final DevService devService;

  ProviderLogin({required this.devService}) {}

  late ReturnLogin _returnLogin;
  late ResultState _state;
  String _message = '';
  String get message => _message;
  ReturnLogin get returnLogin => _returnLogin;
  ResultState get state => _state;

  String _username = '';
  String _password = '';

  void setLogin(String username, String password) {
    _username = username;
    _password = password;
  }

  Future<dynamic> get fetchLogin => _fetchLogin();

  Future<dynamic> _fetchLogin() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await devService.login(_username, _password);
      if (result == null) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _returnLogin = result;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
