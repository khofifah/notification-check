import 'package:flutter/material.dart';

Widget customTile(
  String text,
  bool? isSuccess,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: Center(
            child: isSuccess == null
                ? const CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Color(0xFF238326),
                  )
                : Icon(
                    isSuccess
                        ? Icons.check_circle_outline
                        : Icons.highlight_off,
                    color: Color(isSuccess ? 0xFF238326 : 0xFFDF2A36),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
