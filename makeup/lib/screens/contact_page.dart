
import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      bottomNavigationBar: ContactUsBottomAppBar(
        companyName: 'Make up',
        textColor: Colors.white,
        backgroundColor: Colors.purpleAccent,
        email: 'anilyilmaz108@gmail.com',
      ),
      backgroundColor: Colors.pinkAccent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ContactUs(
          dividerColor: Colors.white,
            cardColor: Colors.white,
            textColor: Colors.pink.shade900,
            logo: NetworkImage('https://png.pngtree.com/png-vector/20190429/ourmid/pngtree-eyelashes-logo-design-vector-png-image_996516.jpg'),
            email: 'anilyilmaz108@gmail.com',
            companyName: 'Make up',
            companyColor: Colors.white,
            phoneNumber: '+905075093368',
            website: 'https://makeup.project.com',
            githubUserName: 'makeupproject',
            linkedinURL: 'https://www.linkedin.com/in/an%C4%B1l-y%C4%B1lmaz-9138a9194/',
            tagLine: 'Shopping Application',
            taglineColor: Colors.white,
            twitterHandle: 'makeuppp',
            instagram: 'anil.yilmz',
            facebookHandle: 'makeuppp'
        ),
      ),
    );

  }
}
