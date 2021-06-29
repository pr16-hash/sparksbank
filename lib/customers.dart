import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsf_bankapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CP extends StatefulWidget{

  final String name;
  final String birthday;
  final int balance;
  final int userbalance;
  final String pfp;
  CP({ Key? key ,required this.name,required this.birthday, required this.balance,required this.pfp,required this.userbalance}) : super(key: key);
  @override
  _CustomerProfile createState() => _CustomerProfile(name,birthday,balance,pfp,userbalance);
}

class _CustomerProfile extends State<CP>
{
   String name;
  String birthday;
   int balance;
   int userbalance;
  String pfp;
  _CustomerProfile(this.name,this.birthday,this.balance,this.pfp,this.userbalance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
        backgroundColor: Colors.pink[300],
      ),

      body:

      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: new AssetImage('lib/img/pfpbg1.jpg'),
              fit: BoxFit.cover
          ),
        ),
        child: ListView(

          padding: EdgeInsets.zero,

          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
             child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(),
                        ));
                  },

                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                    size: 25,
                  ),
                  label: Text('')

              ),
            ),
            DrawerHeader(
              child: ListView(children: <Widget> [
                Container(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(pfp),
                              radius: 50,)
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:130,top:10,right: 30),

                          // alignment: Alignment.center+ Alignment(0,1) ,
                          child: Text(name,
                            style: TextStyle(color: Colors.black, fontSize: 28, ),),

                        ),
                        Padding(
                          padding: EdgeInsets.only(left:130,top:60,right: 30,bottom: 20),
                         child: Text(birthday,
                            style: TextStyle(color: Colors.black, fontSize: 18, ),),

                        ),

                      ],
                    ))
              ],),
            ),


            ListTile(
                title: Column(
                  children: <Widget>[

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Their current Balance is:',style: TextStyle(color: Colors.black, fontSize: 25, ),),
                    ),

                    Container(
                      margin: const EdgeInsets.all(12.0),
                      padding: EdgeInsets.only(left:50,top:10,right: 50,bottom: 10),
                      //padding: const EdgeInsets.all(3.0),

                      decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius:BorderRadius.all(Radius.circular(50))
                      ),
                      child: Text('$balance \$',style: TextStyle(color: Colors.black, fontSize: 25, ) ,),)
                  ],
                )
            ),

            ListTile(
                title: Column(
                  children: <Widget>[


                    Padding(
                      padding: EdgeInsets.only(top: 10,left: 7.5),
                      child: TextButton.icon(
                        // child: Text("Transaction"),
                          onPressed: () {
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> TTab(balance: balance, name: name ,userbalance: userbalance )));

                            });
                          },
                          style: TextButton.styleFrom(
                              primary: Colors.black,
                              backgroundColor: Colors.lightGreenAccent[100],
                              padding: EdgeInsets.symmetric(vertical: 50,horizontal: 70),

                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50.0))),
                              textStyle: TextStyle(
                                fontSize: 25,
                                //   color: Colors.black
                              )
                          ),
                          icon: Icon(
                            Icons.monetization_on_sharp,
                            size: 25,
                            color: Colors.black,
                          ),
                          label: Text('Transfer Money')
                      ),
                    ),
                  ],
                )
            ),





          ],
        ),

      ),
    );

  }
}



class TTab extends StatefulWidget{
  int balance;
  String name;
  int userbalance;
  TTab({ Key? key, required this.balance, required this.name,required this.userbalance}) : super(key: key);
  @override
  _TransferTab createState() => _TransferTab(balance,name,userbalance);
}

class _TransferTab extends State<TTab>
{
int userbalance;
int balance;
String name;
  _TransferTab(this.balance,this.name,this.userbalance);

  TextEditingController valueofmoney = new TextEditingController();

  @override

    Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: Text("transfer"),
        backgroundColor: Colors.pink[300],
        ),
    body:
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: new AssetImage('lib/img/tbg.jpg'),
                fit: BoxFit.cover
            ),
          ),
          child: ListTile(

            title: Column(
                children: <Widget>[
                  Align
                    (
                    alignment: Alignment.bottomCenter,
                    child: TextField(
                      controller: valueofmoney,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Input amount you want to transfer to'
                      ),
                    ),
                  ),
                  Align
                    (
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text('Give amount', style: TextStyle(fontSize: 20.0)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[200],

                      ),
                      onPressed: ()
                      {
                        setState(() {
                          calculate(balance,name,userbalance);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerTab(userbalance: userbalance,)));
                        });

                      },
                    ),
                  ),
                ]
            ),
          ),
        ),


    );
    }

 Future<void> transactiontable(int num,String name) async
 {
   CollectionReference n = FirebaseFirestore.instance.collection("transaction");

   n.add({'amount':num,'name' :name,});
   return;
 }


  void calculate(balance,name,userbalance) {
  final enteredNumber = int.parse(valueofmoney.text);
  int transferred =  enteredNumber;

  transactiontable(transferred,name);
  setState(() {

    balance +=  enteredNumber;
    userbalance -= enteredNumber;
    FirebaseFirestore.instance.collection("customers").doc(name).update({'name': name, 'balance': balance});
    FirebaseFirestore.instance.collection("users").doc('Preeti Rawat').update({'balance': userbalance});
    print(balance);
    print(userbalance);
  });

  }

  }

