import 'package:flutter/widgets.dart';
import 'package:tagntango/app/app.dart';
import 'package:tagntango/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bootstrap(() => const TagNTangoApp());
}
