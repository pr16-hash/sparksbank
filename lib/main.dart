import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsf_bankapp/customers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: HomeScreen(),
  ));
}



class HomeScreen extends StatelessWidget {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The sparks bank"),
         leading: Image.network('https://images.glints.com/unsafe/glints-dashboard.s3.amazonaws.com/company-logo/7a2fb475367c63f3e9cfc8ee975dc892.png'),
        backgroundColor: Colors.pink[300],

      ),
      body:
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: new AssetImage('lib/img/screen.jpg'),
          fit: BoxFit.cover
        ),
      ),
      child: StreamBuilder<QuerySnapshot>( stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){

            if(!snapshot.hasData)
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }


               return ListView(
                 children: snapshot.data!.docs.map( (documents)
                 {
                   //the balance of user stored in firebase
                   int b = documents['balance'];
                   return ListTile(
                       title: Column(
                         children: <Widget>[

                           DrawerHeader(
                               decoration: BoxDecoration(
                                   color: Colors.pink[200]
                               ),
                               child: Stack(
                                 children: <Widget>[
                                   //the profile picture of the user
                                   Align(
                                       alignment: Alignment.topLeft,
                                       child: CircleAvatar(
                                         backgroundImage: NetworkImage('https://image.shutterstock.com/image-photo/headshot-portrait-happy-ginger-girl-260nw-623804987.jpg'),
                                         radius: 50,)
                                   ),
                                   //greeting user
                                   Align(
                                     alignment: Alignment.topRight + Alignment(-0.6,0.2),
                                     child: Text('Welcome back,',
                                       style: TextStyle(color: Colors.black, fontSize: 28, ),),

                                   ),
                                   //name of user
                                   Align(
                                     alignment: Alignment.topLeft + Alignment(1.03,0.9),
                                     child: Text('Preeti Rawat',
                                       style: TextStyle(color: Colors.black, fontSize: 22, ),),

                                   ),
                                 ],
                               )),
                           ListTile(title: Column(
                             children: <Widget>[

                               Align(

                                 alignment: Alignment.topLeft,
                                 child: Text('Your current Balance is:',style: TextStyle(color: Colors.black, fontSize: 25, ),),
                               ),

                               Container(
                                 margin: const EdgeInsets.all(12.0),
                                 padding: EdgeInsets.only(left:50,top:10,right: 50,bottom: 10),
                                 //padding: const EdgeInsets.all(3.0),

                                 decoration: BoxDecoration(
                                     color: Colors.pink[100],
                                     borderRadius:BorderRadius.all(Radius.circular(50))
                                 ),
                                 child: Text(documents['balance'].toString() +' \$',style: TextStyle(color: Colors.black, fontSize: 25, ) ,),)
                             ],
                           )),
                           ListTile(
                             title: Row(
                               children: <Widget>[
                                 Padding(
                                   padding: EdgeInsets.only(top: 30,right: 7.5),
                                   child:
                                       //navigate to customer list
                                   TextButton.icon(
                                       onPressed: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(builder: (context) => CustomerTab(userbalance:b),
                                         ));
                                       },

                                       style: TextButton.styleFrom(
                                           primary: Colors.black,
                                           backgroundColor: Colors.pink[50],
                                           padding: EdgeInsets.symmetric(vertical: 50,horizontal: 5),
                                           shape: const RoundedRectangleBorder(

                                               borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                           textStyle: TextStyle(
                                             fontSize: 25,
                                             //   color: Colors.black
                                           )
                                       ),
                                       icon: Icon(
                                         Icons.assignment_ind_outlined,
                                         color: Colors.black,
                                         size: 25,
                                       ),
                                       label: Text('customer')

                                   ),
                                 ),
                                 //navigate to transaction list
                                 Padding(
                                   padding: EdgeInsets.only(top: 30,left: 7.5),
                                   child: TextButton.icon(
                                       onPressed: () {Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => TransactionTabState(userbalance:b)),
                                       );},
                                       style: TextButton.styleFrom(
                                           primary: Colors.black,
                                           backgroundColor: Colors.blue[100],
                                           padding: EdgeInsets.symmetric(vertical: 50,horizontal: 5),

                                           shape: const RoundedRectangleBorder(
                                               borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                           textStyle: TextStyle(
                                             fontSize: 25,
                                             //   color: Colors.black
                                           )
                                       ),
                                       icon: Icon(
                                         Icons.attach_money_rounded,
                                         size: 25,
                                         color: Colors.black,
                                       ),
                                       label: Text('Transaction')
                                   ),
                                 ),

                               ],
                             ),
                           ),
                           ListTile(
                               title: Column(
                                 children: <Widget>[

                                   //navigation to directly transfer to user
                                   Padding(
                                     padding: EdgeInsets.only(top: 10,left: 0,right: 0),
                                     child: TextButton.icon(
                                         onPressed: () {Navigator.push(
                                           context,
                                           MaterialPageRoute(builder: (context) => TransferTabState(userbalance:b)),
                                         );},
                                         style: TextButton.styleFrom(
                                             primary: Colors.black,
                                             backgroundColor: Colors.lightGreenAccent[100],
                                             padding: EdgeInsets.symmetric(vertical: 50,horizontal: 60),

                                             shape: const RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                             textStyle: TextStyle(
                                               fontSize: 25,
                                               //   color: Colors.black
                                             )
                                         ),
                                         icon: Icon(
                                           Icons.volunteer_activism,
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
                       )
                   );

                 }).toList(),
               );


          }
      ),
    ),

    );

  }
}


class CustomerTab extends StatefulWidget
{
  final int userbalance;
CustomerTab({ Key? key ,required this.userbalance}) : super(key: key);
  @override
  _CustomerTabState createState() => _CustomerTabState(userbalance);
}
class _CustomerTabState extends State<CustomerTab> {
  int userbalance;

  _CustomerTabState(this.userbalance);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer List"),
        backgroundColor: Colors.pink[300],
      ),
      body:

        StreamBuilder<QuerySnapshot>( stream: FirebaseFirestore.instance.collection("customers").snapshots(),
        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){
          if(!snapshot.hasData)
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

          return ListView(
            children: snapshot.data!.docs.map( (documents)
                {



                        return ListTile(
                          title: Text(documents['name']),
                          leading: new CircleAvatar(
                            backgroundImage: NetworkImage(documents['img']),
                          ),
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> CP(name:documents['name'],birthday:documents['dob'],balance:documents['balance'],pfp:documents['img'],userbalance:userbalance)));
                          },
                        );


                }).toList(),
          );
        }
        ),

    );

  }
}


class TransactionTabState extends StatefulWidget
{
  final int userbalance;
  TransactionTabState({ Key? key ,required this.userbalance}) : super(key: key);
  @override
  TransactionTab createState() => TransactionTab(userbalance);
}


class TransactionTab extends State<TransactionTabState> {
  int userbalance;
  TransactionTab(this.userbalance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction list"),
        backgroundColor: Colors.pink[300],
      ),
      body:
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage('lib/img/transferbg.jpg'),
                  fit: BoxFit.cover
              ),
            ),
            child:  StreamBuilder<QuerySnapshot>( stream: FirebaseFirestore.instance.collection("transaction").snapshots(),
                builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){
                  if(!snapshot.hasData)
                  {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    children: snapshot.data!.docs.map( (documents)
                    {
                      return ListTile(
                        title: Text(documents['name'],
                            style: TextStyle(color: Colors.black, fontSize: 25, )),
                        trailing: Text(documents['amount'].toString()+'\$',
                            style: TextStyle(color: Colors.black, fontSize: 25, )),

                      );

                    }).toList(),
                  );
                }
            ),
          ),


    );

  }
}

class TransferTabState extends StatefulWidget
{
  final int userbalance;
  TransferTabState({ Key? key ,required this.userbalance}) : super(key: key);
  @override
  TransferTab createState() => TransferTab(userbalance);
}

class TransferTab extends State<TransferTabState> {
  int userbalance;
  TransferTab(this.userbalance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer amount to"),
        backgroundColor: Colors.pink[300],
      ),
      body:
      StreamBuilder<QuerySnapshot>( stream: FirebaseFirestore.instance.collection("customers").snapshots(),
          builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){
            if(!snapshot.hasData)
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map( (documents)
              {
                return ListTile(
                  title: Text(documents['name']),
                  leading: new CircleAvatar(
                    backgroundImage: NetworkImage(documents['img']),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> TTab(balance:documents['balance'], name: documents['name'],userbalance: userbalance, )));
                  },

                );

              }).toList(),
            );
          }
      ),

    );

  }
}