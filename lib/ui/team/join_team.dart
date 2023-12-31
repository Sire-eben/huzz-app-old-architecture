import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/widgets/app_bar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/button/outlined_button.dart';
import 'package:huzz/data/model/user_id_model.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/ui/app_scaffold.dart';
import 'package:huzz/ui/team/team_success.dart';
import 'package:huzz/ui/widget/loading_widget.dart';

class JoinBusinessTeam extends StatefulWidget {
  final String teamId, businessId;
  final String businessName;

  const JoinBusinessTeam(
      {super.key,
      required this.teamId,
      required this.businessId,
      required this.businessName});

  @override
  State<JoinBusinessTeam> createState() => _JoinBusinessTeamState();
}

class _JoinBusinessTeamState extends State<JoinBusinessTeam> {
  final teamController = Get.find<TeamRepository>();
  final businessController = Get.find<BusinessRespository>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/team 1.png',
                  width: context.getWidth(.7),
                ),
                const Gap(Insets.lg),
                Center(
                  child: Text(
                    "Accept Invitation To\nJoin ${widget.businessName} on Huzz",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                ),
                const Gap(Insets.xl),
                FutureBuilder<UserIdModel>(
                  future: teamController.fetchUserId(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Button(
                            label: "Yes",
                            action: () async {
                              setState(() => isLoading = true);
                              await teamController
                                  .joinTeamWithInviteLink(
                                context: context,
                                teamId: widget.teamId,
                                businessId: widget.businessId,
                                userId: snapshot.data!.id,
                              )
                                  .whenComplete(() {
                                if (teamController.joinTeamStatus ==
                                    JoinTeamStatus.Success) {
                                  setState(() => isLoading = false);
                                  context.replace(TeamSuccessView(
                                    businessName: widget.businessName,
                                  ));
                                } else if (teamController.joinTeamStatus ==
                                    JoinTeamStatus.Error) {
                                  setState(() => isLoading = false);
                                } else {
                                  return;
                                }
                              });
                            },
                          ),
                          const Gap(Insets.lg),
                          AppOutlineButton(
                            action: () => context.pushOff(Dashboard()),
                            label: "No",
                          ),
                          const Gap(Insets.lg),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return LoadingWidget();
                  },
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: Container(
                    height: context.getHeight(.9),
                    width: context.getWidth(),
                    color: Colors.black.withOpacity(.3),
                    child: LoadingWidget(),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
