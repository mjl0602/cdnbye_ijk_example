import 'package:cdnbye/cdnbye.dart';
import 'package:cdnbye_ijk_example/global/p2pListener.dart';
import 'package:cdnbye_ijk_example/model/videoResource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:tapped/tapped.dart';

class VideoPage extends StatefulWidget {
  final VideoResource resource;

  const VideoPage({Key key, this.resource}) : super(key: key);
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  var controller = IjkMediaController();

  // 监听p2p数据
  P2pListener listener = P2pListener();

  Orientation get orientation => MediaQuery.of(context).orientation;

  @override
  void initState() {
    init();
    super.initState();
    portraitUp();
  }

  init() async {
    listener.startListen(() {
      setState(() {});
    });
    var sourceUrl = widget.resource.url;
    var url = await Cdnbye.parseStreamURL(sourceUrl);
    controller.setDataSource(DataSource.network(url));
  }

  @override
  void dispose() {
    listener.dispose();
    controller.dispose();
    unlockOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var player = IjkPlayer(
      mediaController: controller,
      controllerWidgetBuilder: (mediaController) {
        return DefaultIJKControllerWidget(
          controller: controller,
          fullScreenType: FullScreenType.rotateScreen,
          playWillPauseOther: true,
          onFullScreen: (fullScreen) {
            if (fullScreen) {
              setLandScapeLeft();
            } else {
              portraitUp();
            }
          },
        ); // 自定义
      },
    );
    // 横屏模式
    if (orientation == Orientation.landscape) {
      return WillPopScope(
        child: Scaffold(
          body: player,
        ),
        onWillPop: () async {
          if (orientation == Orientation.landscape) {
            portraitUp();
            return false;
          }
          return true;
        },
      );
    }
    // 视频操作
    Widget actions = Row(
      children: <Widget>[
        ActionButton(
          color: Colors.blueAccent,
          icon: Icons.pan_tool,
          title: 'Stop P2P',
          onTap: () async {
            await Cdnbye.stopP2p();
          },
        ),
        ActionButton(
          color: Colors.blueAccent,
          icon: Icons.cast_connected,
          title: 'Restart P2P',
          onTap: () async {
            await Cdnbye.restartP2p();
          },
        ),
        ActionButton(
          color: Colors.orangeAccent,
          icon: Icons.replay,
          title: 'Replay',
          onTap: () async {
            // position = 0;
            // await vpController.seekTo(Duration(seconds: 0));
            // vpController.play();
          },
        ),
        ActionButton(
          color: Colors.redAccent,
          icon: Icons.settings_power,
          title: 'Reload',
          onTap: () async {
            // _loadVideo();
          },
        ),
      ],
    );

    actions = Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          actions,
          Container(height: 4),
          Container(
            padding: EdgeInsets.only(left: 6),
            child: Text(
              'Peer ID: ${listener.peerId}',
              style: TextStyle(
                color: Color(0xff9b9b9b),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resource.title),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: player,
          ),
          actions,
          Container(height: 8),
          InfoRow(
            k1: 'Http Download',
            v1: listener.httpDownloadedStr,
            k2: 'Peers',
            v2: listener.peersStr,
          ),
          InfoRow(
            k1: 'P2P Download',
            v1: listener.p2pDownloadedStr,
            k2: 'P2P Upload',
            v2: listener.p2pUploadedStr,
          ),
          InfoRow(
            k1: 'SDK Version',
            v1: listener.version,
            k2: 'P2P Connected',
            v2: listener.connected ? 'YES' : 'NO',
          ),
        ],
      ),
    );
  }

  setLandScapeLeft() async {
    await IjkManager.setLandScape();
  }

  portraitUp() async {
    await IjkManager.setPortrait();
  }

  unlockOrientation() async {
    await IjkManager.unlockOrientation();
  }
}

class InfoRow extends StatelessWidget {
  final String k1;
  final String v1;
  final String k2;
  final String v2;

  const InfoRow({
    Key key,
    this.k1,
    this.v1,
    this.k2,
    this.v2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          OneInfo(
            tag: k1,
            value: v1,
          ),
          OneInfo(
            tag: k2,
            value: v2,
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final Color color;

  const ActionButton({
    Key key,
    this.icon,
    this.title,
    this.onTap,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color highlight = color;
    Color textColor = Colors.white;
    return Expanded(
      child: Tapped(
        child: Container(
          decoration: BoxDecoration(
            color: highlight,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          width: 80,
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: textColor,
              ),
              Container(
                margin: EdgeInsets.only(top: 4),
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class OneInfo extends StatelessWidget {
  const OneInfo({
    Key key,
    this.tag,
    this.value,
  }) : super(key: key);

  final String tag;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
        margin: EdgeInsets.all(6),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                '$tag : ',
                style: TextStyle(
                  color: Color(0xff9b9b9b),
                  fontSize: 12,
                ),
              ),
            ),
            Text(value),
          ],
        ),
      ),
    );
  }
}
