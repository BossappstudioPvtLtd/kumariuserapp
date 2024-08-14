import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:new_app/navigatinbar/favorite_page.dart';

class PageListGuideAr extends StatelessWidget {
  // var
  final List<Map> listLocations = [
    {
      'text0': 'Historical Sites',
      'text1':
          'The statue of Thiruvalluvar stands on an island near Vivekananda Rock Memorial, symbolizing Tamil literature and philosophy.',
      "urlImage":
          "https://www.tamilnadutourism.tn.gov.in/img/pages/large-desktop/kanyakumari-1654195435_bab3b5c9e1fc90ab56a8.webp",
    },
    {
      'text0': 'Cultural Landmarks',
      'text1': 'Dedicated to Swami Vivekananda, located on a rock island.',
      "urlImage":
          "https://www.tamilnadutourism.tn.gov.in/img/pages/large-desktop/vivekananda-rock-memorial-1655195795_ac72566bd8720c988c09.webp",
    },
    {
      'text0': 'Religious Sites',
      'text1': ' Ancient temple dedicated to the goddess Kanyakumari',
      "urlImage":
          "https://www.templedarshanyatri.com/upload/meenakshi-amma-temple-1.png",
    },
    {
      'text0': 'Natural Attractions',
      'text1': ' Scenic coastal views and sunset..',
      "urlImage":
          "https://beachesofindia.in/wp-content/uploads/2017/07/Untitled-design-68-1.jpg",
    },
    {
      'text0': 'Miscellaneous Attractions',
      'text1': 'Popular spot for watching sunsets.',
      "urlImage":
          "https://miro.medium.com/v2/resize:fit:1080/1*RQMgI0wnfxB5DiyduQR51g.jpeg",
    },
    {
      'text0': 'Museums and Educational Sites',
      'text1':
          'Kanyakumari’s museums offer insights into its cultural and historical significance.',
      "urlImage":
          "https://www.hlimg.com/images/things2do/738X538/ttd_1544975701m1.jpg?w=400&dpr=2.6",
    },
    {
      'text0': 'Wildlife and Nature Reserves',
      'text1':
          'These reserves highlight Kanyakumaris rich biodiversity and natural beauty.',
      "urlImage":
          "https://www.keralaholidays.com/uploads/tourpackages/main/backwater.jpg",
    },
    {
      'text0': 'Swami Vivekanandas House',
      'text1':
          ' where he stayed during his visit in 1892. It is a small museum showcasing his life and teachings.',
      "urlImage":
          "https://imgmedia.lbb.in/media/2020/12/5fc5fbe2740d0a4ca16582c0_1606810594841.jpg",
    },
    {
      'text0': 'Muttom Beach',
      'text1': 'Known for its lighthouse and tranquility.',
      "urlImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSB4w4Wk9gaXbBHR2k-80kYFVGmnJKxEPMUSA&s",
    },
    {
      'text0': 'Mathur Hanging Bridge ',
      'text1': '  Scenic bridge offering views..',
      "urlImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9OIBchoiD1kOlHpW5eCWvDMy36nWvCXjcug&s",
    },
    {
      'text0': 'Beautiful waterfalls.',
      'text1': 'Thirparappu Waterfalls',
      "urlImage":
          "https://arulshaji.com/wp-content/uploads/2023/09/thirparappu-waterfalls-1024x768.jpg",
    },
    {
      'text0': 'Art Gallery at Padmanabhapuram Palace ',
      'text1':
          'Art Gallery at Padmanabhapuram Palace.Historical and cultural artifacts.',
      "urlImage":
          "https://media1.thrillophilia.com/filestore/fb0zd9aird8yrlb75krijbwsihh8_1580473344_shutterstock_498424846.jpg",
    },
    {
      'text0': 'Kanyakumari Eco Park ',
      'text1':
          'is a nature park with walking paths and eco-friendly features. It offers a peaceful environment for relaxation.',
      "urlImage":
          "https://kanyakumaritourism.in/images/places-to-visit/headers/kanyakumari-eco-park-tourism-entry-fee-timings-holidays-reviews-header.jpg",
    },
    {
      'text0': 'Vivekananda Rock Memorial',
      'text1': 'Dedicated to Swami Vivekananda, located on a rock island.',
      "urlImage":
          "https://www.tamilnadutourism.tn.gov.in/img/pages/large-desktop/vivekananda-rock-memorial-1655195795_ac72566bd8720c988c09.webp",
    },
    {
      'text0': 'Azhikal Beach.',
      'text1': ' Quiet and scenic beach',
      "urlImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRv9514RBD050OWblV38HHUFZKFXk4Qpss-ew&s",
    },
    {
      'text0': 'Kanyakumari Art Gallery',
      'text1': 'Features local artworks and crafts.',
      "urlImage":
          "https://content.jdmagicbox.com/comp/def_content/art-galleries/l1bqhomyta-art-galleries-7-kej42.jpg",
    },
    {
      'text0': 'Vattakottai Fort',
      'text1': ' Coastal fort with historical significance.',
      "urlImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZ8iXctoSowXL029d4liOZcOU1I20o1wSr0w&s",
    },
    {
      'text0': 'Bharat Mata Temple ',
      'text1': ' Temple dedicated to Mother India.',
      "urlImage": "https://pbs.twimg.com/media/F_h_zyza0AAis6Z.jpg",
    },
    {
      'text0': 'Kallumalai Murugan Temple',
      'text1': 'Dedicated to Lord Murugan with scenic surroundings.',
      "urlImage":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Kallumalai_Murugan_Temple%2C_Ipoh%2C_Malaysia.jpg/2560px-Kallumalai_Murugan_Temple%2C_Ipoh%2C_Malaysia.jpg",
    },
    {
      'text0': 'mukkadal dam',
      'text1': ' A quaint village with natural beauty and religious sites.',
      "urlImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYNg5xA6GyeVB664WDQo3GtMc8vjEoRSAbsRKLIlZwdv_K5Wxvg8Bo8fwaWcx_8oesFIY&usqp=CAU",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // SystemUiOverlayStyle : Especifica una preferencia para el estilo de la barra de estado del sistema
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // barra de estado transparente
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark, // color de los iconos de la barra de estado
      ),
      child: Material(child: body(context: context)),
    );
  }

  // WIDGETS MAIN
  Widget body({required BuildContext context}) {
    return Stack(
      children: [
        // grid list
        PhotoGallery(photoUrls: listLocations),
        // BottomNavigationBar : posicionamos la barra de navegación en la parte inferior de la pantalla
        Align(
            alignment: Alignment.bottomCenter,
            child: widgetBottomNavigationBar(context: context)),
      ],
    );
  }

  //  WIDGETS COMPONENTS
  Widget widgetBottomNavigationBar({required BuildContext context}) {
    // values
    Decoration decoration = BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: const Alignment(0.0, 1.0),
            colors: <Color>[
              Colors.transparent,
              Theme.of(context).scaffoldBackgroundColor
            ],
            tileMode: TileMode.mirror));

    // Un widget de material que se muestra en la parte inferior de una aplicación para seleccionar entre una pequeña cantidad de vistas
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Container(
        decoration: decoration,
        child: const Stack(
          children: [
            SizedBox(
              height: 75,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                  ),
                  Icon(Icons.photo_library_outlined, color: Colors.blue),
                ],
              ),
            ),
            // icon
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 28,
                        foregroundImage: NetworkImage(
                            'https://www.tamilnadutourism.tn.gov.in/img/pages/large-desktop/kanyakumari-1654195435_bab3b5c9e1fc90ab56a8.webp'),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({Key? key, this.imageSize, required this.photoUrls})
      : super(key: key);

  // values
  final Size? imageSize;
  final List<Map> photoUrls;

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  // var
  static int _gridSize = 5;
  int _index = ((_gridSize * _gridSize) / 2)
      .round(); // El índice comienza en el medio de la cuadrícula (por ejemplo, 25 elementos, el índice comenzará en 13)
  final double _scale = 1;
  bool _skipNextOffsetTween = false;
  late Duration swipeDuration = const Duration(milliseconds: 600) * .4;
  int get _imgCount => pow(_gridSize, 2).round();

  @override
  void initState() {
    super.initState();
  }

  void _setIndex(int value, {bool skipAnimation = false}) {
    // desplazamiento de la vista
    if (value < 0 || value >= _imgCount) return;
    _skipNextOffsetTween = skipAnimation;
    setState(() => _index = value);
  }

  Offset _calculateCurrentOffset(double padding, Size size) {
    // Determine el desplazamiento requerido para mostrar el índice seleccionado actual

    // index=0 está arriba a la izquierda, y el index=max está abajo a la derecha

    // var
    double halfCount = (_gridSize / 2).floorToDouble();
    Size paddedImageSize = Size(size.width + padding, size.height + padding);
    // Obtenga el desplazamiento inicial que mostraría la imagen superior izquierda (índice 0)
    final originOffset = Offset(
        halfCount * paddedImageSize.width, halfCount * paddedImageSize.height);
    // Agregue el desplazamiento para la fila/columna
    int col = _index % _gridSize;
    int row = (_index / _gridSize).floor();
    final indexedOffset =
        Offset(-paddedImageSize.width * col, -paddedImageSize.height * row);

    // Offset : Un desplazamiento de punto flotante 2D inmutable
    return originOffset + indexedOffset;
  }

  /// Convierte una dirección de deslizamiento en un nuevo índice
  void _handleSwipe(Offset dir) {
    // Calcule el nuevo índice, los deslizamientos y se mueven una fila completa, los deslizamientos x mueven un índice a la vez
    int newIndex = _index;
    if (dir.dy != 0) newIndex += _gridSize * (dir.dy > 0 ? -1 : 1);
    if (dir.dx != 0) newIndex += (dir.dx > 0 ? -1 : 1);
    // Después de calcular el nuevo índice, salga temprano si no nos gusta...
    if (newIndex < 0 || newIndex > _imgCount - 1)
      return; // keep the index in range
    if (dir.dx < 0 && newIndex % _gridSize == 0)
      return; // prevent right-swipe when at right side
    if (dir.dx > 0 && newIndex % _gridSize == _gridSize - 1)
      return; // prevent left-swipe when at left side
    HapticFeedback
        .lightImpact(); // Proporciona una retroalimentación háptica correspondiente a un impacto de colisión con una masa ligera.
    _setIndex(newIndex);
  }

  Future<void> _handleImageTapped(int index) async {
    // manejar imagen tocada
    if (_index == index) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
      _setIndex(index, skipAnimation: true);
    } else {
      _setIndex(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photoUrls.isEmpty) {
      return const Center(child: Text('null list'));
    }

    // var
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size imgSize = (widget.imageSize ??
            Size(mediaQueryData.size.width * .66,
                mediaQueryData.size.height * .5)) *
        _scale;
    // Get transform offset for the current _index
    const padding = 20.0;
    var gridOffset = _calculateCurrentOffset(padding, imgSize);
    gridOffset += Offset(0, -mediaQueryData.padding.top / 2);
    final offsetTweenDuration =
        _skipNextOffsetTween ? Duration.zero : swipeDuration;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Una superposición con un centro transparente se encuentra encima de todo, animándose cada vez que cambia el índice
          SafeArea(
            bottom: false,
            // Coloque el contenido en el cuadro de desbordamiento, para permitir que fluya fuera del padre
            child: OverflowBox(
              maxWidth: _gridSize * imgSize.width + padding * (_gridSize - 1),
              maxHeight: _gridSize * imgSize.height + padding * (_gridSize - 1),
              alignment: Alignment.center,
              // EightWaySwipeDetector : Detectar deslizamientos para cambiar el índice
              child: EightWaySwipeDetector(
                onSwipe: (dir) => _handleSwipe(dir),
                threshold: 30,
                // Un constructor de animación de interpolación se mueve de una imagen a otra según el desplazamiento actual
                child: TweenAnimationBuilder<Offset>(
                  tween: Tween(begin: gridOffset, end: gridOffset),
                  duration: offsetTweenDuration,
                  curve: Curves.easeOut,
                  builder: (_, value, child) =>
                      Transform.translate(offset: value, child: child),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: _gridSize,
                    childAspectRatio: imgSize.aspectRatio,
                    mainAxisSpacing: padding,
                    crossAxisSpacing: padding,
                    children: List.generate(widget.photoUrls.length,
                        (i) => _buildImage(i, swipeDuration, imgSize)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(int index, Duration swipeDuration, Size imgSize) {
    // var
    final bool selected = index == _index;
    final String imgUrl = widget.photoUrls[index]['urlImage'];
    final String text0 = widget.photoUrls[index]['text0'];
    final String text1 = widget.photoUrls[index]['text1'];
    const TextStyle text1Style = TextStyle(
        color: Colors.white70, fontSize: 24, fontWeight: FontWeight.bold);
    const TextStyle text2Style = TextStyle(color: Colors.white70);
    const LinearGradient linearGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [
          0.0,
          0.3,
        ],
        colors: [
          Colors.black26,
          Colors.transparent
        ]);

    return MergeSemantics(
      child: Semantics(
        focused: selected,
        image: true,
        liveRegion: selected,
        onIncrease: () => _handleImageTapped(_index + 1),
        onDecrease: () => _handleImageTapped(_index - 1),
        child: InkWell(
          onTap: (() {
            _handleImageTapped(index);
          }),
          // ClipRRect : Un widget que recorta a su hijo usando un rectángulo redondeado.
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: imgSize.width,
              height: imgSize.height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  //  TweenAnimationBuilder : Creador de widgets que anima una propiedad de un widget a un valor de destino cada vez que cambia el valor de destino
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    tween: Tween(begin: 1, end: selected ? 1 : 1.20),
                    builder: (_, value, child) => Transform.scale(
                        scale: selected ? value : value, child: child),
                    // Hero : animación de transición entre pantallas
                    child: Hero(
                      tag: 'imageHero',
                      // CachedNetworkImage : mostrar imágenes de Internet y guardarlas en el directorio de caché.
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: imgUrl,
                        placeholder: (context, url) => Container(
                            color: Colors.grey.shade900,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.grey.withOpacity(0.3)))),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  // color de relleno degradado
                  Container(
                      decoration:
                          const BoxDecoration(gradient: linearGradient)),
                  // Text : nombre de la provincia
                  selected
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(text0, style: text1Style)
                                .animate()
                                .fadeIn(duration: 1000.ms),
                          ),
                        )
                      : Container(),
                  // Text : ubicación
                  selected
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color: Colors.black54,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(text1, style: text2Style),
                              ),
                            ).animate().fadeIn(duration: 1000.ms),
                          ),
                        )
                      : Container(),
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      color: selected ? null : Colors.black45)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// DETECTA EL DESLIZAMIENTO PARA CAMBIAR EL ÍNDICE
class EightWaySwipeDetector extends StatefulWidget {
  const EightWaySwipeDetector(
      {super.key,
      required this.child,
      this.threshold = 50,
      required this.onSwipe});

  // var
  final Widget child;
  final double threshold;
  final void Function(Offset dir)? onSwipe;

  @override
  State<EightWaySwipeDetector> createState() => _EightWaySwipeDetectorState();
}

class _EightWaySwipeDetectorState extends State<EightWaySwipeDetector> {
  // Offset : representación de una coordenada xy desde un punto de origen
  Offset _startPos = Offset.zero;
  Offset _endPos = Offset.zero;

  bool _isSwiping = false; // ¿Se está deslizando?

  void _resetSwipe() {
    _startPos = _endPos = Offset.zero;
    _isSwiping = false;
  }

  void _maybeTriggerSwipe() {
    if (_isSwiping == false) return;

    Offset moveDelta = _endPos - _startPos;
    final distance = moveDelta.distance;

    if (distance >= max(widget.threshold, 1)) {
      moveDelta /= distance;

      Offset dir =
          Offset(moveDelta.dx.roundToDouble(), moveDelta.dy.roundToDouble());
      widget.onSwipe?.call(dir);
      _resetSwipe();
    }
  }

  void _handleSwipeStart(d) {
    // Manejar Swipe Start

    _isSwiping = true; // ¿Se está deslizando?
    _startPos =
        _endPos = d.localPosition; // representación de una coordenada xy
  }

  void _handleSwipeUpdate(d) {
    _endPos = d.localPosition; // representación de una coordenada xy
    _maybeTriggerSwipe();
  }

  void _handleSwipeEnd(d) {
    _maybeTriggerSwipe();
    _resetSwipe();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: _handleSwipeStart,
        onPanUpdate: _handleSwipeUpdate,
        onPanCancel: _resetSwipe,
        onPanEnd: _handleSwipeEnd,
        child: widget.child);
  }
}
