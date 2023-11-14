import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:digimartbox/src/components/components.dart';
import 'package:digimartbox/src/components/under_part.dart';
import 'package:digimartbox/src/widgets/widgets.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  imgUrl: "assets/img/login.png",
                ),
                const PageTitleBar(title: 'Acceda a su cuenta'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        iconButton(context),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "o utilice su cuenta de correo electrónico",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Form(
                          child: Column(
                            children: [
                              RoundedInputField(
                                  hintText: "Email",
                                  icon: Icons.email,
                                  controller: controller.emailController,
                                ),
                              RoundedPasswordField(controller: controller.passwordController,),
                              RoundedButton(
                                  text: 'INICIAR SESIÓN', press: () => controller.login()),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "¿No tiene cuenta?",
                                navigatorText: "Regístrese aquí",
                                onTap: () => controller.goToRegisterPage(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  iconButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedIcon(
          imageUrl: "assets/img/google.png",
          onTap: () => controller.signInWithGoogle(),
        ),
      ],
    );
  }
}
