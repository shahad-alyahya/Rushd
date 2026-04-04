import 'package:flutter/material.dart';
import 'Mesgsage_4.dart';
import 'add_security.dart';

class SecurityStaffList extends StatefulWidget {
  const SecurityStaffList({super.key});

  @override
  State<SecurityStaffList> createState() => _SecurityStaffListState();
}

class _SecurityStaffListState extends State<SecurityStaffList> {
  String selectedLocation = "Boulevard World";

  final List<Map<String, String>> staff = [
    {"name": "Fahad Mohammed", "email": "fahadmohammed@gmail.com"},
    {"name": "Abdurahman Almutari", "email": "abdurahmanalmutari@gmail.com"},
    {"name": "Faisal Ahmed", "email": "faisalahmed@gmail.com"},
    {"name": "Fahad Ahmed", "email": "fahadahmed@gmail.com"},
    {"name": "Sara Faisal", "email": "sarafaisal@gmail.com"},
    {"name": "lama Othman", "email": "lamaothman@gmail.com"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),

                  // status bar
                 

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      "Security Staff List",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      DropdownButton<String>(
                        value: selectedLocation,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Boulevard World",
                            child: Text(
                              "Boulevard World",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedLocation = value;
                            });
                          }
                        },
                      ),
                      const Spacer(),
                      Icon(
                        Icons.ios_share,
                        color: const Color(0xFF010E16),
                        size: 22,
                      ),
                  const SizedBox(width: 18),
                    Icon(
                     Icons.print,
                     color: const Color(0xFF010E16),
                     size: 22,
                   ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 180),
                      itemCount: staff.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 72,
                          margin: const EdgeInsets.only(bottom: 26),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF353841).withOpacity(0.21),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Color(0x14FFFFFF),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 47,
                                
                      child: Center(        
                     child: Image.asset(
                       "assets/images/user.png",
                        width: 45,
                        height: 45,
                         ),
                      ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      staff[index]["name"]!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      staff[index]["email"]!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF353841),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
              IconButton(
              icon: const Icon(
              Icons.delete_outline,
               color: Color(0xFFA61A22),
                size: 26,
               ),
           onPressed: () {
    showDialog(
  context: context,
  builder: (context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 100,
    
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 25),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Are you sure you want to delete this User?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF010E16),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [

                /// NO
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      child: const Text(
                        "NO",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF010E16),
                        ),
                      ),
                    ),
                  ),
                ),

                /// YES
                Expanded(
                  child: InkWell(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Message4(),
                        ),
                      );
                    },
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFF353841),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "YES",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  },
);
  },
),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // plus button
            Positioned(
              right: 28,
              bottom: 92,
              child: SizedBox(
                width: 68,
                height: 68,
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFFA79ECC),
                  elevation: 4,
                 
                    onPressed: () {
                      Navigator.push(
                       context,
                     MaterialPageRoute(
                    builder: (context) => const AddSecurity(),
                     ),
                   );
                    },
                 
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 34,
                  ),
                ),
              ),
            ),

            // bottom nav
            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: Center(
                child: Container(
                  width: 229,
                  height: 54,
                 decoration: BoxDecoration(
  color: const Color(0xFFFFFFFF),
  borderRadius: BorderRadius.circular(25),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ],
),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 44,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color(0xFFB1AFD0).withOpacity(0.66),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/security.png",
                            width: 22,
                            height: 22,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.home,
                        size: 20,
                        color: Color(0xFF010E16),
                      ),
                      Image.asset(
                        "assets/images/map.png",
                        width: 27,
                        height: 26,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}