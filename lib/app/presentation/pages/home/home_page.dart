import 'package:flutter/material.dart';
import 'package:test_maps/app/presentation/pages/map/map_view.dart';

import 'package:test_maps/app/shared/custom_bottom_navigator_bar.dart';

import '../../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControler homeControler = HomeControler();
    return Scaffold(
      body: ValueListenableBuilder<HomeState>(
        valueListenable: homeControler,
        builder: (context, state, child) {
          if (state is HomeGroupsState) {
            child = const Center(child: Text('Home Page'));
          } else {
            child = const GoogleMapView();
          }
          return child;
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        homeControler: homeControler,
      ),
    );
  }
}
