import 'package:flutter/cupertino.dart';

///
class Controls extends StatelessWidget {
  ///
  const Controls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _space,
          // MetaDataSection(),
          _space,
          // SourceInputSection(),
          _space,
          // PlayPauseButtonBar(),
          _space,
          // VolumeSlider(),
          _space,
          // PlayerStateSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
