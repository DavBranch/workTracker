const String base_url = 'https://phplaravel-885408-3069483.cloudwaysapps.com';
const api_url = '$base_url/api';



class Api {
  //Login
  static String get login => '$api_url/login';
  static String get logout => '$api_url/logout';
  static String get refresh => '$api_url/refresh';

  //User api
  static String get updateLocation => '$api_url/location';
  static String get startAndEndActions => '$api_url/action';
  //Admin api
      //User api
      static String get getAllUsers => '$api_url/users';
      static String getUser(String id) => '$api_url/users/$id';
      static String deleteUser(int id) => '$api_url/users/$id';


  static String updateUser(int id) => '$api_url/users/$id';
      static String get createUsers => '$api_url/users';
      //Info users
      static String allInfo(String? dateTime)=>  '$api_url/info?date=$dateTime';
      static String  getInfo(String id) => '$api_url/info/$id';








}