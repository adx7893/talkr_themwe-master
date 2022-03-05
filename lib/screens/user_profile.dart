import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? username;
  String? email;

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseFirestore.instance;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: const Text("Profile Page")),
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              margin: const EdgeInsets.only(top: 20, left: 15),
              child: ClipOval(
                child: Container(
                  width: size.width / 2.7,
                  height: size.height / 4.5,
                  color: Colors.black12,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 235),
              child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection("test").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return GridView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 3),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot x = snapshot.data!.docs[index];
                        if (snapshot.hasData) {
                          return Card(
                            child: Image.network(x[index]),
                          );
                        }
                        return Container();
                      },
                    );
                  }),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firebase.collection("new").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, i) {
                          QueryDocumentSnapshot x = snapshot.data!.docs[i];
                          return Stack(children: [
                            Container(
                                margin:
                                    const EdgeInsets.only(top: 185, left: 15),
                                //height: size.height/20,
                                //width: size.width,
                                color: Colors.yellowAccent,
                                child: Text(
                                  x["name"],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                            Container(
                              margin: const EdgeInsets.only(top: 210, left: 15),
                              //height: size.height/15,
                              //width: size.width,
                              color: Colors.yellowAccent,
                              child: Text(
                                x["email"],
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]);
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ]),
        ));
  }
}
