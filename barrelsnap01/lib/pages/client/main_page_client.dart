import 'package:BarrelSnap/pages/client/cart_page.dart';
import 'package:flutter/material.dart';
import 'nav_bar_client.dart';
import '/components/my_drawer.dart';
import 'home_page_client.dart';
import 'profile_page_client.dart';
import 'shop_page_client.dart';

/*

M A I N P A G E

This is the MainPage. I like to think of the MainPage as the holder of all other pages.
So on this page, we have a bottom navigation bar which the user can tap. This will navigate
the app screen to the any of the ones in the 'pages' folder:

- Home Page
- Shop Page
- Profile Page
- Setting Page

*/

class MainPageClient extends StatefulWidget {
  const MainPageClient({super.key});

  @override
  State<MainPageClient> createState() => _MainPageState();
}

class _MainPageState extends State<MainPageClient> {
  // This selected index is to control the bottom nav bar
  int _selectedIndex = 0;

  // This method will update our selected index
  // when the user taps on the bottom nav bar
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages to display
  final List<Widget> _pages = [
    // home page
    const HomePageClient(),

    // shop page
    ClientShopPage(),

    // cart page
    CartPage(),
    
    // profile page
    const ProfilePageClient(),

  ];

  @override
  Widget build(BuildContext context) {
    /*

    UI - I like a more minimal style so that's what I did here, 
    but you can change up the colors and decorate it to your preference

    */
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.grey.shade800,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'B a r r e l  S n a p',
          style: TextStyle(color: Colors.grey.shade800),
        ),
      ),
      drawer: MyDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
    );
  }
}
