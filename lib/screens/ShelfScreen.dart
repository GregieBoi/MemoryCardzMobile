import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/screens/LoadingScreen.dart';
import 'package:mobile_project/utils/SearchGameLocal.dart';
import 'package:mobile_project/utils/ListsAPI.dart';
import 'package:mobile_project/screens/ListsScreen.dart';
import 'package:mobile_project/utils/getAPI.dart';
import 'package:mobile_project/utils/NameAPI.dart';
import 'package:icon_animated/icon_animated.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);
String shelfGlob = '';
String userIdGlob = '';
bool isLoading = true;
ListItem list = ListItem(id: '', name: '', games: []);
List<InkWell> listGames = [];
List<GameItem> allGames = [];

class ShelfScreen extends StatefulWidget {
  @override
  _ShelfScreenState createState() => _ShelfScreenState();
}


class _ShelfScreenState extends State<ShelfScreen> {

  String? shelf;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // access the id argument passed from HubScreen
    listAndUser item = ModalRoute.of(context)?.settings.arguments as listAndUser;

    shelf = item.listId;
    userIdGlob = item.userId;
    print(userIdGlob + 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

    if(shelf == '') {print('poop');}
    print(shelf! + 'this exist');
    final String id = shelf!;
    shelfGlob = id;
    print(shelfGlob);

    // check if gameId is not null before making the API call
    if (shelf != null) {
      fetchShelfData();
    }
  }

  void dispose() {
    super.dispose();
  }

  Future<void> fetchShelfData() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    listGames = [];

    print(shelfGlob);

    list = await getListsAPI.getList(shelfGlob);

    List<String> games = list.games;
    allGames = [];

    for (String game in games) {
      if (!mounted) {continue;}
      GameItem cur = await SearchGameLocal.getGame(game);
      allGames.add(cur);

      print(cur.id + 'gameId aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      InkWell cover = InkWell(
        onTap: () async {
          Navigator.pushNamed(context, '/game',
          arguments: int.parse(cur.igId));
        },
        onLongPress: () async {
          bool? deleted = false;
          deleted = await showModalBottomSheet<bool>(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          backgroundColor: backColor,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return deleteGame(gameId: cur.id, gameName: cur.title,);
          });
          if (deleted!) didChangeDependencies();
        },
        child: Container(
          height: ((MediaQuery.of(context).size.width - 44) / 4)*1.5,
          width: (MediaQuery.of(context).size.width - 44) / 4,
          margin: EdgeInsets.all(4),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            // this allows for the rounded edges. I can't get it the way
            borderRadius: BorderRadius.all(Radius.circular(4))),
          child: cur.image != ''
            ? Image.network(
              cur.image,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            )
            : Text('Failed to load')

          )
        );
      listGames.add(cover);

    }

    if (userIdGlob == GlobalData.userId && mounted) {
      print('user is the sameeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');

      InkWell edit = InkWell(
        onTap: () async {
          bool? edited = false;
          edited = await showModalBottomSheet<bool>(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          backgroundColor: backColor,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return editList();
          });
          //if (edited!) {didChangeDependencies();}
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 4, right: 4, bottom: 10),
          margin: EdgeInsets.only(top: 5),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: textColor,
                width: .25
              )
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Edit',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ]
          ),
        )
      );

      listGames.add(edit);

      if (list.name != 'Shelf') {

        InkWell delete = InkWell(
          onTap: () {
            showModalBottomSheet<dynamic>(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            backgroundColor: backColor,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return deleteListWidget(
                  listId: list.id,
                );
            });
          },
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 4, right: 4, bottom: 10),
            //margin: EdgeInsets.only(top: 0),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: textColor,
                  width: .25
                )
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 16,
                    color: NESred,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Icon(
                  Icons.delete,
                  color: NESred,
                  size: 16,
                )
              ]
            ),
          )
        );

        listGames.add(delete);

      }

    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        backgroundColor: backColor,
        appBar: GFAppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text(
            list.name,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        body: isLoading ? LoadingPage() : myShelfWidget()


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

class myShelfWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: EdgeInsets.all(6),

      child: SingleChildScrollView(
      
      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,

        children: [

          Wrap(

            children: listGames/*[

              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),
              Card(
                child: SizedBox(
                height: (MediaQuery.of(context).size.width/4)*1.25,
                width: MediaQuery.of(context).size.width/5,
                child: Center(child: Text('Card1'),),
                ),
              ),

            ],*/

          )
        ]
      )
      )

    );

  }

}

class deleteListWidget extends StatefulWidget {
  
  final String listId;

  deleteListWidget({
    required this.listId
  });

  @override
  _deleteListState createState() => _deleteListState(listId: listId);
}

class _deleteListState extends State<deleteListWidget> {
  
  final String listId;

  _deleteListState({
    required this.listId
  });

  Widget build(BuildContext context) {

    return SizedBox(
        height: MediaQuery.sizeOf(context).height / 2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: contColor, fontSize: 16),
                        )),
                    const Text('Delete List...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () async {
                          print('delete');
                          await getListsAPI.deleteList(listId);
                          Navigator.of(context)
                              ..pop()
                              ..pop();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                              color: NESred,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.black87),
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  children: [
                    Text(
                      'Are You Sure?',
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ]));
  }

  }

  class editList extends StatefulWidget {

    @override
    _editListState createState() => _editListState();

  }

  class _editListState extends State<editList> {

    TextEditingController listNameController = TextEditingController();

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();

      listNameController.text = list.name;
    }

    @override
    Widget build(BuildContext context) {

      return SizedBox(
        height: MediaQuery.sizeOf(context).height - 32,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: contColor, fontSize: 16),
                        )),
                    const Text('Edit List...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () async {
                          print('delete');
                          await getListsAPI.updateListName(list.id, listNameController.text);
                          Navigator.of(context)
                              ..pop(true);
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: NESred,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              (list.name == 'Shelf') ? SizedBox(height: 0,) : Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: textColor, width: .25))),
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
                )),
                
                InkWell(

                  onTap: () async {
                    showModalBottomSheet<dynamic>(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      backgroundColor: backColor,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                      return AddWidget();
                      }
                    );
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
                            'Add Game to List',
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

                )

            ]));

    }

  }

  class deleteGame extends StatefulWidget {

    final String gameId;
    final String gameName;

    deleteGame ({required this.gameId, required this.gameName});

    @override
    _deleteGameState createState() => _deleteGameState(gameId: gameId, gameName: gameName);

  }

  class _deleteGameState extends State<deleteGame> {

    String gameId;
    String gameName;

    _deleteGameState({required this.gameId, required this.gameName});

    @override
    Widget build(BuildContext context) {

      return SizedBox(
        height: MediaQuery.sizeOf(context).height / 2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: contColor, fontSize: 16),
                        )),
                    const Text('Delete...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: fieldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () async {
                          print('delete');
                          await getListsAPI.deleteListGame(list.id, gameId);
                          Navigator.of(context)
                              ..pop(true);
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                              color: NESred,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.black87),
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  children: [
                    Text(
                      'Delete ' + gameName + ' from ' + list.name + '?',
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ]
          )
        );

    }

  }

  class AddWidget extends StatefulWidget {
  @override
  _AddWidgetState createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> with SingleTickerProviderStateMixin {
  List<String> results = [];
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];

  OverlayEntry? overlayEntry;
  int currentPageIndex = 0;

  late AnimationController controller;
  late Animation<double> animation;

  bool active = true;

  @override
  void initState() {
    super.initState();
    active = true;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  void createHighlightOverlay({
    required AlignmentDirectional alignment,
    required Color borderColor,
  }) {
    // Remove the existing OverlayEntry.
    removeHighlightOverlay();

    assert(overlayEntry == null);

    overlayEntry = OverlayEntry(
      // Create a new OverlayEntry.
      builder: (BuildContext context) {
        // Align is used to position the highlight overlay
        // relative to the NavigationBar destination.
        return Positioned(
          top: MediaQuery.sizeOf(context).width / 1.5,
          left: MediaQuery.sizeOf(context).width * 3 / 8,
             child: Opacity(
              opacity: .75,
              child: Container(
                width: MediaQuery.sizeOf(context).width / 4,
                height: MediaQuery.sizeOf(context).width / 4,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.black87),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconAnimated(
                      color: Colors.white, 
                      active: active,
                      size: 72,
                      iconType: IconType.add,
                    ),

                    
                  ],
                ),
              )
        ));
      },
    );

    // Add the OverlayEntry to the Overlay.
    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
  }

  // Remove the OverlayEntry.
  void removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
  }

  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    removeHighlightOverlay();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {Navigator.pop(context);},
                    child: const Text(
                      'Back',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Add a Game',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: fieldColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const Text(
                  'Cancel',
                  style: TextStyle(color: backColor, fontSize: 16),
                )
              ],
            ),
          ),
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(16),
              child: SearchAnchor(
                  viewBackgroundColor: contColor,
                  dividerColor: Colors.black87,
                  viewConstraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 16),
                  isFullScreen: false,
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      backgroundColor: MaterialStateProperty.all(contColor),
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        controller.openView();
                      },
                      leading: const Icon(Icons.search),
                    );
                  },
                  suggestionsBuilder: (BuildContext context,
                      SearchController controller) async {
                    _searchingWithQuery = controller.text;
                    final List<NameItem> results =
                        (await NameAPI.fetchData(_searchingWithQuery!))
                            .toList();

                    if (_searchingWithQuery != controller.text) {
                      return _lastOptions;
                    }

                    _lastOptions =
                        List<ListTile>.generate(results.length, (int index) {
                      final NameItem item = results[index];
                      return ListTile(
                          title: Text(item.title + ' ' + item.year),
                          onTap: () async {
                            String igId = item.id.toString();
                            await getListsAPI.addToList(list.id, igId, item.title, item.release);
                            createHighlightOverlay(
                              alignment: AlignmentDirectional.bottomStart,
                              borderColor: Colors.red,
                            );
                            setState(() {
                              active = true;
                            });
                            await Future.delayed(const Duration(seconds: 2 ));
                            removeHighlightOverlay();
                            setState(() {
                              active = false;
                            });
                            //Navigator.of(context)..pop()..pop(true);
                          });
                    });

                    return _lastOptions;
                  }))
        ],
      ),
    );
  }
}