import 'package:cdnbye_ijk_example/model/videoResource.dart';
import 'package:cdnbye_ijk_example/pages/settingPage.dart';
import 'package:cdnbye_ijk_example/pages/videoAdd.dart';
import 'package:cdnbye_ijk_example/pages/videoPage.dart';
import 'package:cdnbye_ijk_example/style/color.dart';
import 'package:cdnbye_ijk_example/style/size.dart';
import 'package:cdnbye_ijk_example/style/text.dart';
import 'package:cdnbye_ijk_example/views/confirmDialog.dart';
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
      builder: (context) => VideoInfoEditDialog(),
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
    var body = ListView.builder(
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
          opacityChange: true,
          buttons: <Widget>[
            _LeftScrollButton(
              icon: Icons.delete_forever,
              title: '删除',
              color: ColorPlate.red,
              onTap: () async {
                bool delete = await confirm(
                  context,
                  type: ConfirmType.danger,
                  title: '删除记录',
                  content: '被删除的信息将无法恢复',
                  ok: '删除',
                );
                if (delete == true) {
                  setState(() {
                    _list[index].delete();
                    _list = VideoResource.all();
                  });
                }
              },
            ),
            _LeftScrollButton(
              icon: Icons.edit,
              title: '编辑',
              color: ColorPlate.mainColor,
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) => VideoInfoEditDialog(
                    resource: _list[index],
                  ),
                );
                setState(() {
                  _list = VideoResource.all();
                });
              },
            ),
          ],
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('列表'),
        actions: <Widget>[
          _ActionIconButton(
            icon: Icons.add_box,
            onTap: addVideo,
          ),
          _ActionIconButton(
            icon: Icons.settings,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => SettingPage(),
                ),
              );
              setState(() {
                _list = VideoResource.all();
              });
            },
          ),
        ],
      ),
      body: body,
    );
  }
}

/// 一行信息
class _Row extends StatelessWidget {
  final VideoResource resource;
  const _Row({
    Key key,
    this.resource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var column = Column(
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
    );
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
            child: column,
          ),
          Container(
            child: resource.isLive ? Icon(Icons.live_tv) : Container(),
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
          height: 64,
          padding: EdgeInsets.only(top: 6),
          margin: EdgeInsets.only(right: 12),
          decoration: shapeDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
        padding: EdgeInsets.fromLTRB(0, 12, 24, 12),
        child: Icon(
          icon ?? Icons.help,
          size: 24,
          color: ColorPlate.white,
        ),
      ),
    );
  }
}
