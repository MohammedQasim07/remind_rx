import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:remind_rx/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumTimePicker {
  static Future<TimeOfDay?> show(BuildContext context, {required TimeOfDay initialTime}) async {
    final l10n = AppLocalizations.of(context)!;
    TimeOfDay selectedTime = initialTime;

    return showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pull Bar Indicator
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              
              Text(
                l10n.pickTime, 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark),
              ),
              const SizedBox(height: 24),
              
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: GoogleFonts.alexandria(
                        fontSize: 22,
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                      pickerTextStyle: GoogleFonts.alexandria(
                        fontSize: 22,
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime(0, 0, 0, initialTime.hour, initialTime.minute),
                    use24hFormat: false,
                    onDateTimeChanged: (DateTime newDateTime) {
                      selectedTime = TimeOfDay.fromDateTime(newDateTime);
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              Row(
                children: [
                   Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.pop(ctx, null),
                      child: Text(
                        l10n.cancel, 
                        style: GoogleFonts.alexandria(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppTheme.primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(ctx, selectedTime),
                      child: Text(
                        l10n.save, 
                        style: GoogleFonts.alexandria(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
