import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/presentation/providers/auth_providers.dart';
import '../../../core/services/supabase_service.dart';

class OwnerStaffMember {
  final String id;
  final String name;
  final String? avatarUrl;
  final List<String> skills;
  final double commissionRate;

  OwnerStaffMember({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.skills,
    required this.commissionRate,
  });

  factory OwnerStaffMember.fromJson(Map<String, dynamic> json) {
    return OwnerStaffMember(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      skills: (json['skills'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      commissionRate: (json['commission_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

final ownerStaffProvider =
    StreamProvider.autoDispose<List<OwnerStaffMember>>((ref) async* {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  if (user == null) {
    yield [];
    return;
  }

  final stream = SupabaseService.client
      .from('staff')
      .stream(primaryKey: ['id'])
      .eq('owner_id', user.id);

  await for (final rows in stream) {
    yield rows
        .map((row) => OwnerStaffMember.fromJson(row as Map<String, dynamic>))
        .toList();
  }
});

class OwnerStaffScreen extends ConsumerWidget {
  const OwnerStaffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(ownerStaffProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Staff',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const _EditStaffSheet(),
              );
            },
          ),
        ],
      ),
      body: staffAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (staff) {
          if (staff.isEmpty) {
            return const _EmptyStaffView();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: staff.length,
            itemBuilder: (context, index) {
              final member = staff[index];
              return _StaffTile(member: member);
            },
          );
        },
      ),
    );
  }
}

class _StaffTile extends StatelessWidget {
  const _StaffTile({required this.member});

  final OwnerStaffMember member;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              member.avatarUrl != null ? NetworkImage(member.avatarUrl!) : null,
          child:
              member.avatarUrl == null ? Text(member.name.characters.first) : null,
        ),
        title: Text(
          member.name,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          member.skills.isEmpty
              ? 'No skills assigned'
              : member.skills.join(', '),
        ),
        trailing: Text(
          '${(member.commissionRate * 100).toStringAsFixed(0)}%',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _EditStaffSheet extends ConsumerStatefulWidget {
  const _EditStaffSheet({this.existing});

  final OwnerStaffMember? existing;

  @override
  ConsumerState<_EditStaffSheet> createState() => _EditStaffSheetState();
}

class _EditStaffSheetState extends ConsumerState<_EditStaffSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _skillsController;
  late TextEditingController _commissionController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _skillsController = TextEditingController(
      text: widget.existing?.skills.join(', ') ?? '',
    );
    _commissionController = TextEditingController(
      text: widget.existing != null
          ? (widget.existing!.commissionRate * 100).toString()
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skillsController.dispose();
    _commissionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.existing == null ? 'Add staff' : 'Edit staff',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _skillsController,
              decoration: const InputDecoration(
                labelText: 'Skills (comma separated)',
              ),
            ),
            TextFormField(
              controller: _commissionController,
              decoration: const InputDecoration(
                labelText: 'Commission (%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.existing != null)
                  TextButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () async {
                            await SupabaseService.client
                                .from('staff')
                                .delete()
                                .eq('id', widget.existing!.id);
                            if (mounted) Navigator.of(context).pop();
                          },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed:
                      _isSaving ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (user == null) return;

                          setState(() {
                            _isSaving = true;
                          });

                          final skills = _skillsController.text
                              .split(',')
                              .map((s) => s.trim())
                              .where((s) => s.isNotEmpty)
                              .toList();

                          final commissionPercent =
                              double.tryParse(_commissionController.text) ?? 0.0;

                          final payload = {
                            'owner_id': user.id,
                            'name': _nameController.text.trim(),
                            'skills': skills,
                            'commission_rate': commissionPercent / 100,
                          };

                          if (widget.existing == null) {
                            await SupabaseService.client
                                .from('staff')
                                .insert(payload);
                          } else {
                            await SupabaseService.client
                                .from('staff')
                                .update(payload)
                                .eq('id', widget.existing!.id);
                          }

                          if (mounted) Navigator.of(context).pop();
                        },
                  child: _isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _EmptyStaffView extends StatelessWidget {
  const _EmptyStaffView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.group_outlined, size: 48),
            const SizedBox(height: 8),
            Text(
              'No staff members yet',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Add your team members so you can assign bookings and track commissions.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

