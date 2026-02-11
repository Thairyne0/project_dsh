import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../ui/cl_theme.dart';
import '../../../ui/widgets/loading.widget.dart';
import '../../../utils/base.viewmodel.dart';
import '../viewmodels/welcome.viewmodel.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WelcomeViewModel>.reactive(
        viewModelBuilder: () => WelcomeViewModel(context, VMType.list, null),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: []),
        builder: (context, vm, child) {
          return Scaffold(
              backgroundColor: CLTheme.of(context).primaryBackground,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo_light.png'),
                    const SizedBox(
                      height: 100,
                    ),
                    const LoadingWidget()
                  ],
                ),
              ));
        });
  }
}
