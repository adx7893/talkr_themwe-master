import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:talkr_demo/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// ignore: library_prefixes
import 'package:image/image.dart' as Im;
import 'package:talkr_demo/widgets/progress.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';

class PostScreen extends StatefulWidget {
  late final Userr currentUser;
  String location = 'Null, Press Button';
  String Address = 'search';

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        (await placemarkFromCoordinates(position.latitude, position.longitude))
            .cast<Placemark>();
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
        ' ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  @override
  _PostScreenState createState() => _PostScreenState();

  void setState(Null Function() param0) {}
}

class _PostScreenState extends State<PostScreen>
    with AutomaticKeepAliveClientMixin<PostScreen> {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  late File file;
  @override
  void initstate() {
    file = file;
    super.initState();
  }

  bool isUploading = false;
  String postId = const Uuid().v4();

  get storageRef => null;

  get postRef => null;

  handleTakePhoto() async {
    Navigator.pop(context);
    File file = (await ImagePicker().pickImage(
      source: ImageSource.camera,
    )) as File;
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File file =
        (await ImagePicker().pickImage(source: ImageSource.gallery)) as File;
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text("Photo with Camera"),
                onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: const Text("Image from Gallery"),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Container buildSplashScreen() {
    return Container(
      // ignore: deprecated_member_use
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            // ignore: deprecated_member_use
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  "Upload Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
                color: Colors.deepOrange,
                onPressed: () => selectImage(context)),
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = File as File;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore(
      {required String mediaUrl,
      required String location,
      required String description}) {
    postRef
        .document(widget.currentUser.id)
        .collection("userPosts")
        .document(postId)
        .setData({
      "postId": postId,
      "ownerId": widget.currentUser.id,
      "username": widget.currentUser.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "likes": {},
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      file = File as File;
      isUploading = false;
      postId = const Uuid().v4();
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: const Text(
          "Caption Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : const Text(""),
          SizedBox(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.currentUser.photoUrl),
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: const InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35.0,
            ),
            title: SizedBox(
              width: 250.0,
              child: TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                Position position = _getGeoLocationPosition() as Position;
                var location =
                    'Lat: ${position.latitude} , Long: ${position.longitude}';
                GetAddressFromLatLong(position);
              },
              child: Text('Get Location'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}

class GetAddressFromLatLong {
  GetAddressFromLatLong(Position position);
}

class _getGeoLocationPosition {}

class Placemark {
  var subLocality;
  get country => null;
  get subAdministrativeArea => null;
  get locality => null;
  get administrativeArea => null;
  get subThoroughfare => null;
  get thoroughfare => null;
  get postalCode => null;
}

class LocationAccuracy {
  // ignore: prefer_typing_uninitialized_variables
  static var high;
}

class Geolocator {
  getCurrentPosition({desiredAccuracy}) {}

  placemarkFromCoordinates(var latitude, var longitude) {}
}

class StorageTaskSnapshot {
  get ref => null;
}

class StorageUploadTask {
  get onComplete => null;
}
