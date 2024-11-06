import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  ValueNotifier<File?> _imageNotifier = ValueNotifier<File?>(null);

  // Show the image source options (Camera or Gallery)
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
                onTap: () async {
                  Navigator.of(context).pop();
                  await _requestCameraPermission();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Gallery"),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _requestGalleryPermission();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Request camera permission
  Future<void> _requestCameraPermission() async {
    final cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      _pickImage(ImageSource.camera);
    } else {
      _showPermissionDeniedDialog("Camera access is required.");
    }
  }

  // Request gallery permission
  Future<void> _requestGalleryPermission() async {
    // Check for storage permission
    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) {
      _pickImage(ImageSource.gallery);
    } else {
      _showPermissionDeniedDialog("Gallery access is required.");
    }
  }

  // Pick image from the selected source (Camera or Gallery)
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _imageNotifier.value = File(pickedFile.path);
    } else {
      _showErrorDialog("No image selected.");
    }
  }

  // Show permission denied dialog
  void _showPermissionDeniedDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission Denied"),
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

  // Show error dialog
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

  // Show success dialog after image submission
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Image successfully uploaded!"),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: Image.network(
                'https://s3-eu-west-1.amazonaws.com/tpd/logos/5e904d09bf6eb70001f7b109/0x0.png',
                height: screenHeight * 0.15,
              ),
            ),
            
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    "Upload Image",
                    style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.02),
              
                  Container(
                    color: Colors.grey[200],
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
                    child: ValueListenableBuilder<File?>(
                      valueListenable: _imageNotifier,
                      builder: (context, image, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (image == null)
                              IconButton(
                                icon: Icon(Icons.add_circle, color: Color.fromARGB(255, 24, 11, 139), size: screenHeight * 0.07),
                                onPressed: _showImageSourceDialog,
                              )
                            else
                              Column(
                                children: [
                                  Image.file(
                                    image,
                                    height: screenHeight * 0.25,
                                    width: screenWidth * 0.5,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        color: Colors.black,
                                        iconSize: screenWidth * 0.1,
                                        onPressed: _showImageSourceDialog,
                                      ),
                                      SizedBox(width: screenWidth * 0.1),
                                      IconButton(
                                        icon: Icon(Icons.check_circle),
                                        color: Colors.black,
                                        iconSize: screenWidth * 0.1,
                                        onPressed: _showSuccessDialog,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        );
                      },
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
