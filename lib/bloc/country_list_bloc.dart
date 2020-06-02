import 'dart:async';

import 'package:countrypickerflutter/bloc/country_list_event.dart';
import 'package:countrypickerflutter/bloc/country_list_state.dart';
import 'package:countrypickerflutter/country_list.dart';
import 'package:countrypickerflutter/country_model.dart';
import 'package:countrypickerflutter/functionality.dart';
import 'package:flutter/cupertino.dart';

class CountryListBloc with Functionality{
  final _countryListStateController = StreamController<CountryListState>.broadcast();
  final _countryListEventController = StreamController<CountryListEvent>.broadcast();
  List<CountryModel> _countryList;

  Stream<CountryListState> get stateController =>
      _countryListStateController.stream;

  Sink<CountryListEvent> get eventController =>
      _countryListEventController.sink;


  List<CountryModel> get countryList => _countryList;

  CountryListBloc() {
    _countryListEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CountryListEvent event) async {
    if (event is FetchCountryList) {
      if (isValidList(_countryList)) {
        _countryListStateController.sink.add(LoadedState(_countryList));
      }else{
        fetchCountryList();
        _countryListStateController.sink.add(LoadedState(_countryList));
      }
    } else if (event is SearchCountry) {
      var _filteredList = _countryList.where((element) {
        String name = element.name;
        String code = element.callingCodes;
        return name.toLowerCase().contains(event.text.toLowerCase()) ||
            code.toLowerCase().contains(event.text.toLowerCase());
      }).toList();
      _countryListStateController.sink.add(LoadedState(_filteredList));
    } else if (event is SelectCountry) {
      updateSelectedCountry(event.countryModel);
      Navigator.pop(event.context,event.countryModel);
    }
  }

  void fetchCountryList() {
    List<CountryModel> _list = listOfCountries.map((json) => CountryModel.fromJson(json)).toList();
    _countryList = _list;
  }

  void updateSelectedCountry(CountryModel countryModel) {
    for (int i = 0; i < _countryList.length; i++) {
      _countryList[i].isSelected = false;
    }
    if(isValidObject(countryModel)){
      countryModel.isSelected = true;
    }
  }

  void dispose() {
    _countryListStateController.close();
    _countryListEventController.close();
  }
}
