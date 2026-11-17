import 'package:informator/screens/home/group_details_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/group.dart';
import 'package:informator/providers/app_bar_title_provider.dart';
import 'package:informator/providers/groups_provider.dart';
import 'package:informator/screens/home/groups_screen.dart';
import 'package:informator/screens/home/home_tab.dart';
import 'package:informator/screens/home/services_screen.dart';
import 'package:informator/screens/home/settings_screen.dart';
import 'package:informator/widgets/create_group_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const int _defaultTabIndex = 1;

  int _selectedTabIndex = _defaultTabIndex;
  Group? _selectedGroup;

  Future<void> _showCreateGroupDialog(BuildContext context) async {
    final groupName = await showDialog<String>(
      context: context,
      builder: (context) => const CreateGroupDialog(),
    );

    if (groupName == null || groupName.trim().isEmpty) return;

    await ref.read(groupsProvider.notifier).add(groupName.trim());
  }

  void _openGroup(Group group) {
    setState(() {
      _selectedTabIndex = 0;
      _selectedGroup = group;
    });
  }

  void _closeGroupDetails() {
    setState(() {
      _selectedGroup = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final titleOverride = ref.watch(appBarTitleOverrideProvider);
    final groupsState = ref.watch(groupsProvider);

    final Group? currentGroup = groupsState.when(
      data: (groups) {
        final selected = _selectedGroup;

        if (selected == null) {
          return null;
        }

        for (final group in groups) {
          if (group.id == selected.id) {
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
            ? AddGroupButton(
                onPressed: () => _showCreateGroupDialog(context),
              )
            : null,
      ),
      1: HomeTab(
        body: const ServicesScreen(),
      ),
      2: HomeTab(
        body: const SettingsScreen(),
        title: strings.settings,
      ),
    };

    final selectedTab =
        tabs[_selectedTabIndex] ?? tabs[_defaultTabIndex]!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: _selectedTabIndex == 0 && currentGroup != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _closeGroupDetails,
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
          currentIndex: _selectedTabIndex,
          onTap: (index) {
            if (!tabs.containsKey(index)) {
              return;
            }

            setState(() {
              _selectedTabIndex = index;
              _selectedGroup = null;
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
