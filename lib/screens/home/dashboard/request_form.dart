import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:googlesolutionchallenge/models/user.dart';
import 'package:googlesolutionchallenge/screens/home/dashboard/your_request_page.dart';
import 'package:googlesolutionchallenge/widgets/form_widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

class RequestForm extends StatefulWidget {
  final bool isEditRequest;
  final String? title;
  final String? description;
  final Timestamp? date;
  final double? amount;
  final String? postType;
  final String? postId;
  const RequestForm({
    Key? key,
    this.isEditRequest = false,
    this.title,
    this.description,
    this.date,
    this.amount,
    this.postType,
    this.postId,
  }) : super(key: key);

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _dateTimeShow = TextEditingController();
  final _dateTimeSend = TextEditingController();
  final _amount = TextEditingController();
  String _type = 'Job Request';

  @override
  void initState() {
    if (widget.isEditRequest) {
      _title.text = widget.title!;
      _description.text = widget.description!;
      _dateTimeSend.text = widget.date!.toDate().toString();
      _dateTimeShow.text = DateFormat.yMMMMd().format(widget.date!.toDate()).toString();
      _amount.text = widget.amount!.toString();
      _type = widget.postType!.toTitleCase();
    } else {
      _dateTimeShow.text = DateFormat.yMMMMd().format(DateTime.now()).toString();
      _dateTimeSend.text = DateTime.now().toString();
    }
    super.initState();
  }

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
    if (widget.postType != null) {
      _type = widget.postType ?? 'Job Request';
      _type = _type.toTitleCase();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditRequest ? 'Edit Request' : 'New Request'),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextInputField(
                      label: 'Description',
                      controller: _description,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please add some description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    DateTimePicker(
                      label: 'Expected Completion Date',
                      controller: _dateTimeShow,
                      sendcontroller: _dateTimeSend,
                      isEdit: widget.isEditRequest,
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the amount to be paid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    DropdownField(
                      label: 'Type of Request',
                      onChanged: (value) {
                        _type = value.toString();
                      },
                      options: const ['Job Request', 'Item Request', 'Community Service'],
                      initialValue: _type,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: !widget.isEditRequest
                              ? () {
                                  _title.clear();
                                  _description.clear();
                                  _dateTimeShow.clear();
                                  _dateTimeSend.clear();
                                  _amount.clear();
                                  setState(() {
                                    _type = 'Job Request';
                                  });
                                }
                              : () {
                                  Navigator.pop(context);
                                },
                          child: Text(!widget.isEditRequest ? 'Clear' : 'Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: !widget.isEditRequest
                              ? () async {
                                  if (_formKey.currentState!.validate() && _type != '') {
                                    FirebaseFirestore.instance.collection('Posts').add({
                                      'accepted-by': '',
                                      'accepted-by-name': '',
                                      'category': [_type.toLowerCase()],
                                      'chat-id': '',
                                      'completion-status': 'ongoing',
                                      'description': _description.text,
                                      'expected-completion-time': Timestamp.fromDate(DateTime.parse(_dateTimeSend.text)),
                                      'given-by': user!.userid,
                                      'given-by-name': await FirebaseFirestore.instance
                                          .collection('Userdata')
                                          .doc(user.userid)
                                          .get()
                                          .then((value) => value.data()!['name']),
                                      'location': await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
                                          .then((value) => GeoPoint(value.latitude, value.longitude)),
                                      'payment-status': 'pending',
                                      'post-type': _type.toLowerCase(),
                                      'promised-amount': num.parse(_amount.text),
                                      'title': _title.text,
                                      'waiting-list': [],
                                    }).then((value) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const YourRequestPage(),
                                          ));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_rounded,
                                                color: Colors.green[800],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Request Created',
                                                style: TextStyle(
                                                  color: Colors.green[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Colors.green[50],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 3,
                                        ),
                                      );
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.error_rounded,
                                              color: Colors.red[800],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Please fill all the fields',
                                              style: TextStyle(
                                                color: Colors.red[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.red[50],
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        elevation: 3,
                                      ),
                                    );
                                  }
                                }
                              : () async {
                                  if (_formKey.currentState!.validate() && _type != '') {
                                    FirebaseFirestore.instance.collection('Posts').doc(widget.postId).update({
                                      'category': [_type.toLowerCase()],
                                      'description': _description.text,
                                      'expected-completion-time': Timestamp.fromDate(DateTime.parse(_dateTimeSend.text)),
                                      'post-type': _type.toLowerCase(),
                                      'promised-amount': num.parse(_amount.text),
                                      'title': _title.text,
                                    }).then((value) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_rounded,
                                                color: Colors.green[800],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Request Updated',
                                                style: TextStyle(
                                                  color: Colors.green[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Colors.green[50],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 3,
                                        ),
                                      );
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.error_rounded,
                                              color: Colors.red[800],
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Please fill all the fields',
                                              style: TextStyle(
                                                color: Colors.red[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.red[50],
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        elevation: 3,
                                      ),
                                    );
                                  }
                                },
                          child: Text(!widget.isEditRequest ? 'Submit' : 'Update'),
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
