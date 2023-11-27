import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../State/ProviderAbsen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:absensi/Screen/Admin/AdminListAbsen.dart';
import 'package:absensi/Screen/Admin/AdminFormAddPegawai.dart';
// ... (Your imports)

class HomePage extends StatefulWidget {
  final int? index;

  const HomePage({Key? key, this.index}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      _currentIndex = widget.index!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ListAbsen(),
          AddPegawai(),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.teal,
      title: Text(
        'Absensi',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            Provider.of<ProviderAbsen>(context, listen: false).getAbsen();
          },
        ),
      ],
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                buildDrawerHeader(),
                buildListTile('Absen', Icons.person, () => _changeIndex(0)),
                buildListTile('Add Pegawai', Icons.add, () => _changeIndex(1)),
                buildListTile('Logout', Icons.logout, logout),
              ],
            ),
          ),
          buildSocialIcons(),
          buildFooterText(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  ListTile buildListTile(String title, IconData icon, void Function() onTap) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: onTap,
    );
  }

  Container buildDrawerHeader() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 30),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.teal,
      ),
      child: Text(
        'Menu',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  Container buildSocialIcons() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.twitter, color: Colors.grey[600]),
            onPressed: () {
              // Link to developer's Twitter
            },
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.grey[600]),
            onPressed: () {
              // Link to developer's Instagram
            },
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.github, color: Colors.grey[600]),
            onPressed: () {
              // Link to developer's GitHub
            },
          ),
        ],
      ),
    );
  }

  Text buildFooterText() {
    return Text(
      'Azziz © 2023',
      style: TextStyle(color: Colors.grey[600]),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('pw');
    Navigator.of(context)
        .pushReplacementNamed('/loginPage'); // Navigate to login screen
  }

  void _changeIndex(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }
}
