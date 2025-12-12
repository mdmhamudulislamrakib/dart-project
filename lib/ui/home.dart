import 'package:flutter/material.dart';
import 'package:weather_apps/model/weather_model.dart';
import 'package:weather_apps/service/api_service.dart';
import 'components/hourly_weather_listitem.dart';

import 'package:weather_apps/ui/components/todays_weather.dart';
import 'components/future_forcast_listitem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ApiService apiService = ApiService();

  final _textFieldController = TextEditingController();
  String searchText = "auto:ip";

  _showTextInputDialog(BuildContext context) async {
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Search Location'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "search by city,zip"),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_textFieldController.text.isEmpty) {
                    return;
                  }
                  Navigator.pop(context, _textFieldController.text);
                },
                child: Text("ok"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Flutter weather app'),
        actions: [
          IconButton(
              onPressed: () async {
                _textFieldController.clear();
                String? text = await _showTextInputDialog(context);
                if (text != null && text.isNotEmpty) {
                  setState(() {
                    searchText = text;
                  });
                }
              },
              
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                setState(() {
                  searchText = "auto:ip";
                });
              },
              icon: Icon(Icons.my_location)),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: apiService.getWeatherData(searchText),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WeatherModel? weatherModel = snapshot.data;

              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    TodaysWeather(
                      weatherModel: weatherModel,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Weather  By  Hours",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 150,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            Hour? hour = weatherModel
                                ?.forecast?.forecastday?[0].hour?[index];

                            return HourlyWeatherListitem(
                              hour: hour,
                            );
                          },
                          itemCount: weatherModel
                              ?.forecast?.forecastday?[0].hour?.length,
                          scrollDirection: Axis.horizontal,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Next 3 Days Weather",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          Forecastday? forcastday =
                              weatherModel?.forecast?.forecastday?[index];

                          return FutureForcastListItem(
                            forecastday: forcastday,
                            localtime: weatherModel?.location?.localtime,
                          );
                        },
                        
                        itemCount:
                            weatherModel?.forecast?.forecastday?.length,
                      ),
                    )
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error has occured"),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}
