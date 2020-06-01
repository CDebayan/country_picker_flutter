import 'dart:async';

import 'package:countrypickerflutter/bloc/country_list_event.dart';
import 'package:countrypickerflutter/bloc/country_list_state.dart';
import 'package:countrypickerflutter/country_list.dart';
import 'package:countrypickerflutter/country_model.dart';

class CountryListBloc {
  final _countryListStateController = StreamController<CountryListState>();
  final _countryListEventController = StreamController<CountryListEvent>();
  List<CountryModel> _countryList;

  Stream<CountryListState> get stateController =>
      _countryListStateController.stream;

  Sink<CountryListEvent> get eventController =>
      _countryListEventController.sink;

  CountryListBloc() {
    _countryListEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CountryListEvent event) async {
    if (event is FetchCountryList) {
      List<CountryModel> _list =
          listOfCountries.map((json) => CountryModel.fromJson(json)).toList();
      _countryList = _list;
      _countryListStateController.sink.add(LoadedState(_list));
    } else if (event is SearchCountry) {
      var _filteredList = _countryList.where((element) {
        String name = element.name;
        String code = element.callingCodes;
        return name.toLowerCase().contains(event.text.toLowerCase()) ||
            code.toLowerCase().contains(event.text.toLowerCase());
      }).toList();
      _countryListStateController.sink.add(LoadedState(_filteredList));
    }
  }

  void dispose() {
    _countryListStateController.close();
    _countryListEventController.close();
  }
}
