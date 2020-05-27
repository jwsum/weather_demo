class AppData{
  List<WeatherData> weatherList;
  WeatherData weatherData;
  ConditionData condition;
  String cityName;
  String id;

  AppData.fromJson(Map<String, dynamic> data){
    this.weatherList = (data["weather"] as List).map((e) => WeatherData.fromJson(e as Map<String, dynamic>)).toList();
    this.condition = ConditionData.fromJson(data["main"]);
    this.cityName = data['name'];
    this.id = data['id'].toString();
    this.weatherData = weatherList[0];
  }
}

class WeatherData{
  int id;
  String main;
  String description;
  String icon;

  WeatherData.fromJson(Map<String, dynamic> data){
    this.id = data['id'];
    this.main = data['main'];
    this.description = data['description'];
    this.icon = data['icon'];
  }
}

class ConditionData{
  num temp;
  num feelsLike;
  num tempMin;
  num tempMax;
  num pressure;
  num humidity;

  ConditionData.fromJson(Map<String, dynamic> data){
    this.temp = data['temp'];
    this.feelsLike = data['feels_like'];
    this.tempMin = data['temp_min'];
    this.tempMax = data['temp_max'];
    this.pressure = data['pressure'];
    this.humidity = data['humidity'];
  }
}
  