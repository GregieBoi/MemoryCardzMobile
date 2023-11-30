import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/screens/HubScreen.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/ListsAPI.dart';
import 'package:mobile_project/utils/getAPI.dart';
import 'package:mobile_project/utils/getUserAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);

List<dynamic> listsIdsGlob = [];
bool isLoading = true;
List<ListItem> column = [];
String userIdGlob = '';
bool isSameUser = false;

class listAndUser {
  String userId;
  String listId;

  listAndUser ({
    required this.userId,
    required this.listId
  });
}

class ListsScreen extends StatefulWidget {
  @override
  _ListsScreenState createState() => _ListsScreenState();
}


class _ListsScreenState extends State<ListsScreen> {

  List<dynamic> listsIds = [];

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (mounted) {
      setState(() {
        isLoading = true;
        isSameUser = false;
        column = [];
        listsIdsGlob = [];
        listsIds = [];
      });
    }

    print('\nhereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee\n\n');

    listsIds = [];

    // access the id argument passed from HubScreen
    listsAndUser item = ModalRoute.of(context)?.settings.arguments as listsAndUser;

    userIdGlob = item.userId;

    if (userIdGlob == GlobalData.userId) {
      setState(() {
        isSameUser = true;
        listsIdsGlob = [];
      });
      UserItem user = await getUserAPI.getUser(userIdGlob);
      listsIds  = user.lists;
    }
    else {
      listsIds = item.lists;
    }

    print(listsIds);


    //listsIds ??= ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    if (mounted) {
      setState(() {
        listsIdsGlob = listsIds;
      });
    }

    print(listsIds);
    print(listsIdsGlob);

    // check if gameId is not null before making the API call
    if (listsIdsGlob != null) {
      fetchListData();
    }

    int numLists = column.length;

    print('\n$numLists\n');
  }

  Future<void> fetchListData() async {

    if (mounted) {
      setState(() {
        isLoading = true;
        column = [];
      });
    }

    column = [];

    int numLists = listsIdsGlob.length;

    print('\n# of lists ' + '$numLists' + '\n\n');

    for (var listId in listsIdsGlob) {
      if (!mounted) {continue;}

      final String id = listId;

      ListItem cur = await getListsAPI.getList(id);

      if (!mounted || cur.name == 'Shelf' || cur.name == '') {continue;}

      column.add(cur);

      /*InkWell list = InkWell(

        onTap: () async {
          await Navigator.pushNamed(context, '/shelf', arguments: listAndUser(userId: userIdGlob, listId: cur.id));
          print('butttttttttttttttttttttttttttttttttttttttttttttttttts');
          didChangeDependencies();
          print('buttttttttttttttttttttttttttttttttttttttttttttttttttttttt');
        },

        child: Container(

          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: textColor, width: .25)
            )
          ),

          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Text(
                cur.name,
                style: TextStyle(
                  color: fieldColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),

              Text(
                '$numGames' + ' Games',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              )

            ],

          ),

        ),

      );*/
      
      //column.add(list);

    }

    if (mounted && userIdGlob == GlobalData.userId) {

      InkWell createList = InkWell(

        onTap: () async {
          bool? add = false;
          add = await showModalBottomSheet<bool>(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: backColor,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
            return createListWidget();
            }
          );
          if (add!) {
            column.add(ListItem(id: '', name: 'name', games: []));
          }
        },

        child: Container(

          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: textColor, width: .25)
            )
          ),

          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Container(
                width: MediaQuery.sizeOf(context).width / 1.75,
                child: Text(
                  'Create New List',
                  style: TextStyle(
                    color: fieldColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              Text(
                '+',
                style: TextStyle(
                  color: NESred,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              )

            ],

          ),

        ),

      );

      //column.add(createList);

    } 

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() async{
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            'Lists',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: isLoading ? 
          LoadingPage() : 
          SingleChildScrollView(

            child: Container(

              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height - 18,

              child: ListView.builder(
                
                scrollDirection: Axis.vertical,
                itemCount: isSameUser ? listsIdsGlob.length : listsIdsGlob.length,
                itemBuilder: (context, index) {
                  ListItem curList = ListItem(id: '', name: '', games: []);
                  int numLists = column.length;
                  int numGames = 0;
                  if(isSameUser) {print('\nis the same user\n');}
                  print('\n$numLists\n' + '\n$index\n');
                  if (index != numLists || (index == numLists && !isSameUser)) {
                    curList = column[index];
                    numGames = curList.games.length;
                  }
                  bool specialWidget = false;
                  if (isSameUser && index == numLists) {specialWidget = true; print('\nits true\n');}
                  return specialWidget ? 
                    InkWell(

                      onTap: () async {
                        ListItem? add = ListItem(id: '', name: '', games: []);
                        add = await showModalBottomSheet<ListItem>(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          backgroundColor: backColor,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                          return createListWidget();
                          }
                        );
                        add!;
                        if (add.id != '') {
                          setState(() {
                            column.insert(index - 1, add!);
                          });
                          print(column.length);
                        }
                      },

                      child: Container(

                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: textColor, width: .25)
                          )
                        ),

                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [

                            Container(
                              height: 85,
                              width: MediaQuery.sizeOf(context).width / 1.75,
                              child: Text(
                                'Create New List',
                                style: TextStyle(
                                  color: fieldColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),

                            Container(
                              height: 85,
                              child: Text(
                                '+',
                                style: TextStyle(
                                  color: NESred,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            )

                          ],

                        ),

                      ),

                    ) :

                    InkWell(

                      onTap: () async {
                        await Navigator.pushNamed(context, '/shelf', arguments: listAndUser(userId: userIdGlob, listId: curList.id));
                        print('butttttttttttttttttttttttttttttttttttttttttttttttttts');
                        didChangeDependencies();
                        print('buttttttttttttttttttttttttttttttttttttttttttttttttttttttt');
                      },

                      child: Container(

                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: textColor, width: .25)
                          )
                        ),

                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [

                            Text(
                              curList.name,
                              style: TextStyle(
                                color: fieldColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),

                            Text(
                              '$numGames' + ' Games',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                              ),
                            )

                          ],

                        ),

                      ),

                    );
                },

              )
              

            ),

      )


    );
  }
}


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class listsWidget extends StatefulWidget {

  @override
  _listsWidgetState createState() => _listsWidgetState();
}

class _listsWidgetState extends State<listsWidget> {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      child: Container(

        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height - 18,

        child: ListView.builder(
          
          scrollDirection: Axis.vertical,
          itemCount: isSameUser ? listsIdsGlob.length : listsIdsGlob.length,
          itemBuilder: (context, index) {
            ListItem curList = ListItem(id: '', name: '', games: []);
            int numLists = column.length;
            int numGames = 0;
            if(isSameUser) {print('\nis the same user\n');}
            print('\n$numLists\n' + '\n$index\n');
            if (index != numLists || (index == numLists && !isSameUser)) {
              curList = column[index];
              numGames = curList.games.length;
            }
            bool specialWidget = false;
            if (isSameUser && index == numLists) {specialWidget = true; print('\nits true\n');}
            return specialWidget ? 
              InkWell(

                onTap: () async {
                  bool? add = false;
                  add = await showModalBottomSheet<bool>(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: backColor,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                    return createListWidget();
                    }
                  );
                  if (add!) {
                    didChangeDependencies();
                  }
                },

                child: Container(

                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: textColor, width: .25)
                    )
                  ),

                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Container(
                        height: 85,
                        width: MediaQuery.sizeOf(context).width / 1.75,
                        child: Text(
                          'Create New List',
                          style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      Container(
                        height: 85,
                        child: Text(
                          '+',
                          style: TextStyle(
                            color: NESred,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      )

                    ],

                  ),

                ),

              ) :

              InkWell(

                onTap: () async {
                  await Navigator.pushNamed(context, '/shelf', arguments: listAndUser(userId: userIdGlob, listId: curList.id));
                  print('butttttttttttttttttttttttttttttttttttttttttttttttttts');
                  didChangeDependencies();
                  print('buttttttttttttttttttttttttttttttttttttttttttttttttttttttt');
                },

                child: Container(

                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: textColor, width: .25)
                    )
                  ),

                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        curList.name,
                        style: TextStyle(
                          color: fieldColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      Text(
                        '$numGames' + ' Games',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      )

                    ],

                  ),

                ),

              );
          },

        )
        

      ),

    );

  }

}

class createListWidget extends StatefulWidget {

  @override
  _createListState createState() => _createListState();

}

class _createListState extends State<createListWidget> {

  TextEditingController listNameController = TextEditingController();
  String listNameText = '';

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        height: MediaQuery.of(context).size.height - 32,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Create List New List...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: fieldColor, fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () async {
                      String newListId = await getListsAPI.createList(userIdGlob, listNameController.text);
                      print('created and added to new list');
                      Navigator.pop(context, ListItem(id: newListId, name: listNameController.text, games: []));
                      //Navigator.pushNamed(context, '/shelf', arguments: listAndUser(userId: userIdGlob, listId: newListId));
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: NESred, fontSize: 16, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.only(
              top: 10, left: 20, right: 20, bottom: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black87, width: .25))),
            child: TextField(
              controller: listNameController,
              maxLines: null,
              style: const TextStyle(
              color: textColor,
              fontSize: 14,
            ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                floatingLabelStyle:
                  TextStyle(color: Colors.transparent),
                labelText: 'List Title...',
                labelStyle: TextStyle(color: textColor, fontSize: 16),
                border:
                  OutlineInputBorder(borderSide: BorderSide.none)),
            ))
          
        ]
      )
    );

  }

}