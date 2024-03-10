import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/CommonDrawer.dart';
import 'Rides/Ride.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WhereToGo extends StatefulWidget {
  const WhereToGo({super.key});

  @override
  State<WhereToGo> createState() => _WhereToGoState();
}

class _WhereToGoState extends State<WhereToGo> {

  final CommonDrawer commonDrawer = CommonDrawer();
  TextEditingController wheretogoTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      final formattedDate = DateFormat("dd-MM-yyyy").format(picked);
      setState(() {
        selectedDate = picked;
        dateTextEditingController.text = formattedDate;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      drawer: commonDrawer.build(context),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:0,left:30,right:30,bottom:30),
          child:Column (
            children: [
              const SizedBox(height:40),

              Padding(
                padding:const EdgeInsets.all(6.0),
                child:Image.asset("images/image.jpg",height: 100),
              ),

              const SizedBox(height:10),

              TextField(
                showCursor: false,
                autofocus: false,
                controller: wheretogoTextEditingController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: "Where to go",

                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color:Colors.black),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),


                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),

              ),

              const SizedBox(height:10),


              TextField(
                showCursor: false,
                autofocus: false,
                controller: dateTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  labelText: "Pick A Date",
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color:Colors.black),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),

                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
                onTap: () {
                  _selectDate(context);
                },
              ),
              const SizedBox(height:20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Ridepage(
                          destination: wheretogoTextEditingController.text.toLowerCase(),
                          date: dateTextEditingController.text,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  ),
                  child: const Text(
                    "Find",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}