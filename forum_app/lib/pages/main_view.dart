import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.17,
            child: InfiniteListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.width * 0.35,
                    child: Card(
                      child: ListTile(
                        title: const Text('Horizontal'),
                        subtitle: Text('Breaking news!!!$index'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: InfiniteListView.builder(itemBuilder: (context, index) {
              return Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7 * 0.25,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Card(
                    child: ListTile(
                      title: const Text('Vertical'),
                      subtitle: Text('Листаюсь вертикально $index'),
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}