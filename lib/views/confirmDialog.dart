import 'package:cdnbye_ijk_example/style/color.dart';
import 'package:cdnbye_ijk_example/style/text.dart';
import 'package:flutter/material.dart';
import 'package:tapped/tapped.dart';

const String titleText = '提示';
const String cancelText = '取消';
const String closeText = '关闭';
const String okText = '确定';

enum ConfirmType {
  info,
  success,
  warning,
  danger,
}

textOfConfirmType(ConfirmType type) => [
      'Info',
      'Success',
      'Warning',
      'Danger',
    ][type.index];

/// 显示对话窗口
Future<bool> confirm(
  context, {
  String title,
  String content,
  String ok,
  String cancel,
  ConfirmType type,
  double width,
  bool onlyCloseButton: false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ConfirmDialog(
      title: title,
      content: content,
      ok: ok,
      cancel: cancel,
      type: type ?? ConfirmType.info,
      width: width ?? 300,
      onlyCloseButton: onlyCloseButton,
    ),
  );
}

/// 使用ResMsg显示对话窗口
// Future<bool> confirmResMsg(context, ResMsg<dynamic> msg, [String title]) {
//   return confirm(
//     context,
//     title: title ?? titleText,
//     content: msg.msg,
//     type: msg.success ? ConfirmType.success : ConfirmType.danger,
//   );
// }

class ConfirmDialog extends StatelessWidget {
  final ConfirmType type;
  final String title;
  final String content;
  final double width;
  final String ok;
  final String cancel;
  final bool onlyCloseButton;

  const ConfirmDialog({
    Key key,
    this.title,
    this.content,
    this.ok,
    this.cancel,
    this.type: ConfirmType.info,
    this.width: 300,
    this.onlyCloseButton: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color color;
    switch (type) {
      case ConfirmType.danger:
        iconData = Icons.info;
        color = ColorPlate.red;
        break;
      case ConfirmType.info:
        iconData = Icons.info;
        color = ColorPlate.mainColor;
        break;
      case ConfirmType.success:
        iconData = Icons.info_outline;
        color = ColorPlate.elockGreen;
        break;
      case ConfirmType.warning:
        iconData = Icons.warning;
        color = Colors.orange;
        break;
    }

    Widget icon = Container(
      padding: EdgeInsets.only(right: 8),
      child: Icon(
        iconData,
        color: color,
        size: 30,
      ),
    );

    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: EdgeInsets.fromLTRB(2, 0, 2, 4),
      title: Row(
        children: <Widget>[
          Expanded(
            child: StText.big(
              title ?? textOfConfirmType(type),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          icon,
        ],
      ),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          width: width,
          constraints: BoxConstraints(minHeight: 120),
          child: StText.normal(content ?? ''),
        ),
        Container(
          width: width,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: <Widget>[
              Expanded(
                child: DialogButton(
                  title: onlyCloseButton ? closeText : (cancel ?? cancelText),
                  pimary: false,
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
              onlyCloseButton
                  ? Container()
                  : Expanded(
                      child: DialogButton(
                        title: ok ?? okText,
                        color: color,
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
            ],
          ),
        )
      ],
    );
  }
}

class DialogButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final Color color;
  final bool pimary;
  final double height;
  final double width;

  const DialogButton({
    Key key,
    this.onTap,
    this.title,
    this.pimary: true,
    this.color,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration d;
    if (pimary) {
      d = BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      );
    } else {
      d = BoxDecoration(
        color: ColorPlate.lightGray,
        borderRadius: BorderRadius.circular(6),
      );
    }
    return Tapped(
      onTap: onTap,
      child: Container(
        height: height ?? 40,
        width: width ?? 368,
        margin: EdgeInsets.fromLTRB(6, 8, 6, 8),
        alignment: Alignment.center,
        decoration: d,
        child: StText.big(
          title,
          enableOffset: true,
          style: TextStyle(
            color: pimary ? ColorPlate.white : null,
          ),
        ),
      ),
    );
  }
}
