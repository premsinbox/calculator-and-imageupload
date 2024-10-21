import 'package:calculator_and_imageupload/Upload/Model/image_model.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageController with ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  ImageModel imageModel = ImageModel();

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result.isGranted;
    }
  }


void clearImage() {
  imageModel.imagePath = null;
  notifyListeners();
}
  Future<bool> _requestGalleryPermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    }
    if (await Permission.photos.isGranted) {
      return true;
    }
    if (await Permission.storage.request().isGranted) {
      return true;
    }
    if (await Permission.photos.request().isGranted) {
      return true;
    }
    return false;
  }

  Future<String?> pickImageFromGallery() async {
    try {
      if (await _requestGalleryPermission()) {
        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          imageModel.imagePath = pickedFile.path;
          notifyListeners(); // Notify listeners of the state change
          return null;
        } else {
          return "No image selected";
        }
      } else {
        return "Gallery permission denied";
      }
    } catch (e) {
      return "Error picking image from gallery: $e";
    }
  }

  Future<String?> pickImageFromCamera({required bool useFrontCamera}) async {
    try {
      if (await _requestPermission(Permission.camera)) {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: useFrontCamera ? CameraDevice.front : CameraDevice.rear,
        );
        if (pickedFile != null) {
          imageModel.imagePath = pickedFile.path;
          notifyListeners(); // Notify listeners of the state change
          return null;
        } else {
          return "No image captured";
        }
      } else {
        return "Camera permission denied";
      }
    } catch (e) {
      return "Error capturing image: $e";
    }
  }
}
