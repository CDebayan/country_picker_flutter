import 'package:countrypickerflutter/country_list.dart';
import 'package:countrypickerflutter/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CountryPicker extends StatefulWidget {
  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  List<CountryModel> countryList;

  @override
  void initState() {
    super.initState();
    countryList =
        listOfCountries.map((json) => CountryModel.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: countryList.length,
          itemBuilder: (_, index) {
            return ListTile(
              leading: Image.asset(
                "flags/${countryList[index].alpha2Code.toLowerCase()}.png",
                height: 30,
                width: 30,
              ),
              title: Text(countryList[index].name),
              subtitle: Text(countryList[index].nativeName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "+${countryList[index].callingCodes}",
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  (countryList[index].isSelected == null || !countryList[index].isSelected)
                      ? Container(
                    width: 24,
                  )
                      : Icon(Icons.check),
                ],
              ),
            );
          }),
    );
  }
}
