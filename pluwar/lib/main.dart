import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pluwar/app.dart';
import 'package:pluwar/r.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    final appDocDir = await getApplicationDocumentsDirectory();
    R.appDir = appDocDir.path;
    final tmpDir = await getTemporaryDirectory();
    R.tmpDir = tmpDir.path;
    await Hive.initFlutter(R.hiveDir);
  }
  runApp(const PluwarApp());
}
