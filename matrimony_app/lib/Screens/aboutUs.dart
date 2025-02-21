import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 6,
                child: Image.asset(
                  "asset/images/logo.png",
                  height: 75,
                  width: 75,
                ),
              ),
              SizedBox(height: 10,),
              Text(
              "MATRIFY",
                style: TextStyle(
                  letterSpacing: 5,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                elevation: 6.0,
                shadowColor: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "Meet Our Team",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800], // Modern font color
                        ),
                      ),
                      Divider(),
                      _buildTableRow("Developed by", "Ida Gaurav"),
                      _buildTableRow("Mentored by", "Prof. Mehul Bhundiya, Computer Engineering Department"),
                      _buildTableRow("Explored by", "ASWDC, School of Computer Science"),
                      _buildTableRow("Eulogized by", "Darshan University"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                elevation: 6.0,
                shadowColor: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "About ASWDC",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800], // Modern font color
                        ),
                      ),
                      Divider(),
                      Image.asset("asset/images/aswdc.png"),
                      SizedBox(height: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ASWDC is Application, Software and Website Development Center @ Darshan University run by Students and Staff of School of Computer Science.",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey[600],
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "Sole purpose of ASWDC is to bridge gap between university curriculum & industry demands.Students learn cutting edge technologies, develop real world application & experiences professional environment @ ASWDC under guidance of industry experts & faculty members.",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey[600],
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                elevation: 6.0,
                shadowColor: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "Contact Us",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800], // Modern font color
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Icon(Icons.email),
                          Text("aswdc@darshan.ac.in",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey[600],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        children: [
                          Icon(Icons.public),
                          Text("www.darshan.ac.in",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.blueGrey[600],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildTableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[700],
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Colors.blueGrey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
