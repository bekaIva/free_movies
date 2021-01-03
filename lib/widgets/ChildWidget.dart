import 'package:flutter/material.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/home/model/home_response.dart' as homeResponse;

class ChildWidget extends StatefulWidget {
  final Function onTap;
  final bool isSelected;
  final homeResponse.Child child;
  ChildWidget({@required this.child, @required this.isSelected,this.onTap})
      : assert(child != null),
        assert(isSelected != null);
  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  @override
  Widget build(BuildContext context) {
    return TextButton(style: TextButton.styleFrom(primary: widget.isSelected?kHeaderColor:kTitleColor),onPressed: widget.onTap, child: Text(
      widget.child.title,
      style: TextStyle(color:widget.isSelected?kHeaderColor:kTitleColor, fontSize: 18),
    ));
  }
}
