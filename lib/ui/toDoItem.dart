import 'package:alrimjang/model/ToDoData.dart';
import 'package:flutter/material.dart';

class  ToDoItem extends StatefulWidget {
  final ToDoData _toDoData;
  final void Function() remove;
  
  TextStyle _inComplete;
  TextStyle _complete;
  TextStyle _applyStyle;

  ToDoItem(@required this._toDoData,this.remove){
   _inComplete = TextStyle();
   _complete = TextStyle(fontStyle: FontStyle.italic,decoration: TextDecoration.lineThrough);
   
    if(_toDoData.isDone){
        _applyStyle = _complete;   
    }else{
       _applyStyle = _inComplete;
    }
  }

  @override
  _ToDoItem createState() => _ToDoItem();
}

class _ToDoItem extends State<ToDoItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        if(widget._toDoData.isDone){
        setState(() {
          widget._toDoData.isDone = false;
          widget._applyStyle = widget._inComplete;   
        });
      }else{
        setState(() {
          widget._toDoData.isDone = true;
        widget._applyStyle = widget._complete;
        });
      }},
      title:Text(widget._toDoData.title,style: widget._applyStyle,),
    trailing: IconButton(icon: Icon(Icons.delete_forever), onPressed:widget.remove,
     ),
    );
  }
}