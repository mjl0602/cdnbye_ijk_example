import 'package:cdnbye_ijk_example/global/userDefault.dart';
import 'package:cdnbye_ijk_example/r.dart';
import 'package:cdnbye_ijk_example/style/color.dart';
import 'package:cdnbye_ijk_example/style/text.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StText.big(
          '设置',
          style: TextStyle(
            color: ColorPlate.white,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Center(
              child: Image.asset(R.assetsLogo),
            ),
          ),
          _Row(
            title: 'Token: ',
            right: Container(
              padding: EdgeInsets.all(12),
              child: StText.normal(
                UserDefault.token.value,
                style: TextStyle(
                  color: ColorPlate.gray,
                ),
              ),
            ),
            onTap: () async {
              UserDefault.token.value = await showDialog(
                context: context,
                builder: (ctx) => _InputDialog(),
              );
              setState(() {});
            },
          ),
          _Row(
            title: '自动播放: ' + (UserDefault.autoplay.value ? '开' : '关'),
            right: Switch(
              value: UserDefault.autoplay.value,
              onChanged: (v) => setState(
                () => UserDefault.autoplay.value = v,
              ),
            ),
          ),
          _Row(
            title: '横屏转向: ' + (UserDefault.landscapeLeft.value ? '向左' : '向右'),
            right: Switch(
              value: UserDefault.landscapeLeft.value,
              onChanged: (v) => setState(
                () => UserDefault.landscapeLeft.value = v,
              ),
            ),
          ),
          // _Row(
          //   title: '使用硬解码: ' + (UserDefault.userHardware.value ? '开' : '关'),
          //   right: Switch(
          //     value: UserDefault.userHardware.value,
          //     onChanged: (v) => setState(
          //       () => UserDefault.userHardware.value = v,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String title;
  final Widget right;
  final Function onTap;
  const _Row({
    Key key,
    this.title,
    this.right,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var body = Container(
      color: ColorPlate.white,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ColorPlate.lightGray,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: <Widget>[
              Expanded(
                child: StText.normal(
                  title ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              right ?? Container(),
            ],
          ),
        ),
      ),
    );
    if (onTap == null) {
      return body;
    }
    return Tapped(
      onTap: onTap,
      child: body,
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
  TextEditingController _controller = TextEditingController(
    text: UserDefault.token.value,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('输入TOKEN'),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      children: <Widget>[
        TextField(
          controller: _controller,
          onSubmitted: (text) {
            Navigator.of(context).pop(_controller.text);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Tapped(
              child: Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  '复原为free',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop('free');
              },
            ),
            Tapped(
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
          ],
        )
      ],
    );
  }
}
