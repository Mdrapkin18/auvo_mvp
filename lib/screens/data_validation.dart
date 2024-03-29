import 'package:auvo_mvp/screens/home.dart';
import 'package:auvo_mvp/widgets/side_menu.dart';
import 'package:flutter/material.dart';

class DataValidationResponse extends StatefulWidget {
  const DataValidationResponse({Key? key}) : super(key: key);

  @override
  State<DataValidationResponse> createState() => _DataValidationResponseState();
}

class _DataValidationResponseState extends State<DataValidationResponse> {
  // Track which item is expanded
  int? _expandedIndex;
  final ScrollController _controller = ScrollController();
  bool isBottom = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() => isBottom = true);
      }
      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() => isBottom = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Validation'),
        centerTitle: true,
      ),
      drawer: const SideMenu(),
      body: Stack(
        children: [
          ListView.builder(
            controller: _controller,
            itemCount: 10, // Assuming you have 10 items to display
            itemBuilder: (context, index) {
              bool isExpanded = _expandedIndex == index;
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedIndex = null;
                          } else {
                            _expandedIndex = index;
                          }
                        });
                      },
                      title: Container(
                          height: MediaQuery.of(context).size.height * .1,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Item ${index + 1}',
                            style: Theme.of(context).textTheme.headlineLarge,
                          )),
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: MediaQuery.of(context).size.height * .065,
                      ),
                      trailing: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more),
                    ),
                    if (isExpanded)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(width: 10),
                              Text('Validation Passed'),
                            ],
                          ),
                          ListTile(
                            title: Text('Details for item ${index + 1}'),
                            subtitle: Text('More detailed information here.'),
                          ),
                          // Add more widgets or a ListView.builder here for additional details
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle button press
                              },
                              child: const Text('More Details'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
          if (isBottom)
            Positioned(
              bottom: 20,
              left: 18,
              right: 18,
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(index: 0)),
                    );
                  },
                  child: Text(
                    'Done!',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
