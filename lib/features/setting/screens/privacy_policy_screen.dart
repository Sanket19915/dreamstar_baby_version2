import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: TextStyle(
              color: AppColors.mainColor, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'PRIVACY POLICY',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'PLEASE READ OUR PRIVACY POLICY CAREFULLY BEFORE USING OUR APP, WEBSITE, ALL SERVICES & ALL PRODUCTS.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to DreamStar Baby GarbhaSanskar App (the ‘App’). This App is operated by Dr. Sonal Jain Jayaswal from Shivlok, J.P. Height Building, 8th Floor, B Wing, Near Gondwana Square, Bairamji Town, Nagpur - 440013, India (hereinafter referred to as the Proprietary Firm / Firm, which includes its officers, successors, and assigns).',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'This Privacy Policy (‘Privacy Policy’) sets out the privacy practices of the Firm with respect to the entire content of the App and Firm’s all Products. This document is published in accordance with the provisions of the Information Technology Act, 2000 and the rules made thereunder that require publishing the rules and regulations, privacy policy and terms of use on an online portal of the Firm. We request you to go through this Privacy Policy carefully before you decide to access this App and Firm’s all Products.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'For the purposes of this Privacy Policy, the words ‘us’, ‘we’, and ‘our’ refer to the Proprietor Firm and all references to ‘you’, ‘your’ or ‘user’, as applicable mean the person who accesses, uses and/or participates in the App in any manner or capacity.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'The Firm is strongly committed to protecting the privacy of its users and has taken all necessary and reasonable measures to protect the confidentiality of the user information and its transmission through the internet. The Firm will not be held liable for disclosure of any information if such disclosure is in accordance with this Privacy Policy, the Terms of Use and/or applicable law. If you object to your information being transferred or used in accordance with this Privacy Policy, please do not use the App and Firm’s all Products.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'All capitalized terms used but not defined herein shall have the meaning ascribed to in the Terms of Use.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '1. INFORMATION COLLECTION',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '1.1 The Firm is the sole owner of the information collected through the App. We will not sell, share, transfer or rent any personal information to others in ways different from what is disclosed in this statement and the Terms of Use.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '1.2 The Firm collects information from you on the Register/Log-in page of the App. In the sign-up page, you are required to give your contact information (such as name, mobile number, address and email ID etc.). A mobile verification code and Registration Number is used to confirm your identity. When the App requests your identity, the App will clearly indicate the purpose of the inquiry before the information is requested.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '1.3 Once a registered participant, you have the option of providing additional information such as information about your health conditions and other personal information to identify a suitable hospital and other Services of the Firm, which shall not be available for viewing by other registered participants of App but will be considered non-confidential and non-proprietary. Providing additional information beyond what is required at registration is entirely optional and can be altered or removed by you at any time.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '1.4 Every computer/mobile device connected to the Internet is given a domain name and a set of numbers that serve as that computer\'s Internet Protocol or ‘IP’ address. When you request a page from any page within the Firm platform, our web servers automatically recognize your domain name and IP address. The domain name and IP address reveal nothing personal about you other than the IP address from which you have accessed the App.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '2. CHILDREN\'S AND MINOR\'S PRIVACY',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The Firm strongly encourages parents and guardians to supervise the online activities of their minor children and consider using parental control tools available from online services and software manufacturers to help provide a child-friendly online environment.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'These tools also can prevent minors from disclosing their name, address, and other personally identifiable information online without parental permission. Although the App is not intended for use fully by minors, the Firm respects the privacy of minors who may inadvertently use the internet or the App.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '3. DATA RETENTION',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your information will be retained with the Firm as long as your account is active or as needed to provide Services to you. The Firm will retain and use your information as necessary to comply with its legal obligations, resolve disputes, and enforce its agreements or for other business purposes.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The Firm will continue to retain information provided by you until you specifically request the Firm to destroy such information. Upon verification of such request, the Firm may, subject to its obligations pursuant to law, destroy all information provided by you from its servers.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '4. OPT OUT PROCEDURES',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Upon initial communication from the Firm, you may opt-out of receiving further communications from the Firm. To be completely removed from the Firm mailing list, you may contact us at contact@dreamstarbaby.com. If you are using an e­mail forwarding service or other similar services please make sure to include the correct e-mail address or addresses.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '5. USE OF THE INFORMATION COLLECTED',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '5.1 Use of The Information For Services',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The primary goal of the Firm in collecting the information is to provide you the Services as defined in the Terms of Use. The Firm may use the personal information provided by you in the following ways:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '- To facilitate the Services required by you.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '- To enable the provision of Services to you in the future, to contact you, send promotional messages or other communications.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '- To analyze how the App is used, diagnose service or technical problems and maintain security.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '6. NON-DISCLOSURE OF INFORMATION',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The Firm pledges that it will not sell or rent your personal details to anyone and your personal information will be protected and maintained strictly confidential by the Firm except in the following cases:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '- The Firm may disclose your personal information in the event it is required to do so by law, rule, regulation, law, enforcement, governmental official, legal or regulatory authorities and, or, to such other statutory bodies who have appropriate authorization to access the same for any specific legal purposes.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '- The Firm may disclose your information in order to provide you the Services, enforce or apply the Terms of Use, or to protect the rights, property or safety of the Firm, its users or others. This includes exchanging information with other companies / agencies that work for fraud prevention.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '- The Firm may disclose your information to such third parties to whom it transfers its rights and duties under any agreement entered into with such third parties.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '- The Firm may disclose your information to any of its affiliates or related entity.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '7. SHARING OF INFORMATION',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '7.1 Sharing',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The Firm may share aggregated demographic information with the Firm\'s partners. This is not linked to any personal information that can identify any individual person. The Firm shall not be liable for the transfer of any personal identification information resulting from loss or distribution of data, the delineation or corruption of storage media, power failures, natural phenomena, riots, and acts of vandalism, sabotage, terrorism or any other event beyond the Firm\'s control.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '7.2 Consulting',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The Firm may partner with another party to provide specific services. When you sign up for these services, the Firm will share names, or other contact information that is necessary for the third party to provide these services. Per the Firm\'s contractual arrangements with parties, these parties are not allowed to use personally identifiable information except for the explicit purpose of providing these services.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '8. SPAM',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The Firm maintains a strict ‘No-Spam’ policy, which means that the Firm does not intend to sell, rent or otherwise give your e­mail address or phone number to a third party without your consent.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '9. EXCLUSION',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '9.1 This Privacy Policy does not apply to any information other than information collected by the Firm through the App including such information collected in accordance with the clause on ‘Use of the Information Collected’ above. This Privacy Policy will not apply to any unsolicited information provided by you through this App or through any other means. This includes, but is not limited to, information posted on any public areas of the App. All such unsolicited information shall be deemed to be non-confidential and the Firm will be free to use, disclose such unsolicited information without limitation.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '9.2 The Firm also protects your personal information offline other than as specifically mentioned in this Privacy Policy. Access to your personal information is limited to employees, agents or partners and third parties, who the Firm reasonably believes will need that information to enable the Firm to provide Services to you. However, the Firm is not responsible for the confidentiality, security or distribution of your own personal information by our partners and third parties outside the scope of our agreement with such partners and third parties.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '10. THE FIRM FORUMS',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'When you participate in App forums your comments, your name, your mobile number and IP address may be recorded for purposes of maintaining your own account within the forums, and preventing abuses of the forums. This information is not used to personally identify you outside the Firm community. In order to diffuse the information in the Firm forum to a wider audience, the Firm may, from time to time, collect some of your postings and group them together to use in a specific publication, print, electronic mailing or other public dissemination. At no point however will your name, your mobile number or IP address be revealed in any publication. In addition, when your postings are used in this fashion, they may be edited to fit with the general content of the publication being prepared. It is important to remember that whenever you voluntarily disclose personal information in a forum, through e-mail or elsewhere, that information can be collected and used by others. If your personal information is accessible to the public, you may receive unsolicited messages from other parties in return. Ultimately, you are solely responsible for maintaining the secrecy of your personal information. You may participate in any forum offered through App, but you agree not to post any material the content of which (i) is defamatory, libelous, obscene, indecent, abusive, threatening to others, or in violation of any law; or (ii) infringes the copyright, trademark right, or other intellectual property rights of any third party. You will be solely responsible for all content that you post on the App. You agree to indemnify the Firm and its officers and employees from and against all liabilities, judgments, damages, and costs (including attorney\'s fees) incurred by any of them which arise out of or are related to the content that you post. The App is intended only for the personal use of the Firm subscribers, and may not be used for commercial purposes or for organized political activity.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '11. PROTECTION OF INFORMATION',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '(a) The Firm takes the security of your information very seriously. The Firm protects your information from loss, misuse and unauthorized access, disclosure, alteration and destruction by using systems and processes consistent with industry standards in information and privacy. The Firm has put in place appropriate methods and managerial procedures to safeguard and secure such information. It only processes personal information in a way that is compatible with and relevant for the purpose for which it was collected or authorized by the individual. The App allows users access to their personal information and allows them to correct, amend or delete inaccurate information.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '(b) The Firm uses commercially reasonable precautions to preserve the integrity and security of your information against loss, theft, unauthorized access, disclosure, reproduction, use or amendment.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '(c) The information that is collected from you may be transferred to, stored and processed at any destination within and / or outside India. By submitting information on the App, you agree to this transfer, storing and / or processing. The Firm will take such steps as it considers reasonably necessary to ensure that your information is treated securely and in accordance with this Privacy Policy.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '(d) In using the App, you accept the inherent security implications of data transmission over the internet. Therefore, the use of the App will be at your own risk and the Firm assumes no liability for any disclosure of information due to errors in transmission, unauthorized third-party access or other acts of third parties, or acts or omissions beyond its reasonable control and you agree not to hold the Firm responsible for any breach of security.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '(e) In the event the Firm becomes aware of any breach of the security of your information, it will promptly notify you and take appropriate action to the best of its ability to remedy such a breach.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '12. CONFIDENTIALITY',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The Firm takes all necessary precautions to protect your personal information both online and offline. No administrator at the Firm will have knowledge of your password. It is important for you to protect against unauthorized access to your password and your computer. Be sure to log off from App when finished. The Firm also protects your personal information offline. Access to your personal information is limited to employees, agents or partners and third parties, who the Firm reasonably believes will need that information to provide Services to you.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'However, the Firm is not responsible for the confidentiality, security or distribution of your own personal information by our partners and third parties outside the scope of our agreement with such partners and third parties.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '13. OTHER LINKS',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The App may contain links to other sites. The linked sites are not necessarily under the control of the Firm. Please be aware that the Firm is not responsible for the privacy practices of such other sites. The Firm encourages you to read the privacy policies of each and every website that collects personally identifiable information.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'If you decide to access any of the third-party sites linked to the App, you do this entirely at your own risk. Any links to any partner of the App should be the responsibility of the linking party, and the Firm shall not be responsible for notification of any change in name or location of any information on the App.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '14. COMPLAINTS AND LEGAL ISSUES',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'In case of any complaints about this privacy policy, you should first contact us at our official address.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This contract is subject to the Indian Information Technology Act, 2000. This policy and your use of the App, website etc., along with the Information contained therein, shall be governed by and construed in accordance with the laws of the State of Maharashtra, India without regard to conflict of laws principles, and You agree to submit to the jurisdiction of courts in the Nagpur, State of Maharashtra, India. You further agree that any claims or causes of action arising out of or related to this Agreement and the App, website etc., along with the Information contained therein, shall be filed within one (1) month after such claim or cause of action arose, or such claim or cause of action shall be forever barred.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '15. REFUND POLICY',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Our all services – Products, App Services, Personal Counseling Fees and Event Fees etc. all are non-refundable. Buy the plan carefully by reading our all policy details. We cannot provide a refund.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'In some very rare cases, if we allow refunds, then, if payment is paid by credit card, refunds will be issued to the original credit card provided at the time of purchase and in the case of payment gateway; payment refund will be made to the same account.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '16. CANCELLATION POLICY',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Our all services - books, materials and courses etc. all as prescribed above are not canceled or transferred to other after once the payment done.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '17. RETURN/REPLACEMENT POLICY',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'If an item ordered by the Buyer from DreamStar Baby GarbhaSanskar App or other platforms opts for a replacement. Our Customer Service team will confirm the replacement by using the real proof given by you. The buyer will be required to hand over the defective items to the logistic partner in the same condition as were received by her. If we find our material ‘ok’ then only we replace it as your requirement.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '18. NOTIFICATION OF CHANGES',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We may update this Privacy Policy at anytime, with or without advance notice. In the event there are significant changes in the way we treat your personally identifiable information, or in the Privacy Policy document itself, we will display a notice on the App and on the Firm App or send you an email, so that you may review the changed terms prior to Continuing to use the App.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'As always, if you object to any of the changes to our terms, and you no longer wish to use the App, you may contact@dreamstarbaby.com to deactivate your account. Unless stated otherwise, our current Privacy Policy applies to all information that the Firm has about you and your account. Using the Firm Services or accessing the App after a notice of changes has been sent to you or published on our App shall constitute your consent to the changed terms. It is your duty to see our policy regularly.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '19. CONTACT INFORMATION',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'If you have any questions about this Privacy Policy, or the privacy practices of the Firm, or you wish to amend the personal information the Firm holds about you or wish to change your marketing preferences, please contact the Firm by email at info@dreamstarbaby.com.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'By entering into this Agreement, you agree to comply with the latest privacy policy. To avoid ambiguity, it is expressly stated that this Policy and any rights or obligations under it may be transferred by the Firm to any affiliate.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '20. ADDRESS FOR PRIVACY QUESTIONS',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Should you have questions about this policy or the Firm\'s information collection, use and disclosure practices, you may contact us at:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Mobile No. : 7030962300',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Email ID : contact@dreamstarbaby.com',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Address:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Shivlok, J.P. Height Building,',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text(
              '8th Floor, B Wing, Near Gondwana Square,',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text(
              'Bairamji Town, Nagpur - 440013, India.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Website: www.dreamstarbay.com',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: contact@dreamstarbaby.com',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Contact us: 7030962300',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '(Between 10 am to 6 pm, Sunday and public holidays closed.)',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'We will use reasonable efforts to respond promptly to requests, questions or concerns you may have regarding our use of personal information about you. Except where required by law, the Firm cannot ensure a response to questions or comments regarding topics unrelated to this policy or the Firm\'s privacy practices.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
