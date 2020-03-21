import 'package:cdnbye_ijk_example/style/color.dart';
import 'package:cdnbye_ijk_example/style/size.dart';
import 'package:flutter/material.dart';

class StandardTextStyle {
  static const TextStyle big = TextStyle(
    fontFamily: 'MyraidPro',
    fontWeight: FontWeight.w600,
    fontSize: SysSize.big,
    color: ColorPlate.darkGray,
    inherit: true,
  );
  static const TextStyle normalW = TextStyle(
    fontFamily: 'MyraidPro',
    fontWeight: FontWeight.w600,
    fontSize: SysSize.normal,
    color: ColorPlate.darkGray,
    inherit: true,
  );
  static const TextStyle normal = TextStyle(
    fontFamily: 'MyraidPro',
    fontWeight: FontWeight.normal,
    fontSize: SysSize.normal,
    color: ColorPlate.darkGray,
    inherit: true,
  );
  static const TextStyle small = TextStyle(
    fontFamily: 'MyraidPro',
    fontWeight: FontWeight.normal,
    fontSize: SysSize.small,
    color: ColorPlate.gray,
    inherit: true,
  );
}

class StText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextStyle defaultStyle;
  final bool enableOffset;

  const StText({
    Key key,
    this.text,
    this.style,
    this.defaultStyle,
    this.enableOffset: false,
  }) : super(key: key);

  const StText.small(
    String text, {
    Key key,
    TextStyle style,
    bool enableOffset,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.small,
          enableOffset: enableOffset,
        );

  const StText.normal(
    String text, {
    Key key,
    TextStyle style,
    bool enableOffset,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.normal,
          enableOffset: enableOffset,
        );

  const StText.big(
    String text, {
    Key key,
    TextStyle style,
    bool enableOffset,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.big,
          enableOffset: enableOffset,
        );

  double get offset {
    if (!isAscii) {
      return 0;
    }
    if (enableOffset != true) {
      return 0;
    }
    if (defaultStyle != null) {
      return (defaultStyle?.fontSize ?? 0) * 2 / 10;
    }
    if (style != null) {
      return (style?.fontSize ?? 0) * 2 / 10;
    }
    return 0;
  }

  bool get isAscii {
    for (var unit in text.codeUnits) {
      if (unit > 0xff) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: 用于修正字体偏移无法对齐,注意：如判断字体为中文等，需禁用偏移
      padding: EdgeInsets.only(top: offset),
      child: DefaultTextStyle(
        style: defaultStyle,
        child: Text(
          text,
          maxLines: 3,
          style: style,
        ),
      ),
    );
  }
}
