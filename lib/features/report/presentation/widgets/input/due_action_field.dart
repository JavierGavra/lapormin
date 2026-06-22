import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class DueActionField extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime?> onChanged;

  const DueActionField({super.key, required this.onChanged, this.initialDate});

  @override
  State<DueActionField> createState() => _DueActionFieldState();
}

class _DueActionFieldState extends State<DueActionField> {
  bool _isUnlimited = true;
  DateTime? _selectedDate;

  String get _formattedDate {
    if (_selectedDate == null) return 'dd/mm/yyyy';
    final d = _selectedDate!.day.toString().padLeft(2, '0');
    final m = _selectedDate!.month.toString().padLeft(2, '0');
    final y = _selectedDate!.year;
    return '$d/$m/$y';
  }

  Future<void> _pickDate() async {
    if (_isUnlimited) return;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked == null) return;
    setState(() => _selectedDate = picked);
    widget.onChanged(picked);
  }

  void _toggleUnlimited(bool value) {
    setState(() {
      _isUnlimited = value;
      if (_isUnlimited) _selectedDate = null;
    });
    widget.onChanged(_isUnlimited ? null : _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        _buildLabelRow(color),
        _buildDateInput(color),
        _buildHelperText(color),
        _buildUnlimitedToggle(color),
      ],
    );
  }

  Widget _buildLabelRow(ColorScheme color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Batas Waktu Tindakan",
          style: AppTextStyle.s14(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildUnlimitedToggle(ColorScheme color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 8,
      children: [
        Text(
          "Tanpa batas waktu",
          style: AppTextStyle.s14(
            color: _isUnlimited ? color.primary : color.onSurfaceVariant,
            fontWeight: _isUnlimited ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: _isUnlimited,
            onChanged: _toggleUnlimited,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInput(ColorScheme color) {
    final isDisabled = _isUnlimited;
    return GestureDetector(
      onTap: _pickDate,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isDisabled
              ? color.surfaceContainerHighest
              : color.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDisabled ? color.outlineVariant : color.outline,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                isDisabled ? 'Tidak ada batas waktu' : _formattedDate,
                style: AppTextStyle.s14(
                  color: _selectedDate != null && !isDisabled
                      ? color.onSurface
                      : color.onSurfaceVariant,
                ),
              ),
            ),
            Icon(
              isDisabled
                  ? Icons.all_inclusive_rounded
                  : Icons.calendar_today_outlined,
              size: 18,
              color: isDisabled ? color.primary : color.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelperText(ColorScheme color) {
    return Text(
      "Tentukan batas waktu penyelesaian tindakan",
      style: AppTextStyle.s12(color: color.onSurfaceVariant),
    );
  }
}
