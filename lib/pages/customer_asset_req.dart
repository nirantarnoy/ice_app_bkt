import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image/image.dart' as Img;

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../providers/customer.dart';
import 'assetchecksuccess.dart';

class CustomerAssetRequest extends StatefulWidget {
  final String asset_customer_id;
  final String asset_customer_name;

  const CustomerAssetRequest(
      {Key key, this.asset_customer_id, this.asset_customer_name})
      : super(key: key);
  @override
  State<CustomerAssetRequest> createState() => _CustomerAssetRequestState();
}

class _CustomerAssetRequestState extends State<CustomerAssetRequest> {
  final TextEditingController _typeAheadController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'asset_no': null,
  };

  String selectedValue;
  int isuserconfirm = 0;
  String current_location = "";
  List<int> _deleteimage_selected = [];

  Future<XFile> file;
  String base64Image;
  List<String> base64Image2 = [];
  XFile tmpFile;

  // XFile uploadImage;
  String upload_status = '';
  String errMessage = 'Error uploading';

  XFile pickedImage;
  ImagePicker _imagePicker = ImagePicker();
  File _imageUpload;
  String fileName;

  String qrCode = 'Scan result';

  ///
  File image;
  List<File> image2 = [];

  Future chooseImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
          maxHeight: 400,
          maxWidth: 400,
          preferredCameraDevice: CameraDevice.rear);
      if (image == null) return;
      final imageTemp = File(image.path);
      List<int> imageBytes = imageTemp.readAsBytesSync();

      setState(() async {
        this.image = imageTemp;
        this.image2.add(imageTemp);
        base64Image = base64Encode(imageBytes);
        base64Image2.add(base64Encode(imageBytes));
        current_location = await _currentlocation();
        print("this is my location ${current_location}");
      });
      // print('image is ${base64Image}');
    } catch (err) {
      print(err);
      pickedImage = null;
    }
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> _currentlocation() async {
    Position position = await _getGeoLocationPosition();
    //String location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    String location = '${position.latitude},${position.longitude}';
    // print('my location is ${location}');
    return location;
  }

  Future<bool> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return false;
      setState(() {
        this.qrCode = qrCode;
        if (this.qrCode != '-1') {
          _typeAheadController.text = this.qrCode;
        }
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version';
    }
  }

  Widget _buildTextAssetNo() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'รหัสถัง/กระสอบ',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      controller: _typeAheadController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'กรุณากรอกรหัสผ่าน';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _showimagetaken(context, List<File> _image2) {
    return SingleChildScrollView(
      child: Container(
        //  height: MediaQuery.of(context).size.height * 0.9,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // Icon(
                //   Icons.check,
                //   color: Colors.green,
                // ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _deleteimage_selected.length <= 0
                      ? Text('')
                      : ElevatedButton(
                          child: Text(
                            "ลบ ${_deleteimage_selected.length}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () {
                            _deleteimage_selected.forEach((element) {
                              setState(() {
                                base64Image2.removeAt(element);
                                image2.removeAt(element);
                              });
                            });
                            setState(() {
                              _deleteimage_selected.clear();
                            });
                          },
                        ),
                ),
                SizedBox(width: 10),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    itemCount: _image2.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(children: [
                        Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onLongPress: () {
                                if (_deleteimage_selected.length > 0) {
                                  if (_deleteimage_selected.contains(index)) {
                                    setState(() {
                                      _deleteimage_selected
                                          .removeWhere((item) => item == index);
                                    });
                                  } else {
                                    setState(() {
                                      _deleteimage_selected.add(index);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _deleteimage_selected.add(index);
                                  });
                                }
                                print(_deleteimage_selected);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(_image2[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _deleteimage_selected.contains(index)
                            ? Positioned(
                                top: 0,
                                right:
                                    0, //give the values according to your requirement
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.red,
                                ),
                              )
                            : Text(''),
                      ]);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  startUpload(String _customer_id, String _asset_id, String _location) async {
    if (null == tmpFile) {
      setUploadStatus('Eroorrr');
    }
    // String filename = '';
    // String filename = tmpFile.path.split('/').last;
    // List<int> imageBytes = uploadImage.readAsBytesSync();
    // base64Image = base64Encode(imageBytes);
    // print('checklist is ${addCheckList}');

    bool issave = await Provider.of<CustomerData>(context, listen: false)
        .addNewAsset(base64Image2, _customer_id, _asset_id, _location);
    if (issave == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              AssetchecksuccessPage(customer_selected: _customer_id),
        ),
      );
    }
  }

  setUploadStatus(String message) {
    setState(() {
      upload_status = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มรายการอุปกรณ์',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => chooseImage(),
            icon: Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => startUpload(widget.asset_customer_id,
                _typeAheadController.text, current_location),
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "ลูกค้า : ${widget.asset_customer_name}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTextAssetNo(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () => scanQRCode(),
              child: Text("Scan QR Code",
                  style: TextStyle(
                    color: Colors.white,
                  ))),
          SizedBox(
            height: 20,
          ),
          Text(
            "รูปถ่าย",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          _showimagetaken(context, image2),
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.green,
            child: GestureDetector(
              onTap: () => {},
              child: Text("บันทึก",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
          )
        ]),
      ),
    );
  }
}
