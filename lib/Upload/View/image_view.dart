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
        return LayoutBuilder(
          builder: (context, constraints) {
            final double iconSize = constraints.maxWidth * 0.1; // 10% of width
            final double fontSize =
                constraints.maxWidth * 0.045; // 4.5% of width
            final double verticalPadding =
                constraints.maxHeight * 0.02; // 2% of height
            final double horizontalPadding =
                constraints.maxWidth * 0.02; // 2% of width
            final double leadingSize =
                constraints.maxWidth * 0.1; // 10% of width

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: ListTile(
                    title: Text(
                      'Upload via',
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          fontSize: fontSize * 1.2, // Slightly larger for title
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding * 2,
                    vertical: verticalPadding,
                  ),
                  leading: ClipOval(
                    child: Container(
                      color: const Color(0xFFEAEAEA),
                      width: leadingSize,
                      height: leadingSize,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: iconSize * 0.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Provider.of<ImageController>(context, listen: false)
                        .pickImageFromCamera(useFrontCamera: false);
                  },
                ),
                SizedBox(height: verticalPadding * 0.5),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: horizontalPadding * 3),
                  child: const Divider(),
                ),
                SizedBox(height: verticalPadding * 0.5),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding * 2,
                    vertical: verticalPadding,
                  ),
                  leading: ClipOval(
                    child: Container(
                      color: const Color(0xFFEAEAEA),
                      width: leadingSize,
                      height: leadingSize,
                      child: Icon(
                        Icons.image_outlined,
                        size: iconSize * 0.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: Text(
                    'Gallery',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Provider.of<ImageController>(context, listen: false)
                        .pickImageFromGallery();
                  },
                ),
                SizedBox(height: verticalPadding * 2),
              ],
            );
          },
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final double fontSize = constraints.maxWidth * 0.045;

            return AlertDialog(
              title: Text(
                'Error',
                style: TextStyle(fontSize: fontSize * 1.2),
              ),
              content: Text(
                message,
                style: TextStyle(fontSize: fontSize),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        final double maxImageHeight = constraints.maxHeight * 0.5;
        final double buttonSize = constraints.maxWidth * 0.15;
        final double spacing = constraints.maxHeight * 0.02;
        final double fontSize = constraints.maxWidth * 0.055;
        final double containerHeight = constraints.maxHeight * 1;

        return SafeArea(
          child: Scaffold(
            body: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                constraints.maxWidth * 0.04,
                constraints.maxHeight * 0.02,
                constraints.maxWidth * 0.04,
                constraints.maxHeight * 0.02,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: spacing),
                  Text(
                    'Upload Image',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing),
                  Expanded(
                    child: Consumer<ImageController>(
                      builder: (context, imageController, child) {
                        return GestureDetector(
                          onTap: () => _showImageSourceBottomSheet(context),
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxHeight: constraints.maxHeight * 0.25,
                            ),
                            decoration: BoxDecoration(
                              color: greycolor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: imageController.imageModel.imagePath == null
                                ? Icon(
                                    Icons.add_circle,
                                    size: constraints.maxWidth * 0.2,
                                    color: maincolor,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(imageController
                                          .imageModel.imagePath!),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: spacing),
                  Consumer<ImageController>(
                    builder: (context, imageController, child) {
                      if (imageController.imageModel.imagePath != null) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: buttonSize,
                              height: buttonSize,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: buttonSize * 0.5,
                                ),
                                onPressed: () =>
                                    _showImageSourceBottomSheet(context),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(width: spacing),
                            Container(
                              width: buttonSize,
                              height: buttonSize,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: buttonSize * 0.5,
                                ),
                                onPressed: () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Successfully uploaded',
                                      style:
                                          TextStyle(fontSize: fontSize * 0.8),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: spacing),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
