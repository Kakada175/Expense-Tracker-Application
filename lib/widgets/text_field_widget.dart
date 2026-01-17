import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final bool showEye;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final VoidCallback? onToggleVisibility; // 👈 Added this callback

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.hintText = '',
    this.obscureText = false,
    this.showEye = false,
    this.validator,
    this.fillColor,
    this.keyboardType,
    this.onToggleVisibility, // 👈 Added this
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText.isNotEmpty ? widget.hintText : null,
        filled: true,
        fillColor: widget.fillColor ?? const Color(0xFFE7E7EA),

        // Border styles
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),

        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),

        // Font styles
        labelStyle: GoogleFonts.poppins(color: Colors.grey.shade700),
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
        floatingLabelStyle: GoogleFonts.poppins(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: GoogleFonts.poppins(color: Colors.red, fontSize: 12),

        // Password eye toggle
        suffixIcon: widget.showEye
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                  if (widget.onToggleVisibility != null) {
                    widget.onToggleVisibility!();
                  }
                },
              )
            : null,
      ),
    );
  }
}
