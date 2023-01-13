// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'service.dart';

// // **************************************************************************
// // RetrofitGenerator
// // **************************************************************************

// class _RestClient implements RestClient {
//   _RestClient(this._dio, {this.baseUrl}) {
//     baseUrl ??= 'http://absen.galeritekno.id';
//   }

//   final Dio _dio;

//   String? baseUrl;

//   @override
//   Future<ModelReturnLogin> postLogin(param) async {
//     const _extra = <String, dynamic>{};
//     final queryParameters = <String, dynamic>{};
//     final _data = <String, dynamic>{};
//     _data.addAll(param.toJson());
//     final _result = await _dio.fetch<Map<String, dynamic>>(
//         _setStreamType<ModelReturnLogin>(
//             Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
//                 .compose(_dio.options, '/Auth',
//                     queryParameters: queryParameters, data: _data)
//                 .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
//     final value = ModelReturnLogin.fromJson(_result.data!);
//     return value;
//   }

//   @override
//   Future<ModelAbsenHariIni> getAbsenHariIni(token) async {
//     const _extra = <String, dynamic>{};
//     final queryParameters = <String, dynamic>{};
//     final _data = <String, dynamic>{};
//     final _result = await _dio.fetch<Map<String, dynamic>>(
//         _setStreamType<ModelAbsenHariIni>(Options(
//                 method: 'GET',
//                 headers: <String, dynamic>{r'Authorization': token},
//                 extra: _extra)
//             .compose(_dio.options, '/Absensi/absenhariini',
//                 queryParameters: queryParameters, data: _data)
//             .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
//     final value = ModelAbsenHariIni.fromJson(_result.data!);
//     return value;
//   }

//   @override
//   Future<ModelGeneralReturn> postAbsen(token, param) async {
//     const _extra = <String, dynamic>{};
//     final queryParameters = <String, dynamic>{};
//     final _data = <String, dynamic>{};
//     _data.addAll(param.toJson());
//     final _result = await _dio.fetch<Map<String, dynamic>>(
//         _setStreamType<ModelGeneralReturn>(Options(
//                 method: 'POST',
//                 headers: <String, dynamic>{r'Authorization': token},
//                 extra: _extra)
//             .compose(_dio.options, '/Absensi',
//                 queryParameters: queryParameters, data: _data)
//             .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
//     final value = ModelGeneralReturn.fromJson(_result.data!);
//     return value;
//   }

//   @override
//   Future<ModelGeneralReturn> updateFaceData(token, param) async {
//     const _extra = <String, dynamic>{};
//     final queryParameters = <String, dynamic>{};
//     final _data = <String, dynamic>{};
//     _data.addAll(param.toJson());
//     final _result = await _dio.fetch<Map<String, dynamic>>(
//         _setStreamType<ModelGeneralReturn>(Options(
//                 method: 'POST',
//                 headers: <String, dynamic>{r'Authorization': token},
//                 extra: _extra)
//             .compose(_dio.options, '/Absensi/updatefacedata',
//                 queryParameters: queryParameters, data: _data)
//             .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
//     final value = ModelGeneralReturn.fromJson(_result.data!);
//     return value;
//   }

//   @override
//   Future<ModelListAbsen> listAbsen(token) async {
//     const _extra = <String, dynamic>{};
//     final queryParameters = <String, dynamic>{};
//     final _data = <String, dynamic>{};
//     final _result = await _dio.fetch<Map<String, dynamic>>(
//         _setStreamType<ModelListAbsen>(Options(
//                 method: 'GET',
//                 headers: <String, dynamic>{r'Authorization': token},
//                 extra: _extra)
//             .compose(_dio.options, '/Absensi/listabsen',
//                 queryParameters: queryParameters, data: _data)
//             .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
//     final value = ModelListAbsen.fromJson(_result.data!);
//     return value;
//   }

//   RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
//     if (T != dynamic &&
//         !(requestOptions.responseType == ResponseType.bytes ||
//             requestOptions.responseType == ResponseType.stream)) {
//       if (T == String) {
//         requestOptions.responseType = ResponseType.plain;
//       } else {
//         requestOptions.responseType = ResponseType.json;
//       }
//     }
//     return requestOptions;
//   }
// }
