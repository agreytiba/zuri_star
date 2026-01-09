import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/presentation/providers/auth_providers.dart';
import '../../../core/services/supabase_service.dart';

class OwnerService {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final bool isEnabled;

  OwnerService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.isEnabled,
  });

  factory OwnerService.fromJson(Map<String, dynamic> json) {
    return OwnerService(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      durationMinutes: json['duration_minutes'] as int,
      isEnabled: json['is_enabled'] as bool? ?? true,
    );
  }
}

final ownerServicesProvider =
    StreamProvider.autoDispose<List<OwnerService>>((ref) async* {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  if (user == null) {
    yield [];
    return;
  }

  final stream = SupabaseService.client
      .from('services')
      .stream(primaryKey: ['id'])
      .eq('owner_id', user.id);

  await for (final rows in stream) {
    yield rows
        .map((row) => OwnerService.fromJson(row as Map<String, dynamic>))
        .toList();
  }
});

class OwnerServicesScreen extends ConsumerWidget {
  const OwnerServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(ownerServicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Services',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const _EditServiceSheet(),
              );
            },
          ),
        ],
      ),
      body: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (services) {
          if (services.isEmpty) {
            return const _EmptyServicesView();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceTile(service: service);
            },
          );
        },
      ),
    );
  }
}

class _ServiceTile extends ConsumerWidget {
  const _ServiceTile({required this.service});

  final OwnerService service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          service.name,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${service.durationMinutes} mins • \$${service.price.toStringAsFixed(0)}',
        ),
        trailing: Switch(
          value: service.isEnabled,
          onChanged: (value) async {
            await SupabaseService.client
                .from('services')
                .update({'is_enabled': value}).eq('id', service.id);
          },
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => _EditServiceSheet(existing: service),
          );
        },
      ),
    );
  }
}

class _EditServiceSheet extends ConsumerStatefulWidget {
  const _EditServiceSheet({this.existing});

  final OwnerService? existing;

  @override
  ConsumerState<_EditServiceSheet> createState() => _EditServiceSheetState();
}

class _EditServiceSheetState extends ConsumerState<_EditServiceSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.existing?.description ?? '');
    _priceController = TextEditingController(
      text: widget.existing?.price.toString() ?? '',
    );
    _durationController = TextEditingController(
      text: widget.existing?.durationMinutes.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
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
              widget.existing == null ? 'Add service' : 'Edit service',
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
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _durationController,
              decoration:
                  const InputDecoration(labelText: 'Duration (minutes)'),
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
                                .from('services')
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

                          final payload = {
                            'owner_id': user.id,
                            'name': _nameController.text.trim(),
                            'description': _descriptionController.text.trim(),
                            'price':
                                double.tryParse(_priceController.text) ?? 0.0,
                            'duration_minutes':
                                int.tryParse(_durationController.text) ?? 0,
                            'is_enabled': true,
                          };

                          if (widget.existing == null) {
                            await SupabaseService.client
                                .from('services')
                                .insert(payload);
                          } else {
                            await SupabaseService.client
                                .from('services')
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

class _EmptyServicesView extends StatelessWidget {
  const _EmptyServicesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.design_services_outlined, size: 48),
            const SizedBox(height: 8),
            Text(
              'No services configured',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Add your first service to start accepting bookings.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

