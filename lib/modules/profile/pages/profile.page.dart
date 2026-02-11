import 'package:project_dsh/modules/profile/constants/users_routes.constants.dart';
import 'package:project_dsh/ui/cl_theme.dart';
import 'package:project_dsh/ui/widgets/cl_container.widget.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../utils/base.viewmodel.dart';
import '../../../../utils/models/pageaction.model.dart';
import '../../../../utils/providers/appstate.util.provider.dart';
import '../../../ui/widgets/avatar.widget.dart';
import '../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../ui/widgets/loading.widget.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../../auth/constants/auth_routes.constants.dart';
import '../viewmodels/profile.viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context, VMType.edit, null),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Modifica",
                  isMain: true,
                  iconData: Icons.edit,
                  onTap: () async {
                    context.customGoNamed(ProfileRoutes.editUserProfile.name, params: {"id": authState.currentUser!.id});
                  }),
            ]),
        builder: (context, vm, child) {
          if (appState.shouldRefresh) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await vm.initialize();
              appState.reset();
            });
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ResponsiveGrid(
              gridSpacing: Sizes.padding,
              children: [
                ResponsiveGridItem(
                  lg: 30,
                  xs: 100,
                  child: CLContainer(
                      height: 600,
                      title: 'Anagrafica',
                      child: ResponsiveGrid(gridSpacing: Sizes.padding, children: [
                        ResponsiveGridItem(
                          lg: 100,
                          xs: 100,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: Sizes.padding * 2),
                            child: Center(
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CLTheme.of(context).primary,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: (authState.getCurrentUser?.userData.imageUrl?.trim().isNotEmpty ?? false)
                                    ? Image.network(
                                  authState.getCurrentUser!.userData.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, obj, e) => Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "${authState.getCurrentUser?.userData.firstName?[0] ?? ''}"
                                            "${authState.getCurrentUser?.userData.lastName?[0] ?? ''}",
                                        style: CLTheme.of(context).heading1,
                                      ),
                                    ),
                                  ),
                                )
                                    : Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "${authState.getCurrentUser?.userData.firstName?[0] ?? ''}"
                                          "${authState.getCurrentUser?.userData.lastName?[0] ?? ''}",
                                      style: CLTheme.of(context).heading1,
                                    ),
                                  ),
                                ),

                              ),
                            ),
                          ),
                        ),
                        ResponsiveGridItem(
                          lg: 50,
                          xs: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Nome', style: CLTheme.of(context).bodyLabel),
                              Text(authState.currentUser?.userData.firstName ?? "", style: CLTheme.of(context).bodyText)
                            ]),
                          ),
                        ),
                        ResponsiveGridItem(
                          lg: 50,
                          xs: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Cognome', style: CLTheme.of(context).bodyLabel),
                              Text(authState.currentUser?.userData.lastName ?? "", style: CLTheme.of(context).bodyText)
                            ]),
                          ),
                        ),
                        ResponsiveGridItem(
                          lg: 100,
                          xs: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Email', style: CLTheme.of(context).bodyLabel),
                              Text(authState.currentUser?.email ?? "", style: CLTheme.of(context).bodyText)
                            ]),
                          ),
                        ),
                        ResponsiveGridItem(
                          lg: 100,
                          xs: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Numero di cellulare', style: CLTheme.of(context).bodyLabel),
                              Text("${authState.currentUser?.phone}", style: CLTheme.of(context).bodyText)
                            ]),
                          ),
                        ),
                      ])),
                ),
                ResponsiveGridItem(
                  lg: 70,
                  xs: 100,
                  child: CLContainer(
                      title: 'Impostazioni',
                      contentPadding: const EdgeInsets.all(Sizes.padding),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: Sizes.padding),
                       /* Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Seleziona lingua'.tr(), style: CLTheme.of(context).bodyText),
                            PopupMenuButton(
                              tooltip: "",
                              onOpened: () {},
                              onCanceled: () {},
                              color: CLTheme.of(context).secondaryBackground,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.borderRadius)),
                              offset: const Offset(10, 30),
                              itemBuilder: (context) {
                                return context.supportedLocales
                                    .map((language) => PopupMenuItem(
                                          enabled: true,
                                          child: ListTile(
                                            title: Text(
                                              language.languageCode,
                                              style: CLTheme.of(context).bodyText,
                                            ),
                                            leading: CountryFlag.fromLanguageCode(
                                              language.languageCode, // Codice ISO della Spagna
                                              width: 22,
                                              shape: const Circle(), // Bandiera in formato circolare
                                            ),
                                            onTap: () {
                                              appState.updateLocale(context, Locale(language.languageCode, language.countryCode));
                                              context.pop();
                                            },
                                          ),
                                        ))
                                    .toList();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CountryFlag.fromLanguageCode(
                                    context.locale.languageCode, // Codice ISO della Spagna
                                    width: 22,
                                    shape: const Circle(), // Bandiera in formato circolare
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    context.locale.languageCode,
                                    style: CLTheme.of(context).bodyText,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),*/
                        const SizedBox(height: Sizes.padding),

                        // cambio tema
                        /* Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Tema scuro', style: CLTheme.of(context).bodyText),
                            CupertinoSwitch(
                              value: Theme.of(context).brightness == Brightness.dark,
                              onChanged: (value) {
                                appState.changeTheme();
                              },
                            )
                          ],
                        ),*/
                        //const Divider(),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          trailing: const Icon(Icons.logout, size: Sizes.medium, color: Colors.red),
                          title: Text('Logout', style: CLTheme.of(context).bodyText.copyWith(color: Colors.red)),
                          onTap: () {
                            authState.setUnauthenticated();
                            context.customGoNamed(AuthRoutes.login.name);
                          },
                        ),
                      ])),
                ),
              ],
            ),
          );
        });
  }
}
