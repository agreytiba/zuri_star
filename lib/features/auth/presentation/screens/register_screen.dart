import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_providers.dart';


final registerRoleProvider = StateProvider<String>((ref) => 'customer');

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(); 
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); 
  String? _selectedGender; 
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }
      
      final role = ref.read(registerRoleProvider);
      // NOTE: We are passing 'role' conceptually. You must update AuthNotifier/Repository to accept this.
      // For now we will assume the method signature will be updated to map this.
      ref.read(authProvider.notifier).register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
            role: role, 
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/home');
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    const primaryColor = Color(0xFFEAB308);
    final labelStyle = GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
    final hintStyle = GoogleFonts.inter(
      fontSize: 14,
      color: Colors.grey.shade500,
    );
    
    InputDecoration inputDecor(String hint) {
      return InputDecoration(
        hintText: hint,
        hintStyle: hintStyle,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            height: 150, // Slightly shorter than login to fit more fields
            width: double.infinity,
            color: primaryColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'SIGN UP FORM',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username
                    Text('Username', style: labelStyle),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: inputDecor('Enter your Username'),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    Text('Email', style: labelStyle),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: inputDecor('Enter your Email'),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Phone Number
                    Text('Phone Number', style: labelStyle),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      decoration: inputDecor('Enter your Phone Number'), 
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    
                    // Role Selection
                    Text('I am a', style: labelStyle),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: 'customer',
                      decoration: inputDecor('Choose Role'),
                      items: const [
                        DropdownMenuItem(value: 'customer', child: Text('Customer')),
                        DropdownMenuItem(value: 'salon_owner', child: Text('Salon Owner')),
                      ],
                      onChanged: (val) {
                        // Store this for registration usage
                        // We need to add a controller or variable for this in the state
                        // For now, I'll update the state variable I'll add below
                         ref.read(registerRoleProvider.notifier).state = val!;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Gender
                    Text('Gender', style: labelStyle),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: inputDecor('Choose Gender'),
                      items: ['Male', 'Female', 'Other'].map((String val) {
                        return DropdownMenuItem(value: val, child: Text(val));
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedGender = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    Text('Password', style: labelStyle),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: inputDecor('Enter your Password').copyWith(
                         suffixIcon: const Icon(Icons.visibility_outlined, color: Colors.grey),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    Text('Confirm Password', style: labelStyle),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: inputDecor('Enter your Password').copyWith(
                         suffixIcon: const Icon(Icons.visibility_outlined, color: Colors.grey),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 32),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: authState.isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Sign Up'),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade400)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or sign up with',
                            style: GoogleFonts.inter(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade400)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Social Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
                            label: Text(
                              'Facebook', 
                              style: GoogleFonts.inter(color: Colors.black87, fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.g_mobiledata, color: Color(0xFFDB4437), size: 28),
                            label: Text(
                              'Google', 
                              style: GoogleFonts.inter(color: Colors.black87, fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Footer
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go('/login'),
                        child: RichText(
                          text: TextSpan(
                            text: 'Have an account? ',
                            style: GoogleFonts.inter(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: GoogleFonts.inter(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
