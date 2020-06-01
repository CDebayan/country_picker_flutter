import 'package:countrypickerflutter/bloc/country_list_bloc.dart';
import 'package:countrypickerflutter/bloc/country_list_event.dart';
import 'package:countrypickerflutter/bloc/country_list_state.dart';
import 'package:countrypickerflutter/country_list.dart';
import 'package:countrypickerflutter/country_model.dart';
import 'package:countrypickerflutter/functionality.dart';
import 'package:flutter/material.dart';

class CountryPicker extends StatefulWidget {
  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> with Functionality {

  CountryListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CountryListBloc();
  _bloc.eventController.add(FetchCountryList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildSearchBar(),
            Expanded(
              child: _buildCountryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryList() {
    return StreamBuilder<CountryListState>(
        stream: _bloc.stateController,
        builder: (context, snapshot) {
          if(snapshot.data is LoadedState){
            LoadedState data = snapshot.data;
            return ListView.builder(
                itemCount: data.countryList.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: Text(
                      codeToCountryEmoji(data.countryList[index].alpha2Code),
                      style: TextStyle(fontSize: 24),
                    ),
                    title: Text(data.countryList[index].name),
                    subtitle: Text(data.countryList[index].nativeName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "+${data.countryList[index].callingCodes}",
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        (data.countryList[index].isSelected == null ||
                            !data.countryList[index].isSelected)
                            ? Container(
                          width: 24,
                        )
                            : Icon(Icons.check),
                      ],
                    ),
                  );
                });
          }else{
            return Container();
          }

        });
  }

  _buildSearchBar() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: TextField(
        decoration: InputDecoration(hintText: "Search Country"),
        onChanged: (value) {
          _bloc.eventController.add(SearchCountry(value));
        },
      ),
    );
  }

}
