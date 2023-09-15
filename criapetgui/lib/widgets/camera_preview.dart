import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../my_default_settings.dart';

late List<CameraDescription> _cameras;

class MyCameraPreview extends StatefulWidget {
  const MyCameraPreview({Key? key}) : super(key: key);

  @override
  State<MyCameraPreview> createState() => _MyCameraPreviewState();
}

class _MyCameraPreviewState extends State<MyCameraPreview> {
  late CameraController cameraController;

  bool isInitialized = false;

  bool isFrontCamera = true;
  void toggleCamera() => setState(() => isFrontCamera = !isFrontCamera);

  bool isTakingPicture = false;
  void toggleTakePicture() =>
      setState(() => isTakingPicture = !isTakingPicture);

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();

    cameraController = CameraController(_cameras[1], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() => isInitialized = true);
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: isInitialized && !isTakingPicture
                  ? CameraPreview(cameraController)
                  : Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
            ),
            Row(
              children: [
                Expanded(
                  child: ControleCamera(
                    icon: Icon(
                      Icons.flip_camera_ios_outlined,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      int cameraIndex = !isFrontCamera ? 1 : 0;
                      cameraController = CameraController(
                        _cameras[cameraIndex],
                        ResolutionPreset.max,
                      );
                      await cameraController.initialize();
                      toggleCamera();
                    },
                  ),
                ),
                Expanded(
                  child: ControleCamera(
                    icon: Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      toggleTakePicture();
                      final image = await cameraController.takePicture();
                      if (!mounted) return;
                      Navigator.of(context).pop(image.path);
                      toggleTakePicture();
                    },
                  ),
                ),
                Expanded(
                  child: ControleCamera(
                    icon: Icon(
                      Icons.undo,
                      color: Colors.white,
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ControleCamera extends StatelessWidget {
  VoidCallback onTap;
  Icon icon;

  ControleCamera({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MyDefaultSettings.gutter,
          vertical: MyDefaultSettings.gutter * 2,
        ),
        color: Colors.black,
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
