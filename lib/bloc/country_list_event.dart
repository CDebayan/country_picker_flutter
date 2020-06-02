import 'package:countrypickerflutter/country_model.dart';
import 'package:flutter/cupertino.dart';

abstract class CountryListEvent{}

class FetchCountryList extends CountryListEvent{}

class SearchCountry extends CountryListEvent{
  final String text;

  SearchCountry(this.text);
}

class SelectCountry extends CountryListEvent{
  final CountryModel countryModel;
  final BuildContext context;

  SelectCountry(this.countryModel,this.context);
}