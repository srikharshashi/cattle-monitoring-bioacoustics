import 'package:cattleplus/UI/add_cattle.dart';
import 'package:cattleplus/logic/auth_cubit/auth_cubit.dart';
import 'package:cattleplus/logic/home_cubit/home_cubit.dart';
import 'package:cattleplus/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Home extends StatelessWidget {
  Home({super.key});
  String email = "dasojusrikhar@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddCattle(email: email)));
        },
        child: Icon(FontAwesomeIcons.add),
      ),
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocConsumer<AuthCubit, AuthState>(builder: (context, state) {
          if (state is Authenticated) {
            return BlocBuilder<HomeCubit, HomeState>(
              builder: (context, homestate) {
                if (homestate is HomeLoad) {
                  return SpinKitRotatingCircle(
                    color: Colors.black,
                    size: 50.0,
                  );
                } else if (homestate is HomeLoaded) {
                  return LiquidPullToRefresh(
                    onRefresh: context.read<HomeCubit>().refresh_home,
                    child: ListView.builder(
                        itemCount: homestate.cattle_list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: (){},
                              leading: get_icon(
                                  homestate.cattle_list[index]["type"],
                                  homestate.cattle_list[index]["lastState"]),
                              title: Center(
                                  child: Text(
                                      homestate.cattle_list[index]["name"])),
                              trailing: get_icon2(
                                  homestate.cattle_list[index]["lastState"]));
                        }),
                  );
                } else {
                  return Container(
                    child: Text("auth -- othr state"),
                  );
                }
              },
            );
          } else {
            return Container(
              child: Text("Weird State"),
            );
          }
        }, listener: (context, state) {
          if (state is Authenticated) {
            email = state.email;
          }
        }),
      ),
    );
  }

  Icon get_icon(String type, String state) {
    dynamic color = Colors.black;
    if (state == "natural" || state == "LFC" || state == "healthy")
      color = Colors.green[700];
    else if (state == "unknown")
      color = Colors.grey;
    else if (state == 'unnatural' || state == 'distress')
      color = Colors.orange[700];
    else
      color = Colors.red[700];
    if (type == "cow")
      return Icon(FontAwesomeIcons.cow, color: color);
    else
      return Icon(FontAwesomeIcons.kiwiBird, color: color);
  }

  Icon get_icon2(String state) {
    dynamic color = Colors.black;
    if (state == "natural" || state == "LFC" || state == "healthy")
      return Icon(
        FontAwesomeIcons.smile,
        color: Colors.green[800],
      );
    else if (state == "unknown") {
      return Icon(
        Icons.signal_cellular_0_bar,
        color: Colors.grey,
      );
    } else if (state == 'unnatural' || state == 'distress')
      return Icon(
        Icons.add_alert,
        color: Colors.orange[800],
      );
    else
      return Icon(
        Icons.warning,
        color: Colors.red[800],
      );
  }
}
