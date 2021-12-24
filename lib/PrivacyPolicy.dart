import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}


_googlePlayURL() async {
  const url = 'https://www.google.com/policies/privacy/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
_googleAnalyticsURL() async {
  const url = 'https://firebase.google.com/policies/analytics';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
_crashlyticsURL() async {
  const url = 'https://firebase.google.com/support/privacy/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
_facebookURL() async {
  const url = 'https://www.facebook.com/about/privacy/update/printable';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
_firebaseURL() async {
  const url = 'https://firebase.google.com/support/privacy';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
_facebookAudienceNetworkURL() async {
  const url = 'https://www.facebook.com/policy.php';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B5E20),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: () {Navigator.pop(context);
        }
        ),
        title: Text("Privacy Policy", style: TextStyle(fontSize: 24.0, color: Colors.white , fontWeight: FontWeight.bold),),
      ),
      body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly built the Eattly app as an Ad Supported app. This SERVICE is provided by Eattly at no cost and is intended for use as is."
                    "This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service."
                    "If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy."
                    "The terms used in this Privacy Policy have the same meanings as in our Terms of Services, which is accessible at Eattly unless otherwise defined in this Privacy Policy.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "When you use these services, you’ll share some information with us. So we want to be upfront about the information we collect, how we use it, whom we share it with, "
                    "and the controls we give you to access, update, and delete your information.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "That’s why we’ve written this Privacy Policy. Of course, if you still have questions "
                    "about anything in our Privacy Policy, just contact us e.g via email: eattly.app@gmail.com",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("What data do we collect ?", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "There are three basic categories of information we collect:",
                style: TextStyle(fontSize: 17.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Information you provide.",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Information we get when you use our services.",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Information we get from third parties.",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Here’s a little more detail on each of these categories.",
                style: TextStyle(fontSize: 17.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Information You Provide",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "When you interact with our services, we collect information that you provide to us. For example, all of our services require you to set up an Eattly account, so we need to collect a few important details about you, such as your name, surname,"
                    " username, password and email address. We may also ask you to provide us with some additional information that will be publicly visible on our services, such as a profile picture or nickname and name and surname (you can change your name and surname in our app).",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Of course, you’ll also provide us whatever information you send through our services, such as recipes, photos, comments, follows and likes etc. Keep in mind that the users who view your recipes, comments and any other content can always "
                    "save that content or copy it outside the app. So, the same common sense that applies to the internet at large applies to Eattly as well. Don’t send messages or share content that you wouldn’t want someone to save or share.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "When you contact customer support or communicate with us in any other way, we’ll collect whatever information you volunteer or that we need to resolve your question.",
                style: TextStyle(fontSize: 17.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Information We Get When You Use Our Services",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "When you use our services, we collect information about which of those services you’ve used and how you’ve used them. We might know, for instance, that you watched a particular recipes, saw a specific ad for a certain period of time, "
                    "and shared a few recipes. Here’s a fuller explanation of the types of information we collect when you use our services:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Usage Information. We collect information about your activity through our services. For example, we may collect information about how you interact with our services, such as which recipes do you like, comment or which people do you follow or search.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Content Information. We collect content you create on our services, such as custom recipes, and information about the content you create or provide, such as if the recipient has viewed the content and the metadata that is provided with the content.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Device Information. We collect information from and about the devices you use. For example, we collect:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   information about your hardware and software, such as the hardware model, operating system version, device memory, advertising identifiers, unique application identifiers, apps installed, unique device identifiers, browser type, language, battery level, and time zone;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   information about your wireless and mobile network connections, such as mobile phone number, service provider, IP address, and signal strength.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Camera and Photos. Many of our services require us to collect images and other information from your device’s camera and photos. For example, you won’t be able to add photo of your dish and recipe from your camera roll unless we can access your camera or photos.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Location Information. When you use our services we may collect information about your location. With your permission, we may also collect information about your precise location using methods that include GPS, wireless networks, cell towers, Wi-Fi access points, and other sensors.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Information Collected by Cookies and Other Technologies. Like most online services and mobile applications, we may use cookies and other technologies, such as web beacons, web storage, and unique advertising identifiers, to collect information about your activity, browser, and device. "
                    "We may also use these technologies to collect information when you interact with services we offer through one of our partners, such as advertising and commerce features. For example, we may use information collected on other websites to show you more relevant ads."
                    " Most web browsers are set to accept cookies by default. If you prefer, you can usually remove or reject browser cookies through the settings on your browser or device. Keep in mind, though, that removing or rejecting cookies could affect the availability and functionality of our services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Log Information. We also collect log information when you use our website and app such as:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   details about how you’ve used our services;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   device information, such as your web browser type and language;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   access times;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   pages viewed;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   IP address;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   identifiers associated with cookies or other technologies that may uniquely identify your device or browser; and",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   pages you visited before or after navigating to our website.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Information We Collect from Third Parties",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We may collect information about you from other users, our affiliates, and third parties. Here are a few examples.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Advertisers, app developers, publishers, and other third parties may share information with us as well. We may use this information, among other ways, to help target or measure the performance of ads.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   If another user uploads their contact list, we may combine information from that user’s contact list with other information we have collected about you.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to gmail account, name and surname, profile photo, username. The information that we request will be retained by us and used as described in this privacy policy."
                    "The app does use third party services that may collect information used to identify you.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Links to privacy policies of third party service providers used by the app:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Google Play Services", style: TextStyle(fontSize: 16.0),),
                onTap: _googlePlayURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Google Analytics for Firebase", style: TextStyle(fontSize: 16.0),),
                onTap: _googleAnalyticsURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Firebase Crashlytics", style: TextStyle(fontSize: 16.0),),
                onTap: _crashlyticsURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Facebook", style: TextStyle(fontSize: 16.0),),
                onTap: _facebookURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Google Firebase", style: TextStyle(fontSize: 16.0),),
                onTap: _firebaseURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Facebook Audience Network ", style: TextStyle(fontSize: 16.0),),
                onTap: _facebookAudienceNetworkURL,
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("How do we collect your data ?", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You directly provide Our Company with most of the data we collect. We collect data and process data when you:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Register online or place an order for any of our products or services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Voluntarily complete a customer survey or provide feedback on any of our message boards or via email.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Use or view our website via your browser’s cookies.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Use our services e.g add new recipes, comment or like others recipes and follow other users etc.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("How will we use your data ?", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "What do we do with the information we collect ? We provide you with an amazing set of products and services that we relentlessly improve. Here are the ways we do that:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   develop, operate, improve, deliver, maintain, and protect our products and services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   send you communications, including by email. For example, we may use email to respond to support inquiries or to share information about our products, services, and promotional offers that we think may interest you.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   monitor and analyze trends and usage.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   personalize our services by, among other things, suggesting friends, profile information, or customizing the content we show you, including ads.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   contextualize your experience by, among other things,",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   provide and improve our advertising services, ad targeting, and ad measurement, including through the use of your precise location information (again, if you’ve given us permission to collect that information), both on and off our services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   enhance the safety and security of our products and services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   verify your identity and prevent fraud or other unauthorized or illegal activity.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   use information we’ve collected from cookies and other technology to enhance our services and your experience with them.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   enforce our Terms of Service and other usage policies and comply with legal requirements.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("How do we store your data ?", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly securely stores your data at Google Firebase Database and Google Firebase storage and protected by Google Firebase Database Security Rules and Google Firebase Storage Security Rules. ",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   We store your basic account information—like your name, and email address—and list of friends or recipes until you ask us to delete them.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   We’re constantly collecting and updating information about the things you might like and dislike, so we can provide you with more relevant content and advertisements.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "If you ever decide to stop using Eattly, you can just ask us to delete your account. We’ll also delete most of the information we’ve collected about you after you’ve been inactive for a while—but don’t worry, we’ll try to contact you first!",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "There may be legal requirements to store your data and we may need to suspend those deletion practices if we receive valid legal process asking us to preserve content, if we receive reports of abuse or other Terms of Service violations, "
                    " or if your account or content created by you is flagged by our automated systems for abuse or other Terms of Service violations. Finally, we may also retain certain information in backup for a limited period of time or as required by law.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Control Over Your Information", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We want you to be in control of your information, so we provide you with the following tools.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Access, Correction, and Portability. You can access and edit most of your basic account information right in our app. You can also contact us via email: eattly.app@gmail.com to obtain a copy of information that isn’t available in our apps in a portable format,"
                    " so you can move it or store it wherever you want. Because your privacy is important to us, we will ask you to verify your identity or provide additional information before we let you access or update your personal information. We may also reject your request to access or update your personal information for a number of reasons, including, for example, if the request risks the privacy of other users or is unlawful.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Revoking permissions. In most cases, if you let us use your information, you can simply revoke your permission by contacting us via email: eattly.app@gmail.com . Of course, if you do that, certain services may lose full functionality.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   Deletion. While we hope you’ll remain a lifelong user of Eattly, if for some reason you ever want to delete your account, just contact us via email: eattly.app@gmail.com. You can also delete some information in the app, like your recipes.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("How We Share Information", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We may share information about you in the following ways:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   With other users. We may share the following information with other users:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   information about you, such as your username, name, surname (you can change your name and surname in app) or profile photo.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   information about how you have interacted with our services, such as the names of users you follow, and other information that will help our users understand your connections with others using our services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   content you post or send. Your recipes, profile, username, likes and comments will are visible to all of the users of Eattly.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   With all users, our business partners, and the general public. We may share the following information with all users as well as with our business partners and the general public:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   public information like your name, username, recipes, comments, likes and profile pictures. ",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "This content may be viewed and shared by the public at large both on and off our services, including through search results, on websites, in apps, and in online and offline broadcasts.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   With our affiliates.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   With third parties. We may share information about you with service providers who perform services on our behalf, including to measure and optimize the performance of ads and deliver more relevant ads, including on third-party websites and apps.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Third party service providers used by the app and links to their privacy policies: ",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Google Play Services", style: TextStyle(fontSize: 16.0),),
                onTap: _googlePlayURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Google Analytics for Firebase", style: TextStyle(fontSize: 16.0),),
                onTap: _googleAnalyticsURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Firebase Crashlytics", style: TextStyle(fontSize: 16.0),),
                onTap: _crashlyticsURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Facebook", style: TextStyle(fontSize: 16.0),),
                onTap: _facebookURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Google Firebase", style: TextStyle(fontSize: 16.0),),
                onTap: _firebaseURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Facebook Audience Network ", style: TextStyle(fontSize: 16.0),),
                onTap: _facebookAudienceNetworkURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   We may share information about you with business partners that provide services and functionality on our services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   We may share information about you, such as device and usage information, to help us and others prevent fraud.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   We may share information about you for legal, safety, and security reasons. We may share information about you if we reasonably believe that disclosing the information is needed to:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "               -   comply with any valid legal process, governmental request, or applicable law, rule, or regulation.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "               -   investigate, remedy, or enforce potential Terms of Service violations.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "               -   protect the rights, property, or safety of us, our users, or others.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "               -   detect and resolve any fraud or security concerns.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   We may share information about you as part of a merger or acquisition. If Eattly gets involved in a merger, asset sale, financing, liquidation or bankruptcy, or acquisition of all or some portion of our business to another company, we may share your information with that company before and after the transaction closes.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Third-Party Content and Integrations", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Our services may contain third-party content and integrations. Examples include third-party ads provided by Facebook Audience Network. Through these integrations, you may be providing information to the third party as well as to Eattly. "
                    "We are not responsible for how those third parties collect or use your information. As always, we encourage you to review the privacy policies of every third-party service that you visit or use, including those third parties you interact with through our services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "List of third parties that Eattly is connected:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Google Play Services", style: TextStyle(fontSize: 16.0),),
                onTap: _googlePlayURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Google Analytics for Firebase", style: TextStyle(fontSize: 16.0),),
                onTap: _googleAnalyticsURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Firebase Crashlytics", style: TextStyle(fontSize: 16.0),),
                onTap: _crashlyticsURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Facebook", style: TextStyle(fontSize: 16.0),),
                onTap: _facebookURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Google Firebase", style: TextStyle(fontSize: 16.0),),
                onTap: _firebaseURL,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Text("Facebook Audience Network ", style: TextStyle(fontSize: 16.0),),
                onTap: _facebookAudienceNetworkURL,
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Marketing", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly would like to send you information about products and services of ours that we think you might like.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "If you are using our services you automatically agree to receive marketing but you may always opt out at a later date.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You have the right at any time to stop Eattly from contacting you for marketing purposes.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "If you no longer wish to be contacted for marketing purposes, please contact us via email and tell us that you don’t want to receive marketing from us, eattly.app@gmail.com .",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("What are your data protection rights ?", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We would like to make sure you are fully aware of all of your data protection rights. Every user is entitled to the following:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "The right to access",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You have the right to request Eattly for copies of your personal data. We may charge you a small fee for this service.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "The right to rectification",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You have the right to request that Eattly correct any information you believe is inaccurate. You also have the right to request Eattly to complete the information you believe is incomplete.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "The right to erasure",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You have the right to request that Eattly erase your personal data, under certain conditions.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "The right to restrict processing",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You have the right to request that Eattly restrict the processing of your personal data, under certain conditions.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "The right to object to processing",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You have the right to object to Eattly processing of your personal data, under certain conditions.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "The right to data portability",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You have the right to request that Eattly transfer the data that we have collected to another organization, or directly to you, under certain conditions.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us at our email:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Or write to us: eattly.app@gmail.com",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Cookies", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Cookies are text files placed on your computer to collect standard Internet log information and visitor behavior information. When you visit our websites, we may collect information from you automatically through cookies or similar technology.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "For further information, visit allaboutcookies.org.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("How do we use cookies ?", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Our Company uses cookies in a range of ways to improve your experience on our, including:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   Keeping you signed in",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   Understanding how you use our app",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   Providing and improving our app.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "What types of cookies do we use ?",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "There are a number of different types of cookies, however, we use :",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   Functionality – Our Company uses these cookies so that we recognize you on our website or app and remember your previously selected preferences. These could include what language you prefer and location you are in. A mix of first-party and third-party cookies are used.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   Advertising – Our Company uses these cookies to collect information about your visit to our website, the content you viewed, the links you followed and information about your browser, device, and your IP address. Our Company sometimes shares some limited aspects of this data with third parties for advertising purposes. We may also share online data collected through cookies with our advertising partners. This means that when you visit another website, you may be shown advertising based on your browsing patterns on our website.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("How to manage cookies ", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You can set your browser not to accept cookies. However, in a few cases, some of our features may not function as a result.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Privacy policies of other websites", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly contains links to other websites and apps. Our privacy policy applies only to our app, so if you click on a link to another website, you should read their privacy policy.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Users in the European Union", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "If you’re a user in the European Union, you should know that Eattly is the controller of your personal information. Here is some additional information we would like to bring to your attention:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Rights of Access, Deletion, Correction, and Portability",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You can exercise your rights of access, deletion, correction, and portability as described in the Control Over Your Information section above.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Bases for Using Your Information",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Your country only allows us to use your personal information when certain conditions apply. These conditions are called “legal bases” and, at Eattly, we typically rely on one of three:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   Legitimate interest. Another reason we might use your information is because we have—or a third party has—a legitimate interest in doing so. For example, we need to use your information to provide and improve our services, including protecting your account, delivering your recipes, providing customer support, and helping you find friends and content we think you’ll like. Because most of our services are free, we also use some information about you to try and show you ads you’ll find interesting. An important point to understand about legitimate interest is that our interests don’t outweigh your right to privacy, so we only rely on legitimate interest when we think the way we are using your data doesn’t significantly impact your privacy or would be expected by you, or there is a compelling reason to do so.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   Consent. In some cases we’ll ask for consent to use your information for specific purposes. If we do, we’ll make sure you can revoke your consent in our services or through your device permissions. Even if we’re not relying on consent to use your information, we may ask you for permission to access data like contacts and location.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "          -   Legal obligation. We may be required to use your personal information to comply with the law, like when we respond to valid legal process or need to take action to protect our users.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Your Right to Object",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You have the right to object to our use of your information. With many types of data, we’ve provided you with the ability to simply delete it if you don’t want us processing it anymore. You can do these things in the app. If there are other types of information you don’t agree with us processing, you can contact us via e-mail: eattly.app@gmail.com",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "International Transfers",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We may collect your personal information from, transfer it to, and store and process it in the United States and other countries outside of where you live. Whenever we share information of EU users outside the EU we make sure an adequate transfer mechanism is in place. You can find more information on the categories of third parties we share information with in Third-Party Content and Integrations part above.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Complaints ? If you’re based in the EU, you can always file a complaint with the supervisory authority in your Member State.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("California Residents", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "If you’re a California resident, you have certain privacy rights under California law, including the California Consumer Privacy Act of 2018 (“CCPA”).",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Children", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Our services are not intended for—and we don’t direct them to—anyone under 13. And that’s why we do not knowingly collect personal information from anyone under 13. In addition, we may limit how we collect, use, and store some of the information of EU users between 13 and 16. In some cases, this means we will be unable to provide certain functionality to these users. If we need to rely on consent as a legal basis for processing your information and your country requires consent from a parent, we may require your parent’s consent before we collect and use that information.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Security", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Changes to our privacy policy", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We may change this Privacy Policy from time to time. But when we do, we’ll let you know one way or another. Sometimes, we’ll let you know by revising the date at the top of the Privacy Policy that’s available on our mobile application. Other times, we may provide you with additional notice (such as adding a statement to our websites’ homepages or providing you with an in-app notification)."
                    "This privacy policy was last updated on 11 June 2020.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("How to contact us", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "If you have any questions about Our privacy policy, the data we hold on you, or you would like to exercise one of your data protection rights, please do not hesitate to contact us.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Email us at: eattly.app@gmail.com",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("How to contact the appropriate authority", style: TextStyle(fontSize: 20.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Should you wish to report a complaint or if you feel that Our Company has not addressed your concern in a satisfactory manner, you may contact the Information Commissioner’s Office.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Many of our Services let you create, upload, post, send, receive, and store content. When you do that, you retain whatever ownership rights in"
                    "that content you had to begin with. But you grant us a licence to use that content. How broad that licence is depends on which Services you use and the settings you have selected.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "For all content you submit to the Services, you grant Eattly, and our affiliates a worldwide, royalty-free, sublicensable, and transferable licence to host, store, use, display, reproduce, modify, adapt, edit, publish, and distribute that content for as long as you use the Services."
                    "This licence is for the limited purpose of operating, developing, providing, promoting, and improving the Services and researching and developing new ones.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Because Public Content is public by nature and records matters of public interest, the licence you grant us for this content is broader. For Public Content, you grant Eattly, our affiliates, and our business partners all of the same rights you grant for non-Public Content in the previous paragraph, as well as a licence to create "
                    "derivative works from, promote, exhibit, broadcast, syndicate, publicly perform and publicly display Public Content in any form and in any and all media or distribution methods (now known or later developed). To the extent it’s necessary, when you appear in, create, upload, post, or send Public Content, you also grant Eattly, our ",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "affiliates, and our business partners the unrestricted, worldwide right and licence to use your name, likeness. This means, among other things, that you will not be entitled to any compensation from Eattly, our affiliates, or our business partners if "
                    "your name, likeness is conveyed through the Services, either on the Eattly application or on one of our business partners’ platforms.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "For more information about how to tailor who can watch your content, please take a look at our Privacy Policy.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We reserve the right to delete any content (i) which we think violates these Terms, or (ii) if necessary to comply with our legal obligations. "
                    "However, you alone, remain responsible for the content you create, upload, post, send, or store through the Services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "The Services may contain advertisements. In consideration for Eattly letting you access and use the Services, you agree that we, Eattly., our affiliates, and our third-party partners may place advertising on the Services,"
                    "including personalised advertising based upon the information you provide us or we collect or obtain about you. Because the Services contain content that you and other users provide us, advertising may sometimes appear near, between, over, or in your content.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "With respect to your use of Eattly, you grant Eattly and our affiliates and business partners a worldwide, perpetual, royalty-free, sublicensable, and transferable licence to host, store, use, display, reproduce, modify, adapt, edit, publish, distribute, promote, exhibit, broadcast, syndicate, publicly perform, and distribute (a) any "
                    "recipes added to Eattly, and (b) any materials you create using the Eattly, as well as the right to create and use derivative works from those materials, in any and all media or distribution methods (now known or later developed). This licence is for the limited purpose of operating, developing, providing, promoting, and improving the "
                    "Services and researching and developing new ones. This means, among other things, that you will not be entitled to any compensation from Eattly, our affiliates, or our business partners if content you add to Eattly is conveyed through or in connection with Eattly, either on the Eattly application or on one of our business partner’s platforms.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "While we're not required to do so, we may access, review, screen, and delete any any content you provide at any time and for any reason."
                    "However, you alone remain responsible for your use of the content that you create through our Services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We always love to hear from our users. But if you provide feedback or suggestions,"
                    "just know that we can use them without compensating you, and without any restriction or obligation to you.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "NOTE: Eattly is created to share your passion for cooking with other people so the content you share in the app should be related to cooking and eating. If we find that the content you share is not related to food and cooking,"
                    "we can remove the content. If you don't follow these rules too many times we can delete your account. Please follow these rules so that all users can easily share their passion for cooking with others.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("The content of others", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Much of the content on our Services is produced by users, publishers, and other third parties. The content is the sole responsibility of the person or organisation that submitted it. Although Eattly reserves the right to review all content that appears on the Services and to remove any"
                    "content that violates these Terms or the law, we do not necessarily review all of it."
                    "Through these Terms, we make clear that we don't want the Services to be put to bad uses. But because we don't review all content, we cannot guarantee that content on the Services, or that our users’ use of our Services, will always conform to our Terms.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Privacy", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Your privacy matters to us. You can learn how your information is handled when you use our Services by reading the Privacy Policy.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Respecting others' rights", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly respects the rights of others. And so should you. You therefore may not use the Services, or enable anyone else to use the Services, in a manner that:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   violates or infringes someone else’s rights of publicity, privacy, copyright, trademark, or other intellectual-property right;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   bullies, harasses, or intimidates;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   defames;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   spams or solicits our users.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You must also respect Eattly  guidelines published by Snap Inc. You may not do any of the following (or enable anyone else to do so).",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   use branding, logos, icons, user interface, designs, photographs, videos, or any other materials used in our Services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   violate or infringe Eattly copyrights, trademarks, or other intellectual property rights.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   copy, archive, download, upload, distribute, syndicate, broadcast, perform, display, make available, or otherwise use any portion of the Services or the content on the Services except as set forth in these Terms.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   use the Services, any tools provided by the Services, or any content on the Services for any commercial purposes without our consent.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "In short: You may not use the Services or the content on the Services in ways that are not authorised by these Terms. Nor may you help anyone else in doing so.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Respecting copyright", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly honors copyright laws, including the Digital Millennium Copyright Act. We therefore take reasonable steps to expeditiously remove from our Services any infringing material that we become aware of."
                    " And if Eattly becomes aware that one of its users has repeatedly infringed copyrights, we will take reasonable steps within our power to terminate the user’s account.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We make it easy for you to report suspected copyright infringement. If you believe that anything on the Services infringes a copyright that you own or control, please report it via email: eattly.app@gmail.com",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "E-mail must: ",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   contain the physical or electronic signature of a person authorised to act on behalf of the copyright owner;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   identify the copyrighted work claimed to have been infringed;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   identify the material that is claimed to be infringing or to be the subject of infringing activity and that is to be removed, or access to which is to be disabled, and information reasonably sufficient to let us locate the material;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   provide your contact information, including your address, telephone number, and an email address;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   provide a personal statement that you have a good-faith belief that the use of the material in the manner complained of is not authorised by the copyright owner, its agent, or the law;",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   provide a statement that the information in the notification is accurate and, under penalty of perjury, that you are authorised to act on behalf of the copyright owner.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Safety", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We try hard to keep our Services a safe place for all users. But we can’t guarantee it. That’s where you come in. By using the Services, you agree that:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not use the Services for any purpose that is illegal or prohibited in these Terms.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not use any robot, spider, crawler, scraper, or other automated means or interface to access the Services or extract other users’ information.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not use or develop any third-party applications that interact with the Services or other users’ content or information without our written consent.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not use the Services in a way that could interfere with, disrupt, affect negatively, or inhibit other users from fully enjoying the Services, or that could damage, disable, overburden, or impair the functioning of the Services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not use or attempt to use another user’s account, username, or password without their permission.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not solicit login credentials from another user.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not post content that contains pornography, graphic violence, threats, hate speech, or incitements to violence.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not upload viruses or other malicious code or otherwise compromise the security of the Services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not attempt to circumvent any content-filtering techniques we employ, or attempt to access areas or features of the Services that you are not authorised to access.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not probe, scan, or test the vulnerability of our Services or any system or network.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not encourage or promote any activity that violates these Terms.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We also care about your safety while using our Services. So do not use our Services in a way that would distract you from obeying traffic or safety laws. For example, never put yourself or others in harm’s way just to capture a photo of the recipe.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Your account", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You are responsible for any activity that occurs in your Eattly account. So it’s important that you keep your account secure. One way to do that is to select a strong password that you don’t use for any other account.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "By using the Services, you agree that, in addition to exercising common sense:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not create more than 1 account for yourself.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not create another account if we have already disabled your account, unless you have our written permission to do so.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not buy, sell, rent or lease access to your Eattly account, recipes, username without our written permission.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not share your password.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You will not log in or attempt to access the Services through unauthorised third-party applications or clients.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   If you think that someone has gained access to your account, please reach out immediately via e-mail: eattly.app@gmail.com  ",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Data charges and mobile phones", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You are responsible for any mobile charges that you may incur for using our Services, including text-messaging and data charges. If you’re unsure what those charges may be, you should ask your service provider before using the Services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Third-party services", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "If you use a service, feature or functionality that is operated by a third party and made available through our Services (including Services we offer jointly with the third party),"
                    "each party’s terms will govern the respective party’s relationship with you. Neither Eattly  is responsible or liable for a third party’s terms or actions taken under the third party’s terms.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Modifying the Services and termination", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We’re relentlessly improving our Services and creating new ones all the time. This means that we may add or remove features, products, or functionalities, and we may also suspend or stop the Services altogether."
                    "We may take any of these actions at any time, and when we do, we will try to notify you beforehand - but this won’t always be possible.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Though we hope you remain a lifelong Eattly user, you can terminate these Terms at any time and for any reason by deleting your account.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly may also terminate these Terms with you if you fail to comply with these Terms or the law, or for any reason outside of our control. And while we’ll try to give you advance notice, we can’t guarantee it. Our right to terminate these Terms means that we may stop providing you with any Services,"
                    "or impose new or additional limits on your ability to use the Services. For example, we may deactivate your account due to prolonged inactivity, and we may reclaim your username at any time for any reason."
                    "Regardless of who terminates these Terms, both you and Eattly continue to be bound by Sections 3, 6, 9, 10 and 13-22 of the Terms.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Indemnity", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You agree, to the extent permitted by law, to indemnify, defend and hold harmless Eattly and our affiliates, directors, officers, stockholders, employees, licensors, suppliers, and agents from and against any complaints, charges, claims, damages, losses, costs, liabilities and expenses (including attorneys’ fees) due to, arising out of, or relating in any way to: (a) your access to or use of the Services; (b) your content; and (c) your breach of these Terms.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Disclaimers", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We try to keep the Services up and running and free of annoyances. But we cannot promise that we will always succeed.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "The Services are provided “as is” and “as available” and to the extent permitted by law without warranties of any kind, either express or implied, including, in particular implied warranties, conditions, or other terms relating to (i) merchantability, satisfactory quality, fitness for a particular purpose, title, quiet enjoyment, "
                    "non-infringement, or (ii) arising from a course of dealing. In addition, while Eattly attempts to provide a good user experience, we do not represent or warrant that: (a) the Services will always be secure, error-free or timely; (b) the Services will always"
                    "function without delays, disruption or imperfections; or (c) that any content or information you obtain through the Services will be timely or accurate.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "IF THE LAW OF THE COUNTRY WHERE YOU LIVE DOES NOT ALLOW THE EXCLUSIONS OF LIABILITY PROVIDED FOR IN THIS CLAUSE, THOSE EXCLUSIONS SHALL NOT APPLY.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly and its affiliates take no responsibility and assume no liability for any content that you, another user, or a third party creates, uploads, posts, sends, receives, or stores on or through our Services."
                    " You understand and agree that you may be exposed to content that might be offensive, illegal, misleading, or otherwise inappropriate, none of which Eattly, nor their affiliates will be responsible for.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Nothing in these Terms will exclude or limit any responsibility we may have to remove content if so required by the law of the country where you live.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Limitation of liability", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly and our affiliates, directors, officers,shareholders, employees, licensors, suppliers, and agents will not be liable for any indirect, incidental, special, consequential, punitive, or multiple damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill or other "
                    "intangible losses, resulting from: (a) your use of the Services or inability to use the Services; (b) your access to or inability to access the Services; (c) the conduct or content of other users or third parties on or through the Services; or (d) unauthorised "
                    "access, use or alteration of your content. In no event will Eattly. or their affiliates’ aggregate liability for all claims relating to the Services exceed the greater of €100 EUR or the amount you paid Eattly in the last 12 months for any paid Services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Nothing in these Terms (or for the avoidance of doubt any other terms to which you are subject in respect of the provision of Services by Eattly, or their affiliates) shall exclude or limit Eattly, or its affiliates’ liability for: a) death or personal injury arising from their own respective intent or negligence; b) fraud or fraudulent misrepresentation; or c) any other liability to the extent that such liability may not be excluded or limited as a matter of law.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "IF THE LAW OF THE COUNTRY WHERE YOU LIVE DOES NOT ALLOW ANY LIMITATION OF LIABILITY PROVIDED FOR IN THIS CLAUSE, THAT LIMITATION WILL NOT APPLY.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "If you have a concern, let’s talk. Go ahead and contact us first and we’ll do our best to resolve the issue.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Exclusive venue", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "To the extent the parties are permitted under these Terms to initiate litigation in a court, both you and Eattly agree that all claims and disputes (whether contractual or otherwise) arising out of or relating to the Terms or the use of the Services will be "
                    "litigated exclusively in the courts of Poland in the Poland, unless this is prohibited by the laws of the country where you reside. You and Eattly consent to the exclusive jurisdiction of those courts..",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Severability", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "If any provision of these Terms is found unenforceable, then that provision will be severed from these Terms and not affect the validity and enforceability of any remaining provisions.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Additional terms for specific Services", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Given the breadth of our Services, we sometimes need to craft additional terms and conditions for specific Services. Those additional terms and conditions, which will be presented to you before you access the relevant Services, then become part of your agreement with us when you accept them. If any part of those additional terms and conditions conflicts with these Terms, the additional terms and conditions will prevail.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Final terms", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   These Terms make up the entire agreement between you and Eattly and supersede any prior agreements.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   These Terms do not create or confer any third-party beneficiary rights.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   If we do not enforce a provision in these Terms, it will not be considered a waiver.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   We reserve all rights not expressly granted to you.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   You may not transfer any of your rights or obligations under these Terms without our consent.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Contact us", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly  welcomes comments, questions, concerns, or suggestions. You can contact us or get support via e-mail: eattly.app@gmail.com",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ]
      ),
    );
  }
}