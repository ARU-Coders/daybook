import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 250),
          child: GestureDetector(
            onLongPress: () {
              Clipboard.setData(new ClipboardData(text: widget.text.trim()));
                final snackBar = SnackBar(
                content: Text("Journey Description copied to clipboard!"),
                duration: Duration(seconds: 3),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
            onTap: ()=> setState(()=>widget.isExpanded = !widget.isExpanded),
            child: ConstrainedBox(
                constraints: widget.isExpanded
                    ? BoxConstraints()
                    : BoxConstraints(maxHeight: 75.0),
                child: Text(
                  widget.text,
                  softWrap: true,
                  style: TextStyle(
                      // color: Colors.black87,
                      fontSize: 12.5,
                      letterSpacing: 0.2,
                      fontFamily: "Times New Roman"),
                )),
          )),
      widget.isExpanded
          ? SizedBox(
              height: 30,
              width: 30,
              child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onPressed: () => setState(() => widget.isExpanded = false)),
            )
          : SizedBox(
              height: 30,
              width: 30,
              child: IconButton(
                  icon: Icon(
                    Icons.more_horiz_outlined,
                    size: 20,
                  ),
                  onPressed: () => setState(() => widget.isExpanded = true)))
    ]);
  }
}
