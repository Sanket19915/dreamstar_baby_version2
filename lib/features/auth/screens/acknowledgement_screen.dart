import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../router/routes.dart';

class AcknowledgementScreen extends StatefulWidget {
  const AcknowledgementScreen({super.key});

  @override
  State<AcknowledgementScreen> createState() => _AcknowledgementScreenState();
}

class _AcknowledgementScreenState extends State<AcknowledgementScreen> {
  double visible = 0;

  @override
  void initState() {
    super.initState();
    // Start the animation after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        visible = 1.0; // Change opacity to fully visible
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.asset(
                'assets/images/acknowledge.gif',
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.18),
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xff21F3F6),
                  radius: 30,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF139294),
                    child: Icon(
                      Icons.check_rounded,
                      color: Color(0xff21F3F6),
                      size: 45,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "ACKNOWLEDGEMENT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.pink781a7a,
                      fontWeight: FontWeight.w900,
                      // fontFamily: "Aristotelica"
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
                  child: AnimatedOpacity(
                    opacity: visible,
                    duration: const Duration(seconds: 1),
                    child: const Text(
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.pink781a7a,
                          // fontFamily: "Aristotelica",
                        ),
                        textAlign: TextAlign.center,
                        """I am a SuperMom, dedicated to supporting my baby's holistic development, by engaging with the daily brain-stimulating activities provided in the App. While I commit to consistent practice, I understand that I should consult my gynaecologist before starting anything I am unsure of.\n\n By using this App, I acknowledge that results may vary, and I will always prioritize my health and my baby's wellbeing. 
                            \nI understand this App serves as a supplementary tool and does not replace professional medical advice, prenatal care or regular check-ups with my gynaecologist.\n\nI am ready and committed to manifest and work for my DreamStar Baby"""),
                  ),
                ),
                const SizedBox(height: 30),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      context.go(Routes.home);
                    },
                    child: Container(
                      height: 35,
                      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(begin: Alignment.bottomRight, end: Alignment.topLeft, colors: [
                            Color(0XFFB396F1),
                            Color(0XFFB2BEF2),
                            Color(0XFFACD4F2),
                            Color(0XFFA6DEF2),
                          ])),
                      child: const Text(
                        "SUBMIT",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1,
                            fontSize: 24,
                            color: AppColors.pink781a7a,
                            fontWeight: FontWeight.w900,
                            fontFamily: "Aristotelica"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
