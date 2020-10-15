import 'package:alrimjang/model/ToDoData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'ui/toDoItem.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var _title = '알림장 - 나의 할일';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: _title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  List<ToDoData> _toDoDataList = List<ToDoData>();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textControler = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,textAlign: TextAlign.center,),  
      ),
      body: 
         Column(
           children: [    
             Container(
               padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
               child:  
             Row(
               children: [   
                 Expanded(flex:8 , child:
                  TextField(  
                    enabled: true,
                    maxLength: 100,
                    maxLines: 1,
                    controller: _textControler,)),
                 SizedBox(width: 15,),
                 Expanded(
                   flex:2, 
                   child: RaisedButton(child: Text('추가'),onPressed: (){
                     if(_textControler.text.isNotEmpty){
                   setState(() {
                     FirebaseFirestore.instance.collection('toDo').add({ 'title':_textControler.text,'isDone':false });
                  //  widget._toDoDataList.add(ToDoData(_textControler.text));
                 }
                 );
                 }
                 },)),
               ], 
               
             )),
           StreamBuilder<QuerySnapshot>(
             stream: FirebaseFirestore.instance.collection('toDo').snapshots(),
             builder: (context, snapshot) {
               return Expanded(child: Container(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child: ListView(children: makeListTiles(snapshot),)));
             }
           ),
           ],
         ),
    );
  }
   
  List<ToDoItem> makeListTiles(AsyncSnapshot<QuerySnapshot> snapshot){
    if (snapshot.hasData){
          return snapshot.data.docs.map((e) => ToDoItem(ToDoData(e.get('title'),isDone : e.get('isDone')),(){
            setState(() {
              snapshot.data.docs.remove(e);
              FirebaseFirestore.instance.collection('toDo').doc(e.id).delete();
            });
          })
          ).toList();
    };
    
    /*
    return widget._toDoDataList.reversed.map((e) => ToDoItem(e, (){setState(() {
      widget._toDoDataList.remove(e);
      print('tetetet');
    });})).toList();
    */
  }

}
