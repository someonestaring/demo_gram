import 'package:demo_gram/screens/auth/ext/post_ext/post_edit.dart';
import 'package:flutter/material.dart';
// import 'package:media_gallery/media_gallery.dart';

class PostBody extends StatefulWidget {
  const PostBody({Key? key}) : super(key: key);
  @override
  _PostBodyState createState() => _PostBodyState();
}

class _PostBodyState extends State<PostBody> {
  dynamic _localMedia;

  @override
  void initState() {
    super.initState();
    // _mediaAccess();
  }

  // Future<void> _mediaAccess() async {
  //   dynamic tempMedia = await MediaGallery.listMediaCollections(
  //     mediaTypes: [MediaType.image, MediaType.video],
  //   );
  //   print(tempMedia);
  //   setState(() {
  //     _localMedia = tempMedia;
  //   });
  // }

  Future<void> _cameraAccess() async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget _currentMediaView() {
      return SizedBox(
        height: size.height * 0.5,
        width: size.width,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white54,
          ),
        ),
      );
    }

    Widget _utilityBar() {
      return SizedBox(
        height: size.height * 0.065,
        width: size.width,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
      );
    }

    Widget _mediaGrid() {
      return DecoratedBox(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: GridView.builder(
            addRepaintBoundaries: false,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            // primary: true,
            shrinkWrap: true,
            itemCount: 48,
            itemBuilder: (BuildContext context, int index) =>
                // _localImages[index])
                const Card(
              child:
                  Image(image: AssetImage('assets/images/Demo_Gram_Logo.png')),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
            ),
          ));
    }

    PreferredSizeWidget _appBar() {
      return PreferredSize(
        child: SizedBox(
          height: size.height * 0.11,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  ),
                  const Text(
                    'New post',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const PostEditing()));
                },
                icon: const Icon(
                  Icons.east,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size(size.width, size.height * 0.15),
      );
    }

    Widget _bodyContent() {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              _currentMediaView(),
              _utilityBar(),
              _mediaGrid(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _appBar(),
      body: _bodyContent(),
    );
  }
}
