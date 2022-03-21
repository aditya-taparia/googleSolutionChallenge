import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googlesolutionchallenge/widgets/country_codes.dart';
import 'package:side_header_list_view/side_header_list_view.dart';

class PhoneNumber extends StatefulWidget {
  final TextEditingController phoneController;
  final TextEditingController codeController;
  const PhoneNumber(
      {Key? key, required this.phoneController, required this.codeController})
      : super(key: key);

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  String countryCode = '+91';
  String country = 'IN';
  String phoneNumber = '';

  // Saving data from previous screen
  Future<void> _getCountryAndCode(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CountryList(),
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          widget.codeController.text = value['countryCode'];
          countryCode = value['countryCode'];
          country = value['country'];
        });
      }
    });
  }

  String getNumber() {
    return countryCode + phoneNumber;
  }

  @override
  void initState() {
    widget.codeController.text = countryCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            primary: const Color.fromRGBO(66, 103, 178, 1),
            fixedSize: const Size(125, 40),
          ),
          onPressed: () async {
            await _getCountryAndCode(context);
          },
          child: Text(
            '$country : $countryCode',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 10,
            controller: widget.phoneController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
            onChanged: (value) {
              phoneNumber = value;
            },
            onFieldSubmitted: (value) {
              if (kDebugMode) {
                print(countryCode);
              }
              widget.phoneController.text =
                  countryCode + widget.phoneController.text;
            },
            cursorColor: const Color.fromRGBO(66, 103, 178, 1),
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Phone Number',
              hintStyle: const TextStyle(fontSize: 16),
              contentPadding: const EdgeInsets.all(12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(66, 103, 178, 1),
                ),
              ),
              isDense: false,
            ),
          ),
        ),
      ],
    );
  }
}

class CountryList extends StatefulWidget {
  const CountryList({Key? key}) : super(key: key);

  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  String countryCode = '+91';
  String country = 'IN';

  // Sending data back
  void _sendDataBack(BuildContext context, String cc, String c) {
    Map<String, String> data = {
      'countryCode': cc,
      'country': c,
    };
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    List<String> countryNames = [];
    for (var data in countryCodes) {
      countryNames.add(data['name']!);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Country'),
      ),
      backgroundColor: Colors.blueGrey[50],
      body: SideHeaderListView(
        itemExtend: 50.0,
        padding: const EdgeInsets.all(4.0),
        itemCount: countryCodes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              tileColor: Colors.blueGrey[50],
              dense: true,
              title: Text(
                '${countryCodes[index].values.toList()[0]} (${countryCodes[index].values.toList()[2]})',
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              onTap: () {
                countryCode = countryCodes[index].values.toList()[1];
                country = countryCodes[index].values.toList()[2];
                _sendDataBack(context, countryCode, country);
              },
              trailing: Text(
                countryCodes[index].values.toList()[1],
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          );
        },
        headerBuilder: (context, index) {
          return CircleAvatar(
            backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
            child: Text(
              countryNames[index][0],
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        hasSameHeader: (int a, int b) {
          return countryNames[a].substring(0, 1) ==
              countryNames[b].substring(0, 1);
        },
      ),
    );
  }
}
