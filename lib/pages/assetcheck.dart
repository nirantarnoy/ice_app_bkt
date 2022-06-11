import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ice_app_new/models/addchecklist.dart';
import 'package:ice_app_new/models/checklist.dart';
import 'package:ice_app_new/pages/assetchecksuccess.dart';
// import 'package:ice_app_new/models/customer_asset.dart';
// import 'package:ice_app_new/pages/take_photo.dart';
// import 'package:ice_app_new/providers/product.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ice_app_new/providers/customer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image/image.dart' as Img;
//import 'package:ice_app_new/providers/issuedata.dart';

// import 'package:ice_app_new/models/customers.dart';
// import 'package:ice_app_new/providers/customer.dart';

// import 'package:ice_app_new/models/products.dart';

class AssetcheckPage extends StatefulWidget {
  static const routeName = '/assetcheck';
  @override
  _AssetcheckPageState createState() => _AssetcheckPageState();
}

class _AssetcheckPageState extends State<AssetcheckPage> {
  final TextEditingController _typeAheadController = TextEditingController();
  String selectedValue;
  int isuserconfirm = 0;

  Future<XFile> file;
  String base64Image;
  XFile tmpFile;
  // XFile uploadImage;
  String upload_status = '';
  String errMessage = 'Error uploading';

  XFile pickedImage;
  ImagePicker _imagePicker = ImagePicker();
  File _imageUpload;
  String fileName;

  ///
  File image;

  List<bool> isSwitched;
  List<Addchecklist> addCheckList = [];

  var _isInit = true;
  var _isLoading = false;

  List<Checklist> check_list = [];

  final Checklist x = Checklist(id: "1", name: "จำนวนครบ");
  final Checklist xx = Checklist(id: "2", name: "สภาพดี");

  @override
  initState() {
    _checkinternet();
    check_list.add(x);
    check_list.add(xx);
    isSwitched = List<bool>.filled(10, false);
    // try {
    //   widget.model.fetchOrders();
    // } on TimeoutException catch (_) {
    //   _showdialog('Noity', 'Connection time out!');
    // }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<CustomerData>(context, listen: false)
          .fetCustomers()
          .then((_) {
        setState(() {
          _isLoading = false;

          // print('issue id is ${selectedIssue}');
        });
      });

      Provider.of<CustomerData>(context).fetChecklist();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future chooseImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 400,
          maxWidth: 400,
          preferredCameraDevice: CameraDevice.rear);
      if (image == null) return;
      final imageTemp = File(image.path);
      List<int> imageBytes = imageTemp.readAsBytesSync();

      setState(() {
        this.image = imageTemp;
        base64Image = base64Encode(imageBytes);
      });
      // print('image is ${base64Image}');
    } catch (err) {
      print(err);
      pickedImage = null;
    }
  }
  // Future<void> chooseImage() async {
  //   final ImagePicker _piker = ImagePicker();
  //   XFile xfile = await _piker.pickImage(source: ImageSource.camera);
  // }
  // Future<void> chooseImage() async {
  //   var choosedimage = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     uploadImage = choosedimage;
  //   });
  // }

  startUpload(String _customer_id, String _product_id) async {
    if (null == tmpFile) {
      setUploadStatus('Eroorrr');
    }
    // String filename = '';
    // String filename = tmpFile.path.split('/').last;
    // List<int> imageBytes = uploadImage.readAsBytesSync();
    // base64Image = base64Encode(imageBytes);
    // print('checklist is ${addCheckList}');

    bool issave = await Provider.of<CustomerData>(context, listen: false)
        .addChecklist(base64Image, addCheckList, _customer_id, _product_id);
    if (issave == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AssetchecksuccessPage(),
        ),
      );
    }
  }

  // showImage() {
  //   return FutureBuilder<XFile>(
  //     future: file,
  //     builder: (BuildContext context, AsyncSnapshot<XFile> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done &&
  //           null != snapshot.data) {
  //         tmpFile = snapshot.data;
  //         final bytes = snapshot.data.readAsBytesSync();
  //         base64Image = base64Encode(bytes);
  //         return Flexible(
  //           child: Image.file(
  //             snapshot.data,
  //             fit: BoxFit.fill,
  //           ),
  //         );
  //       } else if (null != snapshot.error) {
  //         return const Text(
  //           'Error Picking image',
  //           textAlign: TextAlign.center,
  //         );
  //       } else {
  //         return const Text('No Image Selected');
  //       }
  //     },
  //   );
  // }

  setUploadStatus(String message) {
    setState(() {
      upload_status = message;
    });
  }

  Future<void> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showdialog('No intenet', 'You are no internet connect');
    } else if (result == ConnectivityResult.mobile) {
      //_showdialog('Intenet access', 'You are connect mobile data');
    }
    if (result == ConnectivityResult.wifi) {
      //_showdialog('Intenet access', 'You are connect wifi');
    }
  }

  _showdialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  Widget _buildchecklist(List<Checklist> checks) {
    return ListView.builder(
        itemCount: checks.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text('${checks[index].name}'),
                trailing: Switch(
                  value: isSwitched[index],
                  onChanged: (value) {
                    setState(() {
                      isSwitched[index] = value;
                      if (value == true) {
                        Addchecklist select_data = new Addchecklist(
                          id: checks[index].id,
                          is_check: "1",
                        );
                        if (addCheckList.length > 0) {
                          addCheckList.forEach((element) {
                            if (element.id == checks[index].id) {
                              element.is_check = "1";
                              // addCheckList.removeWhere(
                              //     (item) => item.id == checks[index].order_id);
                            } else {
                              addCheckList.add(select_data);
                            }
                          });
                        } else {
                          addCheckList.add(select_data);
                        }
                      } else {
                        Addchecklist select_data = new Addchecklist(
                          id: checks[index].id,
                          is_check: "1",
                        );
                        //  addCheckList.add(select_data);

                        addCheckList.forEach((element) {
                          if (element.id == checks[index].id) {
                            element.is_check = "0";
                            // addCheckList.removeWhere(
                            //     (item) => item.id == checks[index].order_id);
                          }
                        });
                      }
                      print('add check ${addCheckList}');
                    });
                  },
                  activeTrackColor: Colors.blue[100],
                  activeColor: Colors.blueAccent,
                ),
              ),
              Divider(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final asset_date = ModalRoute.of(context).settings.arguments as Map; //
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.75;

    String _customer_id = asset_date['customer_id'];
    String _product_id = asset_date['product_id'];
    String _product_code = asset_date['product_code'];
    String _product_name = asset_date['product_name'];

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'บันทึกตรวจสอบอุปกรณ์',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          // padding: EdgeInsets.only(left: 10, right: 10, top: 15),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.blue[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "${_product_code} ${_product_name}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // OutlineButton(
              //     child: Text('Select image'),
              //     onPressed: () {
              //       chooseImage();
              //     }),

              Expanded(
                  child: Consumer<CustomerData>(
                      builder: (context, _customer, _) =>
                          _buildchecklist(_customer.listassetchecklist))),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: 250,
                  height: 250,
                  child: image != null ? Image.file(image) : Text("")),
              SizedBox(
                height: 10,
              ),

              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
                  child: SizedBox(
                    height: 45.0,
                    width: targetWidth,
                    child: new OutlinedButton(
                      // elevation: 0,
                      // splashColor: Colors.grey,
                      // shape: new RoundedRectangleBorder(
                      //     borderRadius: new BorderRadius.circular(30.0)),
                      // color: Colors.orange[300],
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Icon(Icons.camera_alt_rounded)),
                          Expanded(
                            child: new Text('ถ่ายรูป',
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.black)),
                          ),
                        ],
                      ),
                      onPressed: () => chooseImage(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: Colors.blue[800],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 5),
                              Text(
                                'บันทึก',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        startUpload(_customer_id, _product_id);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
