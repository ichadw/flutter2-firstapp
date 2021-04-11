import 'package:flutter/material.dart';
import 'fetcher/album.dart';
import 'player.dart';

void main() => runApp(new MaterialApp(
      home: new Homepage(),
    ));

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => new _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Widget appBarTitle = new Text(
    "Music Player App",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Icon iconPlay = new Icon(
    Icons.play_arrow,
    color: Colors.black,
  );
  Icon iconStop = new Icon(
    Icons.stop,
    color: Colors.black,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  Future<List<dynamic>> futureAlbum;
  bool _isSearching;
  String _currentPlayingUrl = "";
  String _currentPlayingAlbum = "";
  int _currentPlayingId = 0;
  bool _cbPlay = false;
  bool _cbStop = false;
  String _searchText = "";

  _HomepageState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        appBar: buildAppBar(context),
        body: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Flexible(
                child: FutureBuilder<List<dynamic>>(
                  future: futureAlbum,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          padding: EdgeInsets.all(8),
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            snapshot.data[index]['album']
                                                ['cover_small'])),
                                    title: Text(snapshot.data[index]['title']),
                                    subtitle: Text(
                                        snapshot.data[index]['artist']['name']),
                                    trailing: IconButton(
                                      icon: _currentPlayingId == snapshot.data[index]['id'] ? iconStop : iconPlay,
                                      onPressed: () {
                                        int currId = snapshot.data[index]['id'];
                                        setState(() {
                                          if (_currentPlayingId != currId) {
                                            _handlePlay(snapshot.data[index]['preview'], snapshot.data[index]['id'], snapshot.data[index]['album']['title']);
                                          } else if (_currentPlayingId == currId) {
                                            _handleStop();
                                          }
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Please Search First'),
                      );
                    }
                  },
                ),
              ),
              PlayerWidget(url: _currentPlayingUrl, fileName: _currentPlayingAlbum, cbPlay: _cbPlay, cbStop: _cbStop)
            ],
          ),
        ));
  }

  void _handlePlay(String url, int id, String album) {
    setState(() {
      _cbPlay = true;
      _currentPlayingUrl = url;
      _currentPlayingId = id;
      _currentPlayingAlbum = album;
    });
  }

  void _handleStop() {
    setState(() {
      _cbPlay = false;
      _cbStop = true;
      _currentPlayingUrl = "";
      _currentPlayingId = 0;
    });
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search artist...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onSubmitted: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Music Player App",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    if (_isSearching != null) {
      futureAlbum = fetchAlbum(searchText);
    }
  }
}
