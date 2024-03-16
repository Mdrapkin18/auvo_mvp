import 'package:auvo_mvp/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key, required int index});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search History'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.005),
              child: ElevatedButton(
                onPressed: () {},
                child: ListTile(
                  leading: Icon(Icons.file_present_rounded),
                  title: Text('item ${index + 1}'),
                ),
              ),
            );
          },
        ),
      ),
      // ListView(
      //   children: [ListTile(title: Text('Item 1'))],
      // ),
      bottomNavigationBar: BottomNavBar(
        indexfrompage: 1,
      ),
    );
  }
}
