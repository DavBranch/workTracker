import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:worktracker/services/data_provider/session_data_providers.dart';

import '../../base_data/base_api.dart';
import '../models/user.dart';
import '../models/user_info.dart';

class UserDataProvider {
  Client client = Client();

  final sessionDataProvider = SessionDataProvider();
  bool isTrue = false;

  static const maxAccesSeconds = 3600;

  static const maxRefreshSeconds = 216000000;
  int seconds = maxAccesSeconds;
  bool isAccesTokenTimerActive = false;
  bool isRefreshTokenTimerActive = false;

  get isDarkMode => null;

  void startAccessTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else {
        timer.cancel();
        isAccesTokenTimerActive = true;

      }
    });
  }

  void startRefreshTimer() {
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else {
        timer.cancel();
        isRefreshTokenTimerActive = true;

      }
    });
  }


  //Sign Up
  Future<bool> signUp(
      {required String userName,
        required String password,
        required  String firstName,required String lastName,required String role}) async {
    bool isSuscces;

    isSuscces = await createUserWithNAmeEmailAndPassword(
        userName: userName, password: password, firstName: firstName,lastName: lastName,role:role);

    return isSuscces;
  }

  //Login
  // LoginFuture<Map<String,dynamic>> logInWithEmailAndPassword({
  //   required String userName,
  //   required String password,
  // }) async {
  //   try {
  //    return
  //     await signInWithEmailAndPassword(userName: userName, password: password);
  //   } catch (e) {
  //     print(e);
  //   }
  //   return {};
  // }

  //Log out
  Future<void> logOut() async {
    try {
      await sessionDataProvider.deleteAllToken();
    } catch (e) {
      debugPrint('$e');

    }
  }

  //Login
  Future<Map<String,dynamic>?>? signInWithEmailAndPassword(
      {String? userName, String? password}) async {

    Map userData = {
      'username': userName,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse(Api.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );
      var body = jsonDecode(response.body);
      var status =body['status'];
      var data = body['data'];

      if (response.statusCode == 200 && status == true) {
        var accessToken = data['access_token'];
        var refreshToken = data['refresh_token'];
        var role = data['is_user'];
        sessionDataProvider.setAccessToken(accessToken);
        sessionDataProvider.setRole(role.toString());

        sessionDataProvider.setRefreshToken(refreshToken);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      debugPrint('$e');

    }
    return {};
  }

  //Signup
  Future<bool> createUserWithNAmeEmailAndPassword(
      {String? userName, String? password, String? firstName,String? lastName,String? role}) async {
    Map userData = {
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'username': userName,
      'role':role,
    };

    try {
      var response = await http.post(
        Uri.parse(Api.createUsers),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );
      var body = jsonDecode(response.body);
      var status = body['status'];
      if (status == true) {
        var accessToken = body['access_token'];
        var refreshToken = body['refresh_token'];
        var role = body['role'];
        sessionDataProvider.setAccessToken(accessToken);
        sessionDataProvider.setRole(role);
        sessionDataProvider.setRefreshToken(refreshToken);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('$e');

    }
    return false;
  }



  Future<bool> refreshToken() async {
    final refreshToken = await sessionDataProvider.readRefreshToken();
    final accessToken = await sessionDataProvider.readsAccessToken();
    if (refreshToken != null) {
      try {
        final response = await http.post(Uri.parse(Api.refresh), headers: {
          'Authorization': 'bearer $accessToken',
          'Contnet-type': "application/json",
        }, body: <String, dynamic>{
          'refresh_token': refreshToken,
        });

        var body = jsonDecode(response.body);

        if (response.statusCode == 200) {
          var accessToken = body['access_token'];

          sessionDataProvider.setAccessToken(accessToken);

          return true;
        } else if (isRefreshTokenTimerActive) {
          sessionDataProvider.deleteAllToken();
          return false;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }
  Future<User?> updateUser({firstName,lastName, userName,id}) async {
    final accessToken = await sessionDataProvider.readsAccessToken();

    Map userData = {
      'location': firstName,

    };

    try {
      final response = await http.post(Uri.parse(Api.updateUser(id)),
          headers: {
        'Contnet-type': "application/json",
        'Authorization': 'Bearer $accessToken'
      }, body:
        jsonEncode(userData)
      );

      var body = jsonDecode(response.body);
      var data = body['data'];
      var status = body['status'];


      if (status == true) {
     return User.fromJson(data);
      }
    } catch(e){
      debugPrint('$e');

    }
  return null;
  }

  Future<Map> updateMyAccountFromApi({firstName, lastName, jobTitle,id}) async {
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //String? token = sharedPreferences.getString('token');

    final requestBody = {};

    if (firstName != null && firstName != '') {
      requestBody["first_name"] = firstName;
    }

    if (lastName != null && lastName != '') {
      requestBody["last_name"] = lastName;
    }

    if (jobTitle != null) {
      requestBody["username"] = jobTitle;
    }
     requestBody['location'] = {'lat':'93095659','long':'374'};
    try {
      final response = await client.post(
          Uri.parse(Api.updateUser(id)),
          headers: {HttpHeaders.authorizationHeader: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3BocGxhcmF2ZWwtODg1NDA4LTMwNjk0ODMuY2xvdWR3YXlzYXBwcy5jb20vYXBpL2xvZ2luIiwiaWF0IjoxNjcwMTc3NTMwLCJleHAiOjE2NzAzOTM1MzAsIm5iZiI6MTY3MDE3NzUzMCwianRpIjoiY0VEcWZtQVNacDB2UmVVWCIsInN1YiI6IjEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.v9qp9O7AodhCmfpV9KwFXvDVVKLQiT63VIGYA_rO_eI"},
          body: requestBody
      ).timeout(const Duration(seconds: 10));

      return jsonDecode(response.body);
    } on TimeoutException catch (_) {
      return {
        'errors': {
          'network': 'Something went wrong'
        }
      };
    } on Error catch (_) {
      return {
        'errors': {
          'network': 'Something went wrong'
        }
      };
    } catch (_) {
      return {
        'errors': {
          'network': 'Something went wrong'
        }
      };
    }

  }
    Future<List<User>> getUser() async {
      var dialects = <User>[];
      try {
        var response = await http.get(
          Uri.parse(Api.getAllUsers),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        var body = json.decode(response.body);
        var success = body['status'];
        var datas = body['data'];
        if (success == true) {
          var user = List.from(datas).where((element) => element['role'] == 'user').toList().map((e) => User.fromJson(e)).toList();

          return user;
        } else {
          return dialects;
        }
      } catch (e) {
        throw Exception(e);
      }
    }
  Future<List<UserInfo>> getUserInfo({
    String? date,
    String? firstCall,
  }) async {
    var dialects = <UserInfo>[];
    String call = firstCall ?? '';
    try {
      var response = await http.get(
        Uri.parse(date!=null ?Api.allInfo(date): call),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var body = json.decode(response.body);
      var data = body['data'];

      if (response.statusCode == 200) {
        var user = List.from(data)
            .map(
              (e) => UserInfo.fromJson(e),
        )
            .toList();

        return user;
      } else {
        return dialects;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<UserInfo> getUserInfoById(int? id) async {
    var dialects = UserInfo();
    try {
      var response = await http.get(
        Uri.parse(Api.getInfo(id.toString())),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var body = json.decode(response.body);

      if (response.statusCode == 200) {
        var user = UserInfo.fromJson(body);

        return user;
      } else {
        return dialects;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
    Future<User> getUserById(String userId) async {
      var users = User();
      var response = await http.get(
        Uri.parse(Api.getUser(userId)),
        headers: <String, String>{
          'Content-Type': 'application/json',
         HttpHeaders.authorizationHeader: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3BocGxhcmF2ZWwtODg1NDA4LTMwNjk0ODMuY2xvdWR3YXlzYXBwcy5jb20vYXBpL2xvZ2luIiwiaWF0IjoxNjcwMTc3NTMwLCJleHAiOjE2NzAzOTM1MzAsIm5iZiI6MTY3MDE3NzUzMCwianRpIjoiY0VEcWZtQVNacDB2UmVVWCIsInN1YiI6IjEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.v9qp9O7AodhCmfpV9KwFXvDVVKLQiT63VIGYA_rO_eI",


        },
      );

      try {
        var body = json.decode(response.body);
       var data = body['data'];
        var success = body['success'];
        if (success == true) {
          // print('succes');




          return  User.fromJson(data);

        } else {
          return users;
        }
      } catch (e) {
        debugPrint('$e');

      }
      return users;
    }
  Future<bool> deleteUser(int id) async {
    try {
      var response = await http.delete(
        Uri.parse(Api.deleteUser(id)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var body = json.decode(response.body);
      var success = body['status'];
      if (success == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  }