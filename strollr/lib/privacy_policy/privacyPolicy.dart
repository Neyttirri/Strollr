import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strollr/style.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Datenschutzerklärung", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: headerGreen),
          onPressed: () {
            Navigator.of(context).pop();
            //Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Text("Privacy Policy", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 20,
              ),
              Text("Introduction", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("Our privacy policy will help you understand what information we collect at Strollr, how Strollr uses it, and what choices you have. Strollr built the Strollr app as a free app. This SERVICE is provided by Strollr at no cost and is intended for use as is. If you choose to use our Service, then you agree to the collection and use of information in relation with this policy. The Personal Information that we collect are used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible in our website, unless otherwise defined in this Privacy Policy."),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Information Collection and Use", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("For a better experience while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to users name, location, pictures. The information that we request will be retained by us and used as described in this privacy policy."),
              ),
              SizedBox(
                height: 4,
              ),
              Text("The app does use third party services that may collect information used to identify you."),
              SizedBox(
                height: 15,
              ),
              Text("Cookies", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("Cookies are files with small amount of data that is commonly used an anonymous unique identifier. These are sent to your browser from the website that you visit and are stored on your devices’s internal memory."),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("This Services does not uses these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collection information and to improve their services. You have the option to either accept or refuse these cookies, and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service."),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Location Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("Some of the services may use location information transmitted from users' mobile phones. We only use this information within the scope necessary for the designated service."),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Device Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("We collect information from your device in some cases. The information will be utilized for the provision of better service and to prevent fraudulent acts. Additionally, such information will not include that which will identify the individual user."),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Service Providers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text("We may employ third-party companies and individuals due to the following reasons:"),
              SizedBox(
                height: 8,
              ),
              Text("To facilitate our Service."),
              SizedBox(
                height: 8,
              ),
              Text("To provide the Service on our behalf."),
              SizedBox(
                height: 8,
              ),
              Text("To perform Service-related services or"),
              SizedBox(
                height: 8,
              ),
              Text("To assist us in analyzing how our Service is used."),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose."),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Security", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security."),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Children’s Privacy", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("This Services do not address anyone under the age of 13. We do not knowingly collect personal identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions."),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Changes to This Privacy Policy", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text("We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately, after they are posted on this page."),
              ),
              SizedBox(
                height: 4,
              ),
              Text("This policy is effective as of 2021-07-16."),
              SizedBox(
                height: 15,
              ),
              Text("Contact Us", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text("If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us."),
              SizedBox(
                height: 10,
              ),
              Text("Contact Information:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text("Email: coalacodes@protonmail.com"),
              SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }


  /*





   */
}