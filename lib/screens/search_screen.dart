import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkr_demo/models/user.dart';
import 'package:talkr_demo/widgets/progress.dart';
import 'feed_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot>? searchResultsFuture;
  handleSearchScreen(String query) {
    Future<QuerySnapshot> users =
        usersRef.where("displayName", isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearchScreen() {
    searchController.clear();
  }

  AppBar buildSearchScreenField() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search User",
          filled: true,
          prefixIcon: const Icon(
            Icons.account_box,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: clearSearchScreen,
          ),
        ),
        onFieldSubmitted: handleSearchScreen,
      ),
    );
  }

  Container buildNoContent() {
    // ignore: avoid_unnecessary_containers
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: const <Widget>[
            Text(
              "Find Users ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchScreenResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        // ignore: non_constant_identifier_names
        List<UserResult> SearchScreenResults = [];
        // ignore: avoid_function_literals_in_foreach_calls
        snapshot.data?.docs.forEach((doc) {
          Userr user = Userr.fromDocument(doc);
          // ignore: non_constant_identifier_names
          UserResult SearchScreenResult = UserResult(user);
          SearchScreenResults.add(SearchScreenResult);
        });
        return ListView(
          children: SearchScreenResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchScreenField(),
      body:
          // ignore: unnecessary_null_comparison
          searchResultsFuture == null
              ? buildNoContent()
              : buildSearchScreenResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final Userr user;

  // ignore: use_key_in_widget_constructors
  const UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            // ignore: avoid_print
            onTap: () => print('tapped'),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.displayName,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
