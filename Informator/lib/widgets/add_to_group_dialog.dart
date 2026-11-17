
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/group.dart';
import 'package:material_ui/material_ui.dart';

class AddToGroupDialog extends StatefulWidget {
  const AddToGroupDialog({
    super.key,
    required this.groups,
  });

  final List<Group> groups;

  @override
  State<AddToGroupDialog> createState() => _AddToGroupDialogState();
}

class _AddToGroupDialogState extends State<AddToGroupDialog> {
  final _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Group> get _filteredGroups {
    if (_searchQuery.isEmpty) {
      return widget.groups;
    }

    return widget.groups
        .where(
          (group) => group.name.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final filteredGroups = _filteredGroups;

    return AlertDialog(
      title: Text(strings.add_to_group_title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.add_to_group_instruction),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: strings.add_to_group_name_label,
                hintText: strings.add_to_group_name_hint,
                border: const OutlineInputBorder(),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
            const SizedBox(height: 12),
            if (widget.groups.isEmpty)
              Text(strings.add_to_group_empty)
            else if (filteredGroups.isEmpty)
              Text(strings.add_to_group_no_results)
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: filteredGroups.map((group) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(group.name),
                      onTap: () {
                        Navigator.of(context).pop(group);
                      },
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
