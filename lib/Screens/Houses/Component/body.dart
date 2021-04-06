import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smartizen/Models/houses.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/Screens/Houses/Component/houses_list_items.dart';

class HousesBody extends StatefulWidget {
  HousesBody({this.items});

  final List<HousesModel> items;
  @override
  _HousesBodyState createState() => _HousesBodyState();
}

class _HousesBodyState extends State<HousesBody> {
  Future<String> onCreateHouse(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);

    TextEditingController houseName = TextEditingController();
    TextEditingController location = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Input House Name"),
            backgroundColor: Colors.blueGrey[50],
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    controller: houseName,
                    decoration: InputDecoration(hintText: "House name"),
                  ),
                  TextField(
                    controller: location,
                    decoration: InputDecoration(hintText: "Enter location"),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Submit"),
                onPressed: () {
                  store.dispatch(
                      createHouse(context, houseName.text, location.text));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff202227),
        body: StoreConnector<AppState, AppState>(
            onInit: (store) {
              store.dispatch(getHousesData());
            },
            converter: (store) => store.state,
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 400,
                    height: 600,
                    child: Image.asset(
                      'assets/houses.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  DraggableScrollableSheet(
                    maxChildSize: 0.85,
                    minChildSize: 0.1,
                    builder: (BuildContext context,
                        ScrollController scrolController) {
                      return Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40),
                                    topLeft: Radius.circular(40)),
                              ),
                              child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return HouseListItem(
                                        itemIndex: index,
                                        housesModel: state.houses[index]);
                                  },
                                  controller: scrolController,
                                  itemCount: state.houses.length)),
                          Positioned(
                            child: FloatingActionButton(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.pinkAccent,
                              onPressed: () {
                                onCreateHouse(context);
                              },
                            ),
                            top: -30,
                            right: 30,
                          )
                        ],
                      );
                    },
                  )
                ],
              );
            }));
  }
}