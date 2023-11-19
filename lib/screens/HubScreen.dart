import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobile_project/screens/GameScreen.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:badges/badges.dart' as badges;
//import 'package:mobile_project/utils/GameAPI.dart';
import 'package:mobile_project/utils/CoverAPI.dart';
import 'package:mobile_project/utils/NameAPI.dart';

const backColor = Color(0xFF343434);
const textColor = Color(0xFF8C8C8C);
const contColor = Color(0xFF8C8C8C);
const fieldColor = Color(0xFFD9D9D9);
const NESred = Color(0xFFFF0000);
int _selectedIndex = 0;

class HubScreen extends StatefulWidget {
  @override
  _HubScreenState createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  //_selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    GamesWidget(),
    SearchWidget(),
    AddWidget(),
    ActivityWidget(),
    AccountWidget()
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        showModalBottomSheet<dynamic>(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: backColor,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return AddWidget();
            });
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: GFAppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          'MemoryCardZ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        unselectedItemColor: fieldColor,
        selectedItemColor: NESred,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset_outlined),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Activity',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account', backgroundColor: NESred),
        ],
      ),
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

class GamesWidget extends StatefulWidget {
  @override
  _GamesWidgetState createState() => _GamesWidgetState();
}

class _GamesWidgetState extends State<GamesWidget> {
  List<GameItem> popularGames = [];
  List<GameItem> friendGames = [];

  @override
  void initState() {
    super.initState();
    fetchGameData();
  }

  Future<void> fetchGameData() async {
    final api = CoverAPI();
    await api.fetchData();
    if (_selectedIndex == 0) {
      setState(() {
        popularGames = api.body;
        // might need to fetch friend games similarly and update the friendGames list.
        // example here, duplicate the popularGames for friendGames.
        friendGames = List.from(popularGames);
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'Popular',
              style: TextStyle(color: fieldColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularGames.length,
              itemBuilder: (context, index) {
                final game = popularGames[index];
                return Container(
                  height: 150,
                  width: 120,
                  child: game.coverImageUrl.isNotEmpty
                      ? Image.network(game.coverImageUrl, height: 170, width: 120, fit: BoxFit.fitHeight)
                      : Container(),
                  //SizedBox(height: 5),
                  //Text(game.title, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                );
              },
            ),
          ),
          SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'From Friends',
              style: TextStyle(color: fieldColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: friendGames.length,
              itemBuilder: (context, index) {
                final game = friendGames[index];
                return Card(
                  child: SizedBox(
                    height: 150,
                    width: 120,
                    child: Column(
                      children: [
                        game.coverImageUrl.isNotEmpty
                            ? Image.network(game.coverImageUrl, height: 152, width: 120, fit: BoxFit.cover)
                            : Container(),
                        //SizedBox(height: 5),
                        //Text(game.title, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  List<String> results = [];
  String? _searchingWithQuery;
  late Iterable<Widget> _lastOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16),
        child: SearchAnchor(
            viewBackgroundColor: contColor,
            dividerColor: Colors.black87,
            viewConstraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 16),
            isFullScreen: false,
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                backgroundColor: MaterialStateProperty.all(contColor),
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) async {
              _searchingWithQuery = controller.text;
              final List<NameItem> results =
                (await NameAPI.fetchData(_searchingWithQuery!)).toList();

              if (_searchingWithQuery != controller.text) {
                return _lastOptions;
              }

              _lastOptions = List<ListTile>.generate(results.length, (int index) {
                  final NameItem item = results[index];
                  return ListTile(
                    title: Text(item.title),
                    onTap: () {
                      Navigator.pushNamed(context, 
                        '/game', 
                        arguments:
                          GameScreen(id: item.id) 
                      );
                    }
                  );
                }
              );

              return _lastOptions;
              
            }));
  }
}

class AddWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: contColor, fontSize: 16),
                    )),
                const Text('Add a Game',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: fieldColor, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text(
                  'Cancel',
                  style: TextStyle(color: backColor, fontSize: 16),
                )
              ],
            ),
          ),
          SearchWidget()
        ],
      ),
    );
  }
}

class ActivityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('BUTTS4');
  }
}

class AccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        badges.Badge(
          onTap: () {
            showModalBottomSheet<dynamic>(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: backColor,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return SettingsWidget();
                });
          },
          badgeContent: Icon(
            Icons.settings_outlined,
            color: Colors.black87,
          ),
          badgeStyle: badges.BadgeStyle(badgeColor: Colors.transparent),
          child: GFAvatar(
            shape: GFAvatarShape.circle,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'This is my bio',
          style: TextStyle(color: textColor),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Favorites',
          style: TextStyle(fontSize: 20, color: textColor),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: (MediaQuery.of(context).size.width / 4) * 1.25,
          width: (MediaQuery.of(context).size.width),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Card>[
              Card(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width / 4) * 1.25,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Recent',
          style: TextStyle(fontSize: 20, color: textColor),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: (MediaQuery.of(context).size.width / 4) * 1.25,
          width: (MediaQuery.of(context).size.width),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Card>[
              Card(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width / 4) * 1.25,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: Text('Card1'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width + 40,
          decoration: BoxDecoration(border: Border(top: BorderSide(color: contColor))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RATINGS',
                style: TextStyle(color: textColor),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.star,
                    color: NESred,
                    size: 10,
                  ),
                  Container(
                    height: 50,
                    width: (MediaQuery.of(context).size.width - 40) * 2 / 3,
                    child: SfSparkBarChart(
                      data: [0.025, 0.025, 0.1, 0.05, 0.05, 1, 2, 3, 1, 1],
                      color: textColor,
                    ),
                  ),
                  Column(children: [
                    Text(
                      '3.9',
                      style: TextStyle(fontSize: 20, color: textColor),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: NESred,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: NESred,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: NESred,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: NESred,
                          size: 10,
                        ),
                        Icon(
                          Icons.star,
                          color: NESred,
                          size: 10,
                        ),
                      ],
                    )
                  ])
                ],
              )
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            Navigator.pushNamed(context, '/games');
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: contColor))),
            child: Text(
              'Games',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            Navigator.pushNamed(context, '/diary');
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: contColor))),
            child: Text(
              'Diary',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            Navigator.pushNamed(context, '/lists');
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: contColor))),
            child: Text(
              'Lists',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            Navigator.pushNamed(context, '/shelf');
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: contColor))),
            child: Text(
              'Shelf',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            Navigator.pushNamed(context, '/following');
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: contColor))),
            child: Text(
              'Following',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            Navigator.pushNamed(context, '/follower');
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: contColor))),
            child: Text(
              'Followers',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
        ),
      ],
    ));
  }
}

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 32,
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel', style: TextStyle(color: textColor, fontSize: 16)),
                      ),
                      Text('Settings', style: TextStyle(color: fieldColor, fontSize: 20)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text('Save', style: TextStyle(color: NESred, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: textColor,
                  ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Signed in as ' + 'UserName',
                        style: TextStyle(color: textColor, fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: textColor,
                  ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Reset Password',
                        style: TextStyle(color: textColor, fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: textColor,
                  ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Out',
                        style: TextStyle(color: NESred, fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: textColor,
                  ))),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: textColor,
                  ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: textColor,
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: textColor,
                  ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bio',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: textColor,
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: textColor,
                  ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Favorites',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: textColor,
                      )
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                      color: textColor,
                    ))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Icons',
                          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: fieldColor),
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: fieldColor),
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: fieldColor),
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: fieldColor),
                            ),
                          ],
                        ),
                      ],
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: textColor,
                  ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delete Account',
                        style: TextStyle(color: NESred, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: NESred,
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
