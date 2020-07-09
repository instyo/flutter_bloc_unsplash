import 'package:flutter/material.dart';
import 'package:unsplash_bloc/src/views/home/pages/latest/LatestPage.dart';
import 'package:unsplash_bloc/src/views/home/pages/popular/PopularPage.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> with SingleTickerProviderStateMixin {
  // Tab Controller
  TabController controller;

  @override
  void initState() {
    controller = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unsplash"),
        centerTitle: true,
        bottom: TabBar(controller: controller, tabs: [
          Tab(text: "Latest"),
          Tab(text: "Popular"),
        ]),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print("SEARCH!");
              })
        ],
      ),
      body: TabBarView(
        children: [
          LatestPage(),
          PopularPage(),
        ],
        controller: controller,
      ),
    );
  }
}
