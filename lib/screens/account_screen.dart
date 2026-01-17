import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/text_field_widget.dart';
import 'login_screen.dart'; 

class AccountScreen extends StatefulWidget {
  final String userName;

  const AccountScreen({super.key, required this.userName});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 28),
          onPressed: () => Navigator.pop(context), // Actions the cross sign
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // PROFILE CIRCLE WITH USER ICON
          const CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFFB366F1),
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Text(
            widget.userName,
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          
          // SCROLLABLE LIST AREA
          Expanded(
            child: Container(
              decoration: BoxDecoration(

                color: Colors.grey.withOpacity(double.parse("0.3")),
                // borderRadius: BorderRadius.circular(20),
                // color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  _profileOption(Icons.tune, "More Information"),
                  _profileOption(Icons.notifications, "Notification"),
                  _profileOption(Icons.key, "Change Password"),
                  _profileOption(Icons.security, "Security"),
                  _profileOption(Icons.language, "Language"),
                  _profileOption(Icons.attach_money, "Currency"),
                  _profileOption(Icons.settings, "Setting"),
                  _profileOption(Icons.star, "Feedback"),
                  // LOGOUT BUTTON WITH YOUR NAVIGATION LOGIC
                  _profileOption(
                    Icons.logout, 
                    "Log Out", 
                    isLogout: true,
                    onTap: () {
                      Future.delayed(const Duration(seconds: 1), () {
                        if (!mounted) return; // Safety check
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false, // Clears the backstack
                        );
                      });
                    }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black,
        currentIndex: 3, 
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: "Graph"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Transaction"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Account"),
        ],
      ),
    );
  }

  // HELPER WIDGET
  Widget _profileOption(IconData icon, String title, {VoidCallback? onTap, bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.black),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, 
            fontSize: 15,
            color: isLogout ? Colors.red : Colors.black,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}