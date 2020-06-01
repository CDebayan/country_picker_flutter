abstract class CountryListEvent{}

class FetchCountryList extends CountryListEvent{}

class SearchCountry extends CountryListEvent{
  final String text;

  SearchCountry(this.text);
}