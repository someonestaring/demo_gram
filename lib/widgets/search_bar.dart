import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text(
    'Search',
    style: TextStyle(
      color: Colors.black54,
      fontSize: 18,
      fontStyle: FontStyle.italic,
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = const ListTile(
                    // leading: Icon(
                    //   Icons.search,
                    //   color: Colors.black54,
                    //   size: 28,
                    // ),
                    title: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                }
              });
            },
            icon: customIcon,
          ),
          Flexible(child: customSearchBar),
        ],
      ),
    );
  }
}
