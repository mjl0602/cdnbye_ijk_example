import 'package:cdnbye_ijk_example/model/videoResource.dart';
import 'package:cdnbye_ijk_example/pages/videoPage.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<VideoResource> get _list => [
        VideoResource(
          title: '豹子头林冲之山神庙',
          image: 'http://cn2.3days.cc/1580551147538598.jpeg',
          description:
              '山神庙，林冲抚摸着冰冷冷的长枪，现在只有倚靠这个伙伴了，陆谦已经追到跟前，长枪对单刀，昔日较场两人交手的情景出现在眼前，同样的一招，这次陆谦却永远倒在林冲枪下。所有恩怨都了结于刀枪下，林冲一杆长枪在肩挑着酒葫芦如孤云野鹤般走在白雪的旷野中，朔风紧起，又见雪花纷纷扬扬……',
          url:
              'http://cn6.qxreader.com/hls/20200201/e987a0e00e1a8431ac408032ba023958/1580550680/index.m3u8',
        ),
      ];

  _toCustomVideoPage() async {
    String url = await showDialog(
      context: context,
      builder: (context) => _InputDialog(),
    );
    if (url == null) {
      return;
    }
    if (!url.contains('.m3u8')) {
      var res = await showDialog(
        context: context,
        builder: (context) => _AlertUrlErrorDialog(url: url),
      );
      if (res != true) {
        return;
      }
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return VideoPage(
        resource: VideoResource(
          title: url.split('/').last,
          image: '',
          description: '自定视频',
          url: url,
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    var customUrlButton = Tapped(
      child: Container(
        height: 44,
        color: Color(0xfff5f5f4),
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.video_library,
              size: 16,
            ),
            Container(width: 4),
            Expanded(child: Text('使用自定义地址播放')),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
            ),
          ],
        ),
      ),
      onTap: _toCustomVideoPage,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('列表'),
      ),
      body: Column(
        children: <Widget>[
          customUrlButton,
          Expanded(
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoResourceRow(resource: _list[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertUrlErrorDialog extends StatelessWidget {
  const _AlertUrlErrorDialog({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('地址$url 可能不能使用p2p加速'),
      actions: <Widget>[
        Tapped(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              '取消',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop(false);
          },
        ),
        Tapped(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              '仍然继续',
              style: TextStyle(color: Colors.red),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}

class _InputDialog extends StatefulWidget {
  const _InputDialog({
    Key key,
  }) : super(key: key);

  @override
  __InputDialogState createState() => __InputDialogState();
}

class __InputDialogState extends State<_InputDialog> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('输入自定义地址'),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        TextField(
          controller: _controller,
          onSubmitted: (text) {
            Navigator.of(context).pop(_controller.text);
          },
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Tapped(
            child: Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                '确认',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop(_controller.text);
            },
          ),
        )
      ],
    );
  }
}

class VideoResourceRow extends StatelessWidget {
  final VideoResource resource;
  const VideoResourceRow({
    Key key,
    this.resource,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // 标题与梗概
    Widget info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          resource.title,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xff4a4a4a),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Text(
            resource.description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff9b9b9b),
            ),
          ),
        ),
      ],
    );
    return Tapped(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12),
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Container(
              width: 66,
              constraints: BoxConstraints(
                minWidth: 66,
                minHeight: 88,
              ),
              margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Image.network(resource.image),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xfff5f5f4))),
                ),
                child: info,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return VideoPage(
            resource: resource,
          );
        }));
      },
    );
  }
}
