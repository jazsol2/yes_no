import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  const MessagefieldBox ({Key? key}): super(key: key);
  
  @override
  Widget build(BuildContext context){

    final textController;

    final FocusNode focusNode = FocusNode();
    
// Suggested code may be subject to a license. Learn more: ~LicenseLog:964914843.
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    );
    
    final InputDecoration = InputDecoration(
      hintText: 'Debes terminar tu mensaje con un "? "?"',
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      filled: true,
      suffixIcon: IconButton
        icon: Icon(icon.send_outlined)

    return TexFormfield(
      child: null,
    );
  }
}