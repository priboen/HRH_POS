import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/build_context_ext.dart';
import 'package:hrh_pos/data/datasources/auth/locals/auth_local_datasources.dart';
import 'package:hrh_pos/presentation/auth/bloc/login_bloc/login_bloc.dart';
import 'package:hrh_pos/presentation/home/pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool isShowPassword = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: MediaQuery.of(context).size.width * 0.02),
        children: [
          SpaceHeight(MediaQuery.of(context).size.height * 0.1),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2),
            child: SvgPicture.asset(
              Assets.icons.homeResto.path,
              width: 100,
              height: 100,
              color: AppColors.primary,
            ),
          ),
          SpaceHeight(MediaQuery.of(context).size.height * 0.06),
          Center(
            child: Text(
              'HRH Point of Sale',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.width * 0.016,
                  color: AppColors.black),
            ),
          ),
          SpaceHeight(MediaQuery.of(context).size.height * 0.02),
          Center(
            child: Text(
              'Akses Login Kasir',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.012,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          SpaceHeight(MediaQuery.of(context).size.height * 0.02),
          CustomTextField(
            controller: emailController,
            label: 'Email',
            showLabel: false,
            prefixIcon: Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.02,
              ),
              child: SvgPicture.asset(
                Assets.icons.email.path,
                color: AppColors.primary,
              ),
            ),
          ),
          SpaceHeight(MediaQuery.of(context).size.height * 0.02),
          CustomTextField(
            controller: passwordController,
            label: 'Password',
            showLabel: false,
            obscureText: !isShowPassword,
            prefixIcon: Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.02,
              ),
              child: SvgPicture.asset(
                Assets.icons.password.path,
                color: AppColors.primary,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isShowPassword = !isShowPassword;
                });
              },
              icon: Icon(
                isShowPassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.primary,
              ),
            ),
          ),
          SpaceHeight(MediaQuery.of(context).size.height * 0.08),
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: (data) {
                  AuthLocalDatasources().saveAuthData(data);
                  print(data);
                  context.pushReplacement(const DashboardPage());
                },
                error: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: AppColors.red,
                    ),
                  );
                },
              );
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return Button.filled(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                              LoginEvent.login(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      },
                      label: 'Masuk',
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
