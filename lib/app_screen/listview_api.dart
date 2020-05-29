import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:listview_apidata/network/api.dart';
import 'package:listview_apidata/network/user_data.dart';

class ListViewAPI extends StatefulWidget {
  @override
  _ListViewAPIState createState() => _ListViewAPIState();
}

class _ListViewAPIState extends State<ListViewAPI> {


  var users = new List<User>();

  _getUsers() {
    API.getUsers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => User.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    
  }

  dispose() {
    super.dispose();
  }

void _showcontent(String title, String message) {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text(message),
              ],
            ),
          ),
          actions: [
            new FlatButton(
              child: new Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var result = false;
    if (connectivityResult == ConnectivityResult.mobile) {
       print('Internet OK DATA');
      result = true;


    } else if (connectivityResult == ConnectivityResult.wifi) {
       print('Internet OK WIFI');
      result = true;
_getUsers();


    }else{
       print('Internet NOooo');
       _showcontent("Alert", "No Internet connection");
      result = false;
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 20.0,
              color: Colors.redAccent,
            ),
            Container(
              height: 60.0,
              color: Colors.redAccent,
              child: Center(
                child: Text(
                  "Listview",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

          
          

          ],
        ),

ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(users[index].name),
              subtitle: Text(users[index].email),
            onTap: ()=>{
              _showcontent("$index","${users[index].name}")
            },);
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
            child: FloatingActionButton(
            backgroundColor: Colors.redAccent,
            child: Icon(
              Icons.sync,
              color: Colors.white,
            ),
            onPressed: () => {
              checkInternetConnection()
            }),
          )
        )
        
      ],
    ));
  }
}
