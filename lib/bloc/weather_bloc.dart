import 'package:rxdart/rxdart.dart';
import 'package:weather_forecast/common/constants.dart';
import 'package:weather_forecast/models/weather_data.dart';
import 'package:weather_forecast/network/apiProvider.dart';


class WeatherHomeBloc {

  final _appData = BehaviorSubject<AppData>();
  final _isLoading = BehaviorSubject<bool>();
  final _apiProvider = ApiProvider();

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<AppData> get appDataStream => _appData.stream;

  void dispose() async {
    await _appData.drain();
    _appData.close();
    await _isLoading.drain();
    _isLoading.close();
  }

  initData(){
    getAppData(Constants.klId);
  }

  Future<void> getAppData(String cityId) async {
    if (_isLoading.value != true) _isLoading.sink.add(true);

    var result = await _apiProvider.weatherGet(cityId);
    if(result != null){
      _appData.sink.add(result);
    }

    _isLoading.sink.add(false);
  }

  String getBGImage(String id, String icon){
    String image;
    String dayIndicator = icon.substring(2);
    String dayOrNight = dayIndicator == "d" ? "_day" : "_night";
    switch(id){
      case Constants.klId:
        image = "kl$dayOrNight";
      break;
      case Constants.jbId:
        image = "jb$dayOrNight";
      break;
      case Constants.georgeTownId:
        image = "georgetown$dayOrNight";
      break;
      default:
        image = "kl$dayOrNight";
    }

    return image;
  }

  

}