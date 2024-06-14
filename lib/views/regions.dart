import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../services/extension.dart';
import '../services/helper.dart';

class LoadRegions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadRegions(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              ),
            );
          } else {
            // Data loaded successfully, pass it to Regions widget
            Map<String, dynamic> regions = snapshot.data!;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Regions',
              home: Regions(regions: regions),
            );
          }
        }
      },
    );
  }
}

class Regions extends StatefulWidget {
  final Map<String, dynamic> regions;

  Regions({required this.regions});

  @override
  _RegionsState createState() => _RegionsState();
}

class _RegionsState extends State<Regions> {
  String? _selectedProvinsi;
  String? _selectedKabupaten;
  String? _selectedKecamatan;
  String? _selectedDesa;
  String result = "";

  @override
  void initState() {
    super.initState();
    _selectedProvinsi = null;
    _selectedKabupaten = null;
    _selectedKecamatan = null;
    _selectedDesa = null;
    result = "";
  }

  void _onProvinsiChanged(String? newValue) {
    setState(() {
      _selectedProvinsi = newValue;
      _selectedKabupaten = null;
      _selectedKecamatan = null;
      _selectedDesa = null;
      result = "Provinsi: " +
          widget.regions[newValue]['nama'].toString().toProperCase;
    });
  }

  void _onKabupatenChanged(String? newValue) {
    setState(() {
      _selectedKabupaten = newValue;
      _selectedKecamatan = null;
      _selectedDesa = null;
      result += "\nKabupaten: " +
          widget.regions[_selectedProvinsi]['children'][_selectedKabupaten]
                  ["nama"]
              .toString()
              .toProperCase
              .removeWords(["Kab. ", "Kota"]);
    });
  }

  void _onKecamatanChanged(String? newValue) {
    setState(() {
      _selectedKecamatan = newValue;
      _selectedDesa = null;
      result += "\nKecamatan: " +
          widget.regions[_selectedProvinsi]['children'][_selectedKabupaten]
                  ["children"][_selectedKecamatan]["nama"]
              .toString()
              .toProperCase;
    });
  }

  void _onDesaChanged(String? newValue) {
    setState(() {
      _selectedDesa = newValue;
      result += "\nDesa: " +
          widget.regions[_selectedProvinsi]['children'][_selectedKabupaten]
                  ["children"][_selectedKecamatan]["children"][_selectedDesa]
                  ["nama"]
              .toString()
              .toProperCase;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Desa',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              isExpanded: true,
              elevation: 8,
              hint: Text('Select Provinsi'),
              value: _selectedProvinsi,
              onChanged: _onProvinsiChanged,
              items: widget.regions.keys
                  .map<DropdownMenuItem<String>>((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child:
                      Text(widget.regions[key]['nama'].toString().toProperCase),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Desa',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              isExpanded: true,
              elevation: 8,
              hint: Text('Select Kabupaten'),
              value: _selectedKabupaten,
              onChanged: _onKabupatenChanged,
              items: _selectedProvinsi != null
                  ? (widget.regions[_selectedProvinsi!]['children']
                          as Map<String, dynamic>)
                      .keys
                      .map<DropdownMenuItem<String>>((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(widget.regions[_selectedProvinsi!]
                                ['children'][key]['nama']
                            .toString()
                            .toProperCase
                            .removeWords(["Kab. ", "Kota"])),
                      );
                    }).toList()
                  : [],
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Desa',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              isExpanded: true,
              elevation: 8,
              hint: Text('Select Kecamatan'),
              value: _selectedKecamatan,
              onChanged: _onKecamatanChanged,
              items: _selectedKabupaten != null
                  ? (widget.regions[_selectedProvinsi!]['children']
                              [_selectedKabupaten!]['children']
                          as Map<String, dynamic>)
                      .keys
                      .map<DropdownMenuItem<String>>((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(widget.regions[_selectedProvinsi!]
                                ['children'][_selectedKabupaten!]['children']
                            [key]['nama']),
                      );
                    }).toList()
                  : [],
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Desa',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              isExpanded: true,
              elevation: 8,
              hint: Text('Select Desa'),
              value: _selectedDesa,
              onChanged: _onDesaChanged,
              items: _selectedKecamatan != null
                  ? (widget.regions[_selectedProvinsi!]['children']
                                  [_selectedKabupaten!]['children']
                              [_selectedKecamatan!]['children']
                          as Map<String, dynamic>)
                      .keys
                      .map<DropdownMenuItem<String>>((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(widget.regions[_selectedProvinsi!]
                                ['children'][_selectedKabupaten!]['children']
                            [_selectedKecamatan!]['children'][key]['nama']),
                      );
                    }).toList()
                  : [],
            ),
            SizedBox(height: 20.0),
            Text(result)
          ],
        ),
      ),
    );
  }
}
