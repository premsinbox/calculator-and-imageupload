import 'dart:io';
import 'package:calculator_and_imageupload/Constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Controller/image_controller.dart';

class ImagePickerScreen extends StatelessWidget {
  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 12.0), // Add padding

              child: ListTile(
                title: Text(
                  'Upload via',
                  style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            ListTile(
              leading: ClipOval(
                child: Container(
                  color: const Color(
                      0xFFEAEAEA), // Background color for the circular area
                  width: 40, // Width of the circular area
                  height: 40, // Height of the circular area
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 20, // Size of the icon
                    color: Colors.black,
                  ),
                ),
              ),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                Provider.of<ImageController>(context, listen: false)
                    .pickImageFromCamera(useFrontCamera: false);
              },
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: ClipOval(
                child: Container(
                  color: const Color(
                      0xFFEAEAEA), // Background color for the circular area
                  width: 40, // Width of the circular area
                  height: 40, // Height of the circular area
                  child: Icon(
                    Icons.image_outlined,
                    size: 20, // Size of the icon
                    color: Colors.black,
                  ),
                ),
              ),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                Provider.of<ImageController>(context, listen: false)
                    .pickImageFromGallery();
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
    var imageController = Provider.of<ImageController>(context);
    return SafeArea(child: LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'Upload Image',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => _showImageSourceBottomSheet(context),
                  child: Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      color: greycolor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: imageController.imageModel.imagePath == null
                        ? Icon(
                            Icons.add_circle,
                            size: 90,
                            color: maincolor,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(imageController.imageModel.imagePath!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 350,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (imageController.imageModel.imagePath != null)
                  //   Container(
                  //     width: 250,
                  //     child: ElevatedButton(
                  //       child: Text('Clear Image'),
                  //       onPressed: () {
                  //         Provider.of<ImageController>(context, listen: false)
                  //             .clearImage();
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         foregroundColor: Colors.white,
                  //         backgroundColor: Colors.red,
                  //       ),
                  //     ),
                  //   ),
                  // SizedBox(width: 20),
                  if (imageController.imageModel.imagePath != null)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () => _showImageSourceBottomSheet(context),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  SizedBox(
                    width: 20,
                  ),
                  if (imageController.imageModel.imagePath != null)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.check, color: Colors.white),
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Successfully uploaded'),
                            duration: Duration(
                                seconds:
                                    2), // Optional: Set how long the SnackBar should be visible
                          ),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      );
    }));
  }
}
