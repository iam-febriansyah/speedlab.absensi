// import 'package:flutter_application_1/api/base_url.dart';
// import 'package:flutter_application_1/models/auth/cls_post_login.dart';
// import 'package:flutter_application_1/models/auth/cls_return_login.dart';
// import 'package:flutter_application_1/models/cls_general_return.dart';
// import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
// import 'package:flutter_application_1/models/menu/cls_list_absen.dart';
// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';

// part 'service.g.dart';

// RestClient getClient({String? header}) {
//   final dio = Dio();
//   // dio.options.headers["Content-Type"] =
//   //     header == null || header.isEmpty ? "application/json" : header;
//   dio.options.connectTimeout = BaseUrl.connectTimeout;
//   RestClient client = RestClient(dio);
//   return client;
// }

// @RestApi(baseUrl: BaseUrl.MainUrls)
// abstract class RestClient {
//   factory RestClient(Dio dio) = _RestClient;

//   @POST("/Auth")
//   Future<ModelReturnLogin> postLogin(@Body() ModelPostLogin param);

//   @GET("/Absensi/absenhariini")
//   Future<ModelAbsenHariIni> getAbsenHariIni(
//       @Header("Authorization") String token);

//   @POST("/Absensi")
//   Future<ModelGeneralReturn> postAbsen(
//       @Header("Authorization") String token, @Body() Absen param);

//   @POST("/Absensi/updatefacedata")
//   Future<ModelGeneralReturn> updateFaceData(
//       @Header("Authorization") String token, @Body() DataUser param);

//   @GET("/Absensi/listabsen")
//   Future<ModelListAbsen> listAbsen(@Header("Authorization") String token);

//   // @POST("Auth/absen")
//   // Future<ModelGeneralReturn> postAbsen(
//   //     @Query("token") String prefToken, @Body() ModelPostAbsen param);
// }
