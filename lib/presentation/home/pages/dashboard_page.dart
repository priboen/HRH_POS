import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrh_pos/core/core.dart';
import 'package:hrh_pos/core/extensions/extensions.dart';
import 'package:hrh_pos/presentation/auth/bloc/logout_bloc/logout_bloc.dart';
import 'package:hrh_pos/presentation/auth/pages/login_page.dart';
import 'package:hrh_pos/presentation/home/pages/discount_page.dart';
import 'package:hrh_pos/presentation/home/pages/home_page.dart';
import 'package:hrh_pos/presentation/widgets/nav_item.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const DiscountPage(),
    // const ReportPage(),
    const Center(child: Text('This is page 3')),
    const Center(child: Text('This is page 4')),
    // const SettingsPage(),
    // const ManagePrinterPage(),
    // const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(
                  MediaQuery.of(context).size.width * 0.010,
                ),
              ),
              child: SizedBox(
                height: context.deviceHeight -
                    MediaQuery.of(context).size.height * 0.00,
                child: ColoredBox(
                  color: AppColors.primary,
                  child: Column(
                    children: [
                      NavItem(
                        iconPath: Assets.icons.homeResto.path,
                        isActive: _selectedIndex == 0,
                        onTap: () => _onItemTapped(0),
                      ),
                      NavItem(
                        iconPath: Assets.icons.discount.path,
                        isActive: _selectedIndex == 1,
                        onTap: () => _onItemTapped(1),
                      ),
                      NavItem(
                        iconPath: Assets.icons.dashboard.path,
                        isActive: _selectedIndex == 2,
                        onTap: () => _onItemTapped(2),
                      ),
                      NavItem(
                        iconPath: Assets.icons.setting.path,
                        isActive: _selectedIndex == 3,
                        onTap: () => _onItemTapped(3),
                      ),
                      BlocConsumer<LogoutBloc, LogoutState>(
                        listener: (context, state) {
                          state.maybeMap(
                            orElse: () {},
                            success: (_) {
                              context.pushReplacement(const LoginPage());
                            },
                            error: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(value.message),
                                  backgroundColor: AppColors.red,
                                ),
                              );
                            },
                          );
                        },
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () {
                              return NavItem(
                                iconPath: Assets.icons.logout.path,
                                isActive: false,
                                onTap: () {
                                  context
                                      .read<LogoutBloc>()
                                      .add(const LogoutEvent.logout());
                                },
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
