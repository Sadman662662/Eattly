import "package:flutter/material.dart";

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B5E20),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: () {Navigator.pop(context);
        }
        ),
        title: Text("Terms & Conditions", style: TextStyle(fontSize: 24.0, color: Colors.white , fontWeight: FontWeight.bold),),
      ),
      body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We’ve drafted these Terms of Service (which we call the “Terms”) so you’ll know the rules that govern our relationship with you. There’s a good reason for that: these Terms do indeed form a legally binding contract between you and Eattly. So please read them carefully."
                    "In order to use Eattly(we refer to these collectively as the “Services”), you must have accepted our Terms and Privacy Policy, which are presented to you (i) when you first open the app and (ii) when we make any material changes to the Terms or the Privacy Policy. Of course, if you don’t accept them, then don’t use the Services.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Who can use the Services", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "No one under 13 is allowed to create an account or use the Services. We may offer additional Services with additional terms that may require you to be even older to use them. So please read all terms carefully."
                    "By using the Services, you state that:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   you can form a binding contract with Eattly.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "     -   you will comply with these Terms and all applicable local, state, national, and international laws, rules, and regulations.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Rights we grant you", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Eattly grants you a personal, worldwide, royalty-free, non-assignable, non-exclusive, revocable, and non-sublicensable licence to access and use the Services."
                    " This licence is for the sole purpose of letting you use and enjoy the Services’ benefits in a way that these Terms and our usage policies.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Any software that we provide you may automatically download and install upgrades, updates, or other new features."
                    "You may be able to adjust these automatic downloads through your device’s settings.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "You may not copy, modify, distribute, sell, or lease any part of our Services."
                    "Nor may you reverse engineer or attempt to extract the source code of that software, unless laws prohibit these restrictions or you have our written permission to do so.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Align(
              child: Container(
                child: Padding(padding: EdgeInsets.all(20.0),
                  child: Text("Rights you grant us", style: TextStyle(fontSize: 25.0, color: Color(0xFF1B5E20)),),
                ),
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