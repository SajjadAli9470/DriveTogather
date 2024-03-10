import 'package:flutter/material.dart';
import '/MyDrawer.dart';



class SignUpUser extends StatefulWidget {

  @override
  State<SignUpUser> createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser>
{

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController cnicTextEditingController = TextEditingController();
  List<String> genderTypeList = ["Male", "Female"];
  String? selectedgenderType;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(27.0),
          child:Column (
            children: [



              const SizedBox(height:17),

              Padding(
                padding:const EdgeInsets.all(17.0),
                child:Image.asset("images/image.jpg",height: 120),
              ),


              const SizedBox(height:17),

              const Text(
                "Signup as a User",
                style:TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height:10),

              const Text(
                "User Details",
                style:TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height:17,),

              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  labelText: "Name",

                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color:Colors.black),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),

                  labelStyle: const  TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),

              ),
              const SizedBox(height:17,),

              TextField(
                controller: emailTextEditingController,
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  labelText: "Email",
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
              const SizedBox(height:17,),

              TextField(
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  labelText: "Phone",

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

              const SizedBox(height:17,),

              TextField(
                controller: cnicTextEditingController,
                keyboardType: TextInputType.number,
                obscureText: true,
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  labelText: "CNIC No",
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
              const SizedBox(height:17,),

              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton(
                  dropdownColor: Colors.white,
                  hint: const Text(
                    "Gender",

                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,

                    ),
                  ),
                  value: selectedgenderType,
                  onChanged: (newValue)
                  {
                    setState(()
                    {
                      selectedgenderType = newValue.toString();
                    });
                  },
                  items: genderTypeList.map((gender) {
                    return DropdownMenuItem
                      (
                      child: Text(
                        gender,
                        style: TextStyle(color: Colors.black),
                      ),
                      value: gender,
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height:10,),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ElevatedButton(
                  onPressed:()
                  {

                  },
                  style: ElevatedButton.styleFrom(
                    
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text(
                    "Signup",
                    style:TextStyle(
                      color: Colors.black,
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
