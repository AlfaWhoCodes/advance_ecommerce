import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

//3D Model Images in Flutter by AlfaWhoCodes

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nike Shoes 3D',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Nike Air Zoom Royal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Flutter3DController controller = Flutter3DController();
  String? chosenAnimation;
  String? chosenTexture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Action for shopping cart (optional)
            },
          )
        ],
      ),
      //  floatingActionButton: buildFloatingActionButtons(),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Flutter3DViewer(
              controller: controller,
              src: 'assets/shoes.glb',
            ),
          ),
          const Expanded(
            flex: 4,
            child: ProductDetails(),
          ),
        ],
      ),
    );
  }

  FloatingActionButtonColumn buildFloatingActionButtons() {
    return FloatingActionButtonColumn(controller: controller);
  }
}

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nike Air Zoom Royal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Experience the ultimate comfort and performance with Nike Air Zoom Royal. Designed for the athlete in you.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Spacer(),
          Container(
            padding: EdgeInsets.only(bottom: 24, left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '\₹2590',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Buy now action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 3, 55, 176),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingActionButtonColumn extends StatelessWidget {
  const FloatingActionButtonColumn({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final Flutter3DController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          onPressed: () {
            controller.playAnimation();
          },
          child: const Icon(Icons.play_arrow),
        ),
        const SizedBox(height: 4),
        FloatingActionButton.small(
          onPressed: () {
            controller.pauseAnimation();
          },
          child: const Icon(Icons.pause),
        ),
        const SizedBox(height: 4),
        FloatingActionButton.small(
          onPressed: () {
            controller.resetAnimation();
          },
          child: const Icon(Icons.replay_circle_filled),
        ),
        const SizedBox(height: 4),
        FloatingActionButton.small(
          onPressed: () async {
            List<String> availableAnimations =
                await controller.getAvailableAnimations();
            String? chosenAnimation =
                await showPickerDialog(context, availableAnimations);
            controller.playAnimation(animationName: chosenAnimation);
          },
          child: const Icon(Icons.format_list_bulleted_outlined),
        ),
        const SizedBox(height: 4),
        FloatingActionButton.small(
          onPressed: () async {
            List<String> availableTextures =
                await controller.getAvailableTextures();
            String? chosenTexture =
                await showPickerDialog(context, availableTextures);
            controller.setTexture(textureName: chosenTexture ?? '');
          },
          child: const Icon(Icons.list_alt_rounded),
        ),
        const SizedBox(height: 4),
        FloatingActionButton.small(
          onPressed: () {
            controller.setCameraOrbit(20, 20, 5);
          },
          child: const Icon(Icons.camera_alt),
        ),
        const SizedBox(height: 4),
        FloatingActionButton.small(
          onPressed: () {
            controller.resetCameraOrbit();
          },
          child: const Icon(Icons.cameraswitch_outlined),
        ),
      ],
    );
  }
}

Future<String?> showPickerDialog(
    BuildContext context, List<String> inputList) async {
  return await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 250,
          child: ListView.separated(
            itemCount: inputList.length,
            padding: const EdgeInsets.only(top: 16),
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context, inputList[index]);
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${index + 1}'),
                      Text(inputList[index]),
                      const Icon(Icons.check_box_outline_blank),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const Divider(
                color: Colors.grey,
                thickness: 0.6,
                indent: 10,
                endIndent: 10,
              );
            },
          ),
        );
      });
}
