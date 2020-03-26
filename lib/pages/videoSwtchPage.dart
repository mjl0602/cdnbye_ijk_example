import 'dart:io';

import 'package:cdnbye/cdnbye.dart';
import 'package:cdnbye_ijk_example/global/p2pListener.dart';
import 'package:cdnbye_ijk_example/global/userDefault.dart';
import 'package:cdnbye_ijk_example/model/videoResource.dart';
import 'package:cdnbye_ijk_example/style/color.dart';
import 'package:cdnbye_ijk_example/style/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:tapped/tapped.dart';

class VideoSwitchPage extends StatefulWidget {
  const VideoSwitchPage({Key key}) : super(key: key);
  @override
  _VideoSwitchPageState createState() => _VideoSwitchPageState();
}

class _VideoSwitchPageState extends State<VideoSwitchPage> {
  List<VideoResource> _list = [];
  int index = 0;

  VideoResource get currentResource => _list[index];

  // 监听p2p数据
  P2pListener listener = P2pListener();

  Orientation get orientation => MediaQuery.of(context).orientation;

  @override
  void reassemble() {
    init();
    super.reassemble();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    listener.startListen(() {
      setState(() {});
    });
    _list = VideoResource.all();
    for (var videoInfo in _list) {
      videoInfo.controller = IjkMediaController();
    }
    loadVideo();
    setState(() {});
  }

  loadVideo() async {
    await currentResource.controller
        .setNetworkDataSource(currentResource.url, autoPlay: true);
    await currentResource.controller.pauseOtherController();
  }

  pauseVideo() async {
    await currentResource.controller.seekTo(0);
    await currentResource.controller.pause();
  }

  last() async {
    print('switch to last from $index');
    await pauseVideo();
    index--;
    await loadVideo();
    print('end switch to last from $index');
  }

  next() async {
    print('switch to next from $index');
    await pauseVideo();
    index++;
    await loadVideo();
    print('end switch to next from $index');
  }

  @override
  void dispose() {
    listener.dispose();
    for (var videoInfo in _list) {
      videoInfo.controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var players = <Widget>[];
    for (var videoInfo in _list) {
      Widget player = Container();
      if (videoInfo.controller == null) {
        player = Text('null');
      } else {
        player = IjkPlayer(
          mediaController: videoInfo.controller,
          controllerWidgetBuilder: (mediaController) {
            return Container(); // 自定义
          },
          statusWidgetBuilder: (_, __, ___) => Container(),
        );
      }
      players.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 60, vertical: 4),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.black.withOpacity(0.3),
              height: 80,
              child: player,
            ),
          ),
        ),
      );
    }

    // 视频操作
    Widget actions = Row(
      children: <Widget>[
        ActionButton(
          color: Colors.redAccent,
          icon: Icons.arrow_upward,
          title: '上一个',
          onTap: last,
        ),
        ActionButton(
          color: Colors.green,
          icon: Icons.arrow_downward,
          title: '下一个',
          onTap: next,
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
        title: Text('Switch Test:${_list.length}'),
        actions: <Widget>[],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: players,
          ),
          actions,
        ],
      ),
    );
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
            StText.small(
              value,
              style: TextStyle(
                color: ColorPlate.darkGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
