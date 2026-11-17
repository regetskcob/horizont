import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:horizont/horizont.dart';

import 'showcase.dart';

void main() {
  registerHorizontLicenses();
  runApp(const ExampleApp());
}

/// Switches product, brightness and density from the top of the window.
class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  HorizontProduct _product = HorizontProduct.jagdaufseher;
  ThemeMode _mode = ThemeMode.light;
  HorizontDensity _density = HorizontDensity.forPlatform(defaultTargetPlatform);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizont',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      themeAnimationStyle: AnimationStyle.noAnimation,
      theme: buildHorizontTheme(_product, Brightness.light, density: _density),
      darkTheme: buildHorizontTheme(
        _product,
        Brightness.dark,
        density: _density,
      ),
      home: Builder(
        builder: (context) {
          final c = HorizontTheme.of(context).colors;
          return Column(
            children: [
              Material(
                color: c.sunken,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(HzSpace.s8),
                    child: Wrap(
                      spacing: HzSpace.s8,
                      runSpacing: HzSpace.s8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SegmentedButton<HorizontProduct>(
                          segments: [
                            for (final p in HorizontProduct.values)
                              ButtonSegment(
                                value: p,
                                label: Text(p.displayName),
                              ),
                          ],
                          selected: {_product},
                          showSelectedIcon: false,
                          onSelectionChanged: (s) =>
                              setState(() => _product = s.first),
                        ),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('Hell'),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('Dunkel'),
                            ),
                          ],
                          selected: {_mode},
                          showSelectedIcon: false,
                          onSelectionChanged: (s) =>
                              setState(() => _mode = s.first),
                        ),
                        SegmentedButton<HorizontDensity>(
                          segments: const [
                            ButtonSegment(
                              value: HorizontDensity.touch,
                              label: Text('Touch'),
                            ),
                            ButtonSegment(
                              value: HorizontDensity.pointer,
                              label: Text('Zeiger'),
                            ),
                          ],
                          selected: {_density},
                          showSelectedIcon: false,
                          onSelectionChanged: (s) =>
                              setState(() => _density = s.first),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(child: Showcase()),
            ],
          );
        },
      ),
    );
  }
}
