import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renmoney_test/features/weather/viewmodels/fetch_weather_by_city_viewmodel.dart';
import 'package:renmoney_test/shared/app_colors.dart';

class MultiSelectDropdown extends ConsumerStatefulWidget {
  const MultiSelectDropdown({
    super.key,
    required this.cities,
  });

  final List<String> cities;

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends ConsumerState<MultiSelectDropdown> {
  void _showMultiSelectDialog() async {
    await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          cities: widget.cities,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _showMultiSelectDialog,
      child: Text(
        'Select Cities',
        style: TextStyle(
          color: appColors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class MultiSelectDialog extends ConsumerStatefulWidget {
  final List<String> cities;

  const MultiSelectDialog({super.key, required this.cities});

  @override
  createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends ConsumerState<MultiSelectDialog> {
  List<String> _tempSelectedCities = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedCities = List.from(ref.read(selectedCities));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Cities'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.cities.map((city) {
            return CheckboxListTile(
              value: _tempSelectedCities.contains(city),
              title: Text(city),
              onChanged: (bool? isSelected) {
                setState(() {
                  if (isSelected == true) {
                    _tempSelectedCities.add(city);
                  } else {
                    _tempSelectedCities.remove(city);
                  }
                });
                ref.read(selectedCities.notifier).state = _tempSelectedCities;
                ref
                    .read(fetchWeatherByCityProvider.notifier)
                    .addOrRemoveCity(city);
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(context, _tempSelectedCities);
          },
        ),
      ],
    );
  }
}
