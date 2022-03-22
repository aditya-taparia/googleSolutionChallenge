import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/widgets/form_widgets.dart';
import 'package:provider/provider.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({Key? key}) : super(key: key);

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _dateTimeShow = TextEditingController();
  final _dateTimeSend = TextEditingController();
  final _amount = TextEditingController();
  String _type = '';

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _dateTimeShow.dispose();
    _dateTimeSend.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    final GlobalKey<FormState> _formKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // To Validate the form: _formKey.currentState.validate()
                    TextInputField(
                      label: 'Title',
                      controller: _title,
                    ),
                    const SizedBox(height: 5),
                    TextInputField(
                      label: 'Description',
                      controller: _description,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                    const SizedBox(height: 5),
                    DateTimePicker(
                      label: 'Expected Completion Date',
                      controller: _dateTimeShow,
                      sendcontroller: _dateTimeSend,
                    ),
                    const SizedBox(height: 5),
                    TextInputField(
                      label: 'Promised Amount',
                      controller: _amount,
                      keyboardType: TextInputType.number,
                      prefix: const Text(
                        '₹ ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    DropdownField(
                      label: 'Type of Request',
                      onChanged: (value) {
                        _type = value.toString();
                      },
                      options: const [
                        'Job Request',
                        'Item Request',
                        'Community Service'
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            _title.clear();
                            _description.clear();
                            _dateTimeShow.clear();
                            _dateTimeSend.clear();
                            _amount.clear();
                            setState(() {
                              _type = '';
                            });
                          },
                          child: const Text('Clear'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // TODO: Validation
                            FirebaseFirestore.instance.collection('Posts').add({
                              'accepted-by': '',
                              'accepted-by-name': '',
                              'category': [_type.toLowerCase()],
                              'chat-id': '',
                              'completion-status': 'ongoing',
                              'description': _description.text,
                              'expected-completion-time': Timestamp.fromDate(
                                  DateTime.parse(_dateTimeSend.text)),
                              'given-by': user!.userid,
                              'given-by-name': await FirebaseFirestore.instance
                                  .collection('Userdata')
                                  .doc(user.userid)
                                  .get()
                                  .then((value) => value.data()!['name']),
                              'location': await Geolocator.getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.best)
                                  .then((value) => GeoPoint(
                                      value.latitude, value.longitude)),
                              'payment-status': 'pending',
                              'post-type': _type.toLowerCase(),
                              'promised-amount': num.parse(_amount.text),
                              'title': _title.text,
                              'waiting-list': [],
                            });
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
