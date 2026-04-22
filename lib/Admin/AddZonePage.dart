
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddZonePage extends StatefulWidget {
  final String selectedLocation;
  final List<String> existingZoneNames;

  const AddZonePage({
    super.key,
    required this.selectedLocation,
    required this.existingZoneNames,
  });

  @override
  State<AddZonePage> createState() => _AddZonePageState();
}

class _AddZonePageState extends State<AddZonePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const Color kRushdPurple = Color(0xFF867AB9);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  String? _locationId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadLocationId();
  }

  Future<void> _loadLocationId() async {
    try {
      final snapshot = await _firestore
          .collection('locations')
          .where('locationName', isEqualTo: widget.selectedLocation)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _locationId = snapshot.docs.first.id;
      }
    } catch (e) {
      debugPrint('Error loading locationId: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_locationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not found')),
      );
      return;
    }

    final zoneName = _nameController.text.trim();
    final areaSize = int.tryParse(_areaController.text.trim()) ?? 0;
    final capacity = int.tryParse(_capacityController.text.trim()) ?? 0;

    final exists = widget.existingZoneNames.any(
      (name) => name.toLowerCase() == zoneName.toLowerCase(),
    );

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zone already exists')),
      );
      return;
    }

    try {
      setState(() => _isSaving = true);

      await _firestore.collection('zones').add({
        'zoneName': zoneName,
        'locationId': _locationId,
        'areaSize': areaSize,
        'capacity': capacity,
        'congestionLevel': 'low',
        'currentCount': 0,
        'density': 0,
        'highThreshold': 1,
        'lowThreshold': 0.3,
        'mediumThreshold': 0.7,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error adding zone: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save zone')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 380,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(context),
                      const SizedBox(height: 50),

                      const Text(
                        'Zone Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildField(
                        controller: _nameController,
                        hint: 'e.g. Zone A',
                        isNumber: false,
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Area Size',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildField(
                        controller: _areaController,
                        hint: 'e.g. 25',
                        isNumber: true,
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Capacity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildField(
                        controller: _capacityController,
                        hint: 'e.g. 25',
                        isNumber: true,
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          widget.selectedLocation,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),

                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 150,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _handleSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kRushdPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Save Zone',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required bool isNumber,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'Required field';
        }
        if (isNumber && int.tryParse(val.trim()) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: kRushdPurple, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        const SizedBox(width: 5),
        const Text(
          'Add New Zone',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}