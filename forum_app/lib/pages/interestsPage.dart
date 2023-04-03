import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:forum_app/models/Interests.dart';

import '../models/interest.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<String> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const Text("Interests", style: TextStyle(fontSize: 30, color: Colors.cyan)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              const Text("Choose interests", style: TextStyle(fontSize: 20, color: Colors.cyan)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Expanded(
                flex: 1,
                child: Wrap(
                  children: _buildGridTileList(),
                ),
              ),
               ElevatedButton(
                  onPressed: () {
                    if (_selectedInterests.isEmpty)
                    {
                      final snackBar = SnackBar(
                        content: const Text('Select interests!'),
                        backgroundColor: Colors.primaries.first,
                      );
                      
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    else{
                      Navigator.pushNamed(context, "/");
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
            ],
          ),
      ),
    );
  }

  List<Widget> _buildGridTileList() => List.generate(
    Interests.list.length, (i) {
      return Padding(
        padding: const EdgeInsets.only(left: 4, right: 4,),
        child: ActionChip(  
            avatar: Interests.list[i].icon, 
            label: Text(Interests.list[i].name.toString(), style: const TextStyle(fontSize: 20, color: Colors.black54)),
            backgroundColor: _selectedInterests.contains(Interests.list[i].name) ? const Color.fromARGB(255, 189, 243, 192) : Colors.white,
            onPressed: ()
            {
              setState(() {
                if (_selectedInterests.contains(Interests.list[i].name))
                {
                  _selectedInterests.remove(Interests.list[i].name);
                  return;
                }

                _selectedInterests.add(Interests.list[i].name!);
              }); 
            },
            pressElevation: 5,
            side: const BorderSide(color: Colors.cyan, width: 1),
        ),
      );
    }
  );
}