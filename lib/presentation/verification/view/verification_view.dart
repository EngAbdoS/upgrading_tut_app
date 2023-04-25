import 'package:easy_localization/easy_localization.dart';
import 'package:flu_proj/presentation/common/state_renderer/state_renderer_imp.dart';
import 'package:flu_proj/presentation/forgot_password/viewModel/forgotPasswordViewModel.dart';
import 'package:flu_proj/presentation/resourses/router_manager.dart';
import 'package:flu_proj/presentation/verification/viewModel/verification_viewModel.dart';
import 'package:flutter/material.dart';

import '../../../app/di.dart';
import '../../resourses/assets_manager.dart';
import '../../resourses/color_manager.dart';
import '../../resourses/strings_manager.dart';
import '../../resourses/values_manager.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({Key? key}) : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final VerificationViewModel _viewModel = instance<VerificationViewModel>();

  bind() {
    _viewModel.start();
    _viewModel.outputIsAllInputsValid.listen((event) {
      if (event) {
        Navigator.pushReplacementNamed(context, Routes.mainRoute);
      }
    });
  }

  @override
  void initState() {
    bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.verify();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.only(top: AppPadding.p20 * 5),
      color: ColorManager.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Image(image: AssetImage(ImageAssets.splashLogo)),

            Center(child: Padding(
              padding: const EdgeInsets.all(AppPadding.p28),
              child: Text(AppStrings.verificationMessage,style: Theme.of(context).textTheme.titleLarge,).tr(),
            )

            ),

            StreamBuilder(
              builder: (context, snapshot) {
                print(snapshot.data);
                return Text(
                  snapshot.data ?? "",
                  style: Theme.of(context).textTheme.titleMedium,
                ).tr();
              },
              stream: _viewModel.outputEmail,
            ),
            const SizedBox(
              height: AppSize.s28,
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: SizedBox(
                  width: double.infinity,
                  height: AppSize.s40,
                  child: ElevatedButton(
                      onPressed: () => _viewModel.sendVerification(),
                      child: const Text(AppStrings.sendVerification).tr()),
                ))

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
