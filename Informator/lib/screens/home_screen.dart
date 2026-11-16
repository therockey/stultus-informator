import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/providers/app_bar_title_provider.dart';
import 'package:informator/screens/home/groups_screen.dart';
import 'package:informator/screens/home/home_tab.dart';
import 'package:informator/screens/home/services_screen.dart';
import 'package:informator/screens/home/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const int _defaultTabIndex = 1;

  int _selectedTabIndex = _defaultTabIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final titleOverride = ref.watch(appBarTitleOverrideProvider);

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

    final Map<int, HomeTab> tabs = {
      0: HomeTab(
        body: const GroupsScreen(),
        title: strings.groups,
        floatingActionButton: const AddGroupButton(),
      ),
      1: HomeTab(body: const ServicesScreen()),
      2: HomeTab(body: const SettingsScreen(), title: strings.settings),
    };

    final selectedTab = tabs[_selectedTabIndex] ?? tabs[_defaultTabIndex]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedTab.resolveTitle(titleOverride),
          style: TextStyle(color: theme.onSurface),
        ),
        centerTitle: true,
        backgroundColor: theme.primaryContainer,
      ),
      body: selectedTab.body,
      floatingActionButton: selectedTab.floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          if (tabs.containsKey(index)) {
            setState(() => _selectedTabIndex = index);
          }
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
      ),
    );
  }
}
