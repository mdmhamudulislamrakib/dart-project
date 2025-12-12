import 'package:flutter/material.dart';
import 'package:weather_apps/model/weather_model.dart';
import 'package:intl/intl.dart';

class HourlyWeatherListitem extends StatelessWidget {
  final Hour? hour;
  const HourlyWeatherListitem({Key? key, this.hour}):super (key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.all(8) ,
      padding: EdgeInsets.all(8),
      width: 120,
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  hour?.tempC?.round().toString() ??"",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)
                        ),
              ),
             const Text(
              "o", 
              style: TextStyle(color: Colors.white)
              ),
            ],
          ),
          Container(
            height: 50,
            decoration: 
            BoxDecoration(shape: BoxShape.circle, color: Colors.teal),
            child: Image.network("https:${hour?.condition?.icon.toString()}"),
           
          ),
          Text(
            DateFormat.j().format(DateTime.parse(hour?.time?.toString() ?? "")), 
            style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}