import 'package:dio/dio.dart';
import 'package:weather_forecast/common/constants.dart';
import 'package:weather_forecast/models/weather_data.dart';

class ApiProvider {
  Dio dio = Dio(BaseOptions(
    baseUrl: 'https://api.openweathermap.org/',
    connectTimeout: 20000,
    receiveTimeout: 60000,
  ));

  Future<AppData> weatherGet(String cityId) async {
    var param = {
      "id":cityId,
      "appid": Constants.apiID,
      "units": Constants.metric
    };
    try{
      var response = await dio.get("data/2.5/weather", queryParameters: param);
      AppData appData = AppData.fromJson(response.data);
      return appData;
      
    }on DioError catch(e){
      errorLog(e);
      return null;
    }
  }

  void errorLog(DioError e){
    if(e.response != null){
      print("data ${e.response.data}");
      print("header ${e.response.headers}");
      print("request ${e.response.request}");

    }else{
      print("request ${e.request}");
      print("message ${e.message}");
    }
  }

  
}