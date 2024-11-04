import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final galleryStatus = await Permission.photos.request();

    if (cameraStatus.isGranted && galleryStatus.isGranted) {
      _showImageSourceDialog();
    } else {
      _showPermissionDeniedDialog();
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      _showErrorDialog("No image selected.");
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permissions Denied"),
          content: Text("Please allow camera and gallery access to upload images."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Image successfully submitted!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Logo Image positioned in the top left corner
            Positioned(
              top: 20,
              left: 20,
              child: Image.network(
                'https://s3-eu-west-1.amazonaws.com/tpd/logos/5e904d09bf6eb70001f7b109/0x0.png',
                height: 150, // Set the height of the logo
              ),
            ),
            // Centering the rest of the UI
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Centered text below the logo
                  SizedBox(height: 30), // Spacing for the logo
                  Text(
                    "Upload Image",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Grey background for the upload button row
                  Container(
                    color: Colors.grey[200],
                    padding: EdgeInsets.symmetric(vertical: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_image == null)
                          IconButton(
                            icon: Icon(Icons.add_circle, color: Color.fromARGB(255, 24, 11, 139), size: 70),
                            onPressed: _requestPermissions,
                          )
                        else
                          Column(
                            children: [
                              Image.file(
                                _image!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.black,
                                    iconSize: 40,
                                    onPressed: () => _requestPermissions(),
                                  ),
                                  SizedBox(width: 40),
                                  IconButton(
                                    icon: Icon(Icons.check_circle),
                                    color: Colors.black,
                                    iconSize: 40,
                                    onPressed: _showSuccessDialog,
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
