import 'package:cdnbye_ijk_example/model/videoResource.dart';
import 'package:cdnbye_ijk_example/pages/videoPage.dart';
import 'package:cdnbye_ijk_example/style/color.dart';
import 'package:cdnbye_ijk_example/style/size.dart';
import 'package:cdnbye_ijk_example/style/text.dart';
import 'package:flutter/material.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'package:tapped/tapped.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<VideoResource> _list = [];

  // 添加电影到本地
  addVideo() async {
    await showDialog(
      context: context,
      builder: (context) => VideoAddDialog(),
    );
    setState(() {
      _list = VideoResource.all();
    });
  }

  @override
  void initState() {
    _list = VideoResource.all();
    if (_list.length == 0) {
      VideoResource(
        title: '豹子头林冲之山神庙',
        url:
            'http://cn6.qxreader.com/hls/20200201/e987a0e00e1a8431ac408032ba023958/1580550680/index.m3u8',
      )..save();
    }
    setState(() {
      _list = VideoResource.all();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('列表'),
        actions: <Widget>[
          _ActionIconButton(
            icon: Icons.add,
            onTap: addVideo,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) {
          return CupertinoLeftScroll(
            key: Key(_list[index].title),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => VideoPage(
                    resource: _list[index],
                  ),
                ),
              );
            },
            child: _Row(resource: _list[index]),
            buttons: <Widget>[
              _LeftScrollButton(
                icon: Icons.delete_forever,
                title: '删除',
                color: ColorPlate.red,
                onTap: () {
                  setState(() {
                    _list[index].delete();
                    _list = VideoResource.all();
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// 一行设备
class _Row extends StatelessWidget {
  final VideoResource resource;
  const _Row({
    Key key,
    this.resource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.fromLTRB(16, 10, 0, 12),
      decoration: ShapeDecoration(
        color: ColorPlate.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        shadows: [
          BoxShadow(
            color: ColorPlate.black.withOpacity(0.02),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 2),
                  child: StText.big(
                    resource.title,
                    enableOffset: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                  child: StText.small(
                    resource.url,
                    style: TextStyle(
                      fontSize: SysSize.tiny,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Icon(Icons.video_library),
          ),
          Container(
            width: 3,
            height: 24,
            margin: EdgeInsets.only(
              right: 4,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: ColorPlate.lightGray,
            ),
          )
        ],
      ),
    );
  }
}

// 左滑的按钮样式
class _LeftScrollButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Function onTap;
  const _LeftScrollButton({
    Key key,
    this.title,
    this.icon,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shapeDecoration = ShapeDecoration(
      color: ColorPlate.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      shadows: [
        BoxShadow(
          color: ColorPlate.black.withOpacity(0.02),
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    );
    return Tapped(
      onTap: onTap,
      child: Center(
        child: Container(
          height: 60,
          padding: EdgeInsets.only(top: 6),
          margin: EdgeInsets.only(right: 12),
          decoration: shapeDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Icon(
                  icon ?? Icons.help,
                  size: 24,
                  color: color ?? ColorPlate.darkGray,
                ),
              ),
              StText.small(
                title ?? '???',
                style: TextStyle(
                  fontSize: 11,
                  color: color ?? ColorPlate.darkGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// AppBar的按钮
class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  final Function onLongTap;
  const _ActionIconButton({
    Key key,
    this.icon,
    this.onTap,
    this.onLongTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: onTap,
      onLongTap: onLongTap,
      child: Container(
        color: Color(0),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Icon(
          icon ?? Icons.help,
          size: 24,
          color: ColorPlate.white,
        ),
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

class VideoAddDialog extends StatefulWidget {
  @override
  _VideoAddDialogState createState() => _VideoAddDialogState();
}

class _InputHelper {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  String get text => controller.value.text;
}

class _VideoAddDialogState extends State<VideoAddDialog> {
  _InputHelper title = _InputHelper();
  _InputHelper url = _InputHelper();
  bool isLive = false;

  _submit() async {
    if (!url.text.contains('.m3u8')) {
      var res = await showDialog(
        context: context,
        builder: (context) => _AlertUrlErrorDialog(url: url.text),
      );
      if (res != true) {
        return;
      }
    }
    VideoResource(
      title: title.text,
      url: url.text,
    )..save();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('添加一个视频地址'),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        TextField(
          focusNode: title.focusNode,
          controller: title.controller,
          decoration: InputDecoration(
            labelText: '标题',
            labelStyle: StandardTextStyle.normal,
          ),
          onSubmitted: (text) {
            FocusScope.of(context).requestFocus(url.focusNode);
          },
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: StText.normal('直播'),
            ),
            Switch(
              value: isLive,
              onChanged: (v) => setState(() => isLive = v),
            ),
          ],
        ),
        TextField(
          focusNode: url.focusNode,
          controller: url.controller,
          decoration: InputDecoration(
            labelText: '地址',
            labelStyle: StandardTextStyle.normal,
          ),
          onSubmitted: (text) {
            _submit();
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
              _submit();
            },
          ),
        )
      ],
    );
  }
}
