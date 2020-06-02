import 'package:countrypickerflutter/bloc/country_list_bloc.dart';
import 'package:countrypickerflutter/bloc/country_list_event.dart';
import 'package:countrypickerflutter/bloc/country_list_state.dart';
import 'package:countrypickerflutter/country_model.dart';
import 'package:countrypickerflutter/debouncer.dart';
import 'package:countrypickerflutter/functionality.dart';
import 'package:flutter/material.dart';

class CountryPickerScreen extends StatefulWidget {
  final CountryListBloc _bloc;

  CountryPickerScreen(this._bloc);

  @override
  _CountryPickerScreenState createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends State<CountryPickerScreen> with Functionality {
  bool showAppBar = true;

  @override
  void initState() {
    super.initState();
    widget._bloc.eventController.add(FetchCountryList());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!showAppBar) {
          setState(() {
            widget._bloc.eventController.add(FetchCountryList());
            showAppBar = true;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: _buildSearchBar(),
        body: SafeArea(
          child: _validateResult(),
        ),
      ),
    );
  }

  Widget _validateResult() {
    return StreamBuilder<CountryListState>(
        stream: widget._bloc.stateController,
        builder: (context, snapshot) {
          if (snapshot.data is LoadedState) {
            LoadedState data = snapshot.data;
            return _buildCountryList(data.countryList);
          } else {
            return Container();
          }
        });
  }

  Widget _buildCountryList(List<CountryModel> countryList) {
    return ListView.builder(
        itemCount: countryList.length,
        itemBuilder: (_, index) {
          return ListTile(
            leading: Text(
              codeToCountryEmoji(countryList[index].alpha2Code),
              style: TextStyle(fontSize: 24),
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
                (countryList[index].isSelected == null ||
                        !countryList[index].isSelected)
                    ? Container(
                        width: 24,
                      )
                    : Icon(Icons.check),
              ],
            ),
            selected: countryList[index].isSelected,
            onTap: () {
              widget._bloc.eventController
                  .add(SelectCountry(countryList[index], context));
            },
          );
        });
  }

  _buildSearchBar() {
    final TextEditingController _controller = TextEditingController();
    if (showAppBar) {
      return AppBar(
        title: Text("Choose a country"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                showAppBar = false;
              });
            },
          )
        ],
      );
    } else {
      return AppBar(
        title: TextField(
          controller: _controller,
          style: TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration.collapsed(
            hintText: "Search...",
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          onChanged: (value) {
            Debouncer(milliseconds: 500).run(() {
              widget._bloc.eventController.add(SearchCountry(value));
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                widget._bloc.eventController.add(FetchCountryList());
                showAppBar = true;
              });
            },
          )
        ],
      );
    }
  }
}
