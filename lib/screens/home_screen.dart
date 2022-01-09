import 'package:appchat/screens/widgets/user_item.dart';
import 'package:appchat/screens/widgets/widgets.dart';
import 'package:appchat/services/services.dart';
import 'package:appchat/static_varibale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: UserService.userStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Text('Firestore snapshot has error..');
          }
          if (snapshot.data == null) {
            return const Text("Snapshot.data is null..");
          } else {
            final docs = snapshot.data.docs;
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const UserItem(),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        60,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final name = docs[index]['name'];
                        final avatar = docs[index]['avatar'];
                        final uid = docs[index]['uid'];
                        final description = docs[index]['description'];
                        if (uid != StaticVariable.uid) {
                          return ListUserItem(
                            name: name,
                            avatar: avatar,
                            uid: uid,
                            description: description,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
