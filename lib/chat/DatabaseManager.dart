import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('UserProfile');

  Future createUserData(String name, String email, String uid) async {
    return await profileList.doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  Future getUsersList() async {
    List itemList = [];
    try {
      await profileList.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          itemList.add(element.data());
        });
      });
      return itemList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
