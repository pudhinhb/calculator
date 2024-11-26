import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ValueNotifier<File?> _imageNotifier = ValueNotifier<File?>(null);

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  await _requestCameraPermission();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  await _requestGalleryPermission();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      _pickImage(ImageSource.camera);
    } else {
      _showDialog("Permission Denied", "Camera access is required to take a photo.");
    }
  }

  Future<void> _requestGalleryPermission() async {
    PermissionStatus galleryStatus;

    if (Platform.isAndroid) {
  
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        
        galleryStatus = await Permission.photos.request();
      } else {
        
        galleryStatus = await Permission.storage.request();
      }
    } else {
      // For other platforms, skip this
      return;
    }

    if (galleryStatus.isGranted) {
      _pickImage(ImageSource.gallery);
    } else {
      _showDialog("Permission Denied", "Gallery access is required to upload an image.");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _imageNotifier.value = File(pickedFile.path);
    } else {
      _showDialog("Error", "No image selected.");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
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
            
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    "Upload Image",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
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
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Color.fromARGB(255, 24, 11, 139),
                                  size: screenHeight * 0.07,
                                ),
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
                                        onPressed: () => _showDialog("Success", "Image successfully uploaded!"),
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
