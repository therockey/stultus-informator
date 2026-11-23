import 'package:informator/screens/home/group_details_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/group.dart';
import 'package:informator/providers/app_bar_title_provider.dart';
import 'package:informator/providers/groups_provider.dart';
import 'package:informator/providers/home_tab_provider.dart';
import 'package:informator/screens/home/groups_screen.dart';
import 'package:informator/screens/home/home_tab.dart';
import 'package:informator/screens/home/services_screen.dart';
import 'package:informator/screens/home/settings_screen.dart';
import 'package:informator/screens/home/service_details_screen.dart';
import 'package:informator/screens/home/transport_screen.dart';
import 'package:informator/screens/home/transport_line_details_screen.dart';
import 'package:informator/widgets/create_group_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    this.initialTab,
    this.initialGroupName,
    this.initialServiceId,
    this.initialTransport = false,
    this.initialTransportLineId,
  });

  final String? initialTab;
  final String? initialGroupName;
  final String? initialServiceId;
  final bool initialTransport;
  final String? initialTransportLineId;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const int _defaultTabIndex = 1;

  Group? _selectedGroup;
  late String? _selectedServiceId;
  late String? _selectedTransportLineId;
  late String? _initialGroupName;

  @override
  void initState() {
    super.initState();
    final initialIndex = switch (widget.initialTab) {
      'groups' => 0,
      'transport' => 2,
      'settings' => 3,
      _ => null,
    };
    if (initialIndex != null) {
      ref.read(homeTabIndexProvider.notifier).setIndex(initialIndex);
    }
    _initialGroupName = widget.initialGroupName;
    _selectedServiceId = widget.initialServiceId;
    _selectedTransportLineId = widget.initialTransportLineId;
  }

  Future<void> _showCreateGroupDialog(BuildContext context) async {
    final groupName = await showDialog<String>(
      context: context,
      builder: (context) => const CreateGroupDialog(),
    );

    if (groupName == null || groupName.trim().isEmpty) return;

    await ref.read(groupsProvider.notifier).add(groupName.trim());
  }

  void _openGroup(Group group) {
    Navigator.of(context)
        .pushNamed('/groups/${Uri.encodeComponent(group.name)}');
  }

  void _closeGroupDetails() {
    setState(() {
      _selectedGroup = null;
    });
  }

  void _openService(String serviceId) {
    Navigator.of(context)
        .pushNamed('/services/${Uri.encodeComponent(serviceId)}');
  }

  void _openTransportLine(String lineId) {
    Navigator.of(context)
        .pushNamed('/transport/line/${Uri.encodeComponent(lineId)}');
  }

  void _closeMiddleDetails() {
    ref.read(appBarTitleOverrideProvider.notifier).clear();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      if (_selectedTransportLineId != null) {
        _selectedTransportLineId = null;
      } else {
        _selectedServiceId = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final titleOverride = ref.watch(appBarTitleOverrideProvider);
    final groupsState = ref.watch(groupsProvider);
    final selectedTabIndex = ref.watch(homeTabIndexProvider);

    final Group? currentGroup = groupsState.when(
      data: (groups) {
        final selected = _selectedGroup;

        if (selected == null && _initialGroupName == null) {
          return null;
        }

        for (final group in groups) {
          if (selected != null && group.id == selected.id) {
            return group;
          }
          if (selected == null &&
              group.name.toLowerCase() == _initialGroupName?.toLowerCase()) {
            return group;
          }
        }

        return null;
      },
      loading: () => _selectedGroup,
      error: (_, __) => _selectedGroup,
    );

    Widget selectedIcon(IconData icon) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: theme.primary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(icon, color: theme.onPrimary),
      );
    }

    final tabs = <int, HomeTab>{
      0: HomeTab(
        body: currentGroup == null
            ? GroupsScreen(onGroupTap: _openGroup)
            : GroupDetailsScreen(
                key: ValueKey(currentGroup.id),
                group: currentGroup,
              ),
        title: currentGroup?.name ?? strings.groups,
        floatingActionButton: currentGroup == null
            ? AddGroupButton(onPressed: () => _showCreateGroupDialog(context))
            : null,
      ),
      1: HomeTab(
        body: _selectedServiceId != null
            ? ServiceDetailsScreen(serviceId: _selectedServiceId!)
            : ServicesScreen(
                onServiceTap: (service) => _openService(service.id),
              ),
      ),
      2: HomeTab(
        body: _selectedTransportLineId != null
            ? TransportLineDetailsScreen(lineId: _selectedTransportLineId!)
            : TransportScreen(onLineTap: (line) => _openTransportLine(line.id)),
        title: strings.transport_title,
      ),
      3: HomeTab(body: const SettingsScreen(), title: strings.settings),
    };

    final selectedTab = tabs[selectedTabIndex] ?? tabs[_defaultTabIndex]!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: selectedTabIndex == 0 && currentGroup != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _closeGroupDetails,
              )
            : selectedTabIndex == 1 &&
                  (_selectedServiceId != null ||
                      _selectedTransportLineId != null)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _closeMiddleDetails,
              )
            : selectedTabIndex == 2 && _selectedTransportLineId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _closeMiddleDetails,
              )
            : null,
        title: Text(
          currentGroup != null
              ? currentGroup.name
              : selectedTab.resolveTitle(titleOverride),
          style: TextStyle(color: theme.onSurface),
        ),
        centerTitle: true,
        toolbarHeight: 72,
        backgroundColor: theme.primaryContainer,
        actions: [
          if (currentGroup == null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: theme.secondaryContainer,
                foregroundColor: theme.onSecondaryContainer,
                child: const Icon(Icons.person_outline),
              ),
            )
          else
            const SizedBox(width: 16),
        ],
      ),
      body: selectedTab.body,
      floatingActionButton: selectedTab.floatingActionButton,
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          currentIndex: selectedTabIndex,
          selectedItemColor: theme.primary,
          unselectedItemColor: theme.onSurfaceVariant,
          onTap: (index) {
            if (!tabs.containsKey(index)) {
              return;
            }

            ref.read(homeTabIndexProvider.notifier).setIndex(index);
            setState(() {
              _selectedGroup = null;
              _selectedServiceId = null;
              _selectedTransportLineId = null;
              ref.read(appBarTitleOverrideProvider.notifier).clear();
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              activeIcon: selectedIcon(Icons.home),
              label: strings.groups,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              activeIcon: selectedIcon(Icons.search),
              label: strings.services,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.directions_transit),
              activeIcon: selectedIcon(Icons.directions_transit),
              label: strings.transport_title,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              activeIcon: selectedIcon(Icons.settings),
              label: strings.settings,
            ),
          ],
          backgroundColor: theme.primaryContainer,
          selectedFontSize: 12,
          unselectedFontSize: 12,
        ),
      ),
    );
  }
}
