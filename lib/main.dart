import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/regions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Regions"),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Get.to(LoadRegions());
                  },
                  child: Text("DATA REGIONS")),
            ],
          ),
        ),
      ),
    );
  }
}
