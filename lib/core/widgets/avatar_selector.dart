import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

class AvatarSelector extends StatelessWidget {
  final String? currentAvatarPath;
  final ValueChanged<String?> onAvatarSelected;
  final double size;

  const AvatarSelector({
    super.key,
    required this.currentAvatarPath,
    required this.onAvatarSelected,
    this.size = 110,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarChild = Icon(Icons.person, color: AppTheme.primaryGreen, size: size * 0.45);
    
    if (currentAvatarPath != null) {
      if (currentAvatarPath!.startsWith('http')) {
        avatarChild = ClipOval(child: Image.network(currentAvatarPath!, fit: BoxFit.cover, width: size, height: size));
      } else {
        avatarChild = ClipOval(child: Image.file(File(currentAvatarPath!), fit: BoxFit.cover, width: size, height: size));
      }
    }

    return Center(
      child: GestureDetector(
        onTap: () => _showAvatarSelectorSheet(context),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: size, height: size,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.15), 
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.8), width: 3),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: avatarChild,
            ),
            Container(
              padding: EdgeInsets.all(size * 0.07),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen, 
                shape: BoxShape.circle, 
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]
              ),
              child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: size * 0.15),
            )
          ]
        )
      )
    );
  }

  void _showAvatarSelectorSheet(BuildContext context) {
    final defaultAvatars = [
      'https://api.dicebear.com/7.x/notionists/png?seed=Felix&backgroundColor=e5f6eb',
      'https://api.dicebear.com/7.x/notionists/png?seed=Aneka&backgroundColor=e5f6eb',
      'https://api.dicebear.com/7.x/notionists/png?seed=Oliver&backgroundColor=e5f6eb',
      'https://api.dicebear.com/7.x/notionists/png?seed=Sophie&backgroundColor=e5f6eb',
      'https://api.dicebear.com/7.x/notionists/png?seed=Jack&backgroundColor=e5f6eb',
      'https://api.dicebear.com/7.x/notionists/png?seed=Mia&backgroundColor=e5f6eb',
      'https://api.dicebear.com/7.x/notionists/png?seed=Leo&backgroundColor=e5f6eb',
      'https://api.dicebear.com/7.x/notionists/png?seed=Zoe&backgroundColor=e5f6eb'
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
         padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
         decoration: const BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.vertical(top: Radius.circular(32))
         ),
         child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
               const SizedBox(height: 24),
               const Text('Profile Picture', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
               const SizedBox(height: 24),
               ListTile(
                 contentPadding: EdgeInsets.zero,
                 leading: Container(
                   padding: const EdgeInsets.all(12),
                   decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.1), shape: BoxShape.circle),
                   child: const Icon(Icons.photo_library_rounded, color: AppTheme.primaryGreen)
                 ),
                 title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                 trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
                 onTap: () async {
                    Navigator.pop(ctx);
                    final ImagePicker picker = ImagePicker();
                    try {
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        onAvatarSelected(image.path);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: \$e')));
                    }
                 }
               ),
               const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(height: 1)),
               const Text('Or pick an Avatar', style: TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.bold)),
               const SizedBox(height: 24),
               Wrap(
                 spacing: 20, runSpacing: 20,
                 alignment: WrapAlignment.center,
                 children: defaultAvatars.map((a) => GestureDetector(
                   onTap: () { 
                     onAvatarSelected(a); 
                     Navigator.pop(ctx); 
                   },
                   child: Container(
                     width: 70, height: 70,
                     decoration: BoxDecoration(
                        color: currentAvatarPath == a ? AppTheme.primaryGreen.withOpacity(0.2) : Colors.grey.shade100, 
                        shape: BoxShape.circle,
                        border: currentAvatarPath == a ? Border.all(color: AppTheme.primaryGreen, width: 3) : Border.all(color: Colors.transparent)
                     ),
                     child: ClipOval(child: Image.network(a, fit: BoxFit.cover)),
                   ),
                 )).toList(),
               )
            ]
         )
      )
    );
  }
}
