import 'package:cdnbye_ijk_example/model/videoResource.dart';
import 'package:cdnbye_ijk_example/style/text.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

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

class VideoInfoEditDialog extends StatefulWidget {
  final VideoResource resource;

  const VideoInfoEditDialog({Key key, this.resource}) : super(key: key);
  @override
  _VideoInfoEditDialogState createState() => _VideoInfoEditDialogState();
}

class _InputHelper {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  String get text => controller.value.text;
  set text(String str) => controller.value = TextEditingValue(text: str);
}

class _VideoInfoEditDialogState extends State<VideoInfoEditDialog> {
  _InputHelper title = _InputHelper();
  _InputHelper url = _InputHelper();
  bool isLive = false;

  bool get isAdd => widget.resource == null;

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
      isLive: isLive,
    )..save();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    if (!isAdd) {
      title.text = widget.resource.title;
      url.text = widget.resource.url;
      isLive = widget.resource.isLive;
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(isAdd ? '添加一个视频' : '编辑信息'),
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
