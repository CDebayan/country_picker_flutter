class CountryModel {
  String name;
  String alpha2Code;
  String callingCodes;
  String nativeName;
  bool isSelected = false;

  CountryModel(
      {this.name,
        this.alpha2Code,
        this.callingCodes,
        this.nativeName});

  CountryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    alpha2Code = json['alpha2Code'];
    callingCodes = json['callingCodes'];
    nativeName = json['nativeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['alpha2Code'] = this.alpha2Code;
    data['callingCodes'] = this.callingCodes;
    data['nativeName'] = this.nativeName;
    return data;
  }
}