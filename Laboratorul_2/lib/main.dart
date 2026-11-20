import 'package:flutter/material.dart';

void main() => runApp(const GemStoreApp());

const _teal = Color(0xFF508A7B);
const _divider = Divider(color: Color(0xFFEEEEEE), height: 40, thickness: 1);

class GemStoreApp extends StatelessWidget {
  const GemStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GemStore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// --- MODEL ȘI HELPERI COMUNI ---
class Product {
  final String name;
  final double price;
  final String imageUrl;

  const Product(this.name, this.price, this.imageUrl);
}

void openDetails(BuildContext context, String name, double price, String imageUrl) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ProductDetailsPage(product: Product(name, price, imageUrl))),
  );
}

Widget _price(double price, [double size = 14]) => Text(
  "\$ ${price.toStringAsFixed(2)}",
  style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
);

Widget _stars(double size) =>
    Row(children: List.generate(5, (_) => Icon(Icons.star, color: _teal, size: size)));

// --- PAGINA PRINCIPALĂ ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () {}),
        title: const Text("GemStore"),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Categorii
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _categoryIcon(Icons.female, "Women", true),
                  _categoryIcon(Icons.male, "Men", false),
                  _categoryIcon(Icons.watch, "Accessories", false),
                  _categoryIcon(Icons.face, "Beauty", false),
                ],
              ),
            ),

            _mainBanner(),

            // Feature Products
            _sectionHeader("Feature Products"),
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _productCard(context, "Turtleneck Sweater", 39.99, "assets/images/TurtleneckSweater.png"),
                  _productCard(context, "Long Sleeve Dress", 45.00, "assets/images/LongSleeveDress.png"),
                  _productCard(context, "Sportwear Set", 80.00, "assets/images/TurtleneckSweater.png"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _promoBanner(
                title: "HANG OUT\n& PARTY",
                subtitle: "NEW COLLECTION",
                imageUrl: "assets/images/HangOut.png",
                large: true,
              ),
            ),

            // Recommended
            _sectionHeader("Recommended"),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _smallProductCard(context, "White fashion hoodie", 29.0, "assets/images/Whitefashionhoodie.png"),
                  _smallProductCard(context, "Cotton T-Shirt", 30.0, "assets/images/CottonT-Shirt.png"),
                ],
              ),
            ),

            // Top Collection
            _sectionHeader("Top Collection"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _promoBanner(
                    title: "FOR SLIM\n& BEAUTY",
                    subtitle: "Sale up to 40%",
                    imageUrl: "assets/images/model_yellow.png",
                  ),
                  const SizedBox(height: 16),
                  _promoBanner(
                    title: "Most sexy\n& fabulous\ndesign",
                    subtitle: "Summer Collection 2021",
                    imageUrl: "assets/images/model_brown.png",
                    bold: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _squareBanner("T-Shirts", "The\nOffice\nLife", "assets/images/tshirts_bg.png", true),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _squareBanner("Dresses", "Elegant\nDesign", "assets/images/dresses_bg.png", false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, color: Colors.black), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.grey), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined, color: Colors.grey), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline, color: Colors.grey), label: ""),
        ],
      ),
    );
  }

  // --- WIDGETURI HOME ---

  Widget _categoryIcon(IconData icon, String label, bool selected) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? const Color(0xFF333333) : Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Icon(icon, color: selected ? Colors.white : Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.grey,
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Show all", style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _mainBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(image: AssetImage("assets/images/Autumn.png"), fit: BoxFit.cover),
      ),
      child: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.5)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: const Text(
          "Autumn\nCollection\n2021",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Bannerul alb cu text în stânga și model pe cerc gri în dreapta
  /// (înlocuiește vechile _buildHangOutBanner și _buildDetailedBanner).
  Widget _promoBanner({
    required String title,
    required String subtitle,
    required String imageUrl,
    bool large = false,
    bool bold = false,
  }) {
    return Container(
      height: large ? 158 : 145,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            width: large ? 170 : 150,
            top: 0,
            bottom: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: large ? 140 : 120,
                  height: large ? 140 : 120,
                  decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                ),
                Positioned(
                  bottom: 0,
                  child: Image.asset(imageUrl, height: large ? 150 : 135, fit: BoxFit.contain),
                )
              ],
            ),
          ),
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 1.5, height: 14, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: large ? 24 : 20,
                    fontWeight: bold ? FontWeight.bold : FontWeight.w300,
                    height: 1.2,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _productCard(BuildContext context, String name, double price, String imageUrl) {
    return GestureDetector(
      onTap: () => openDetails(context, name, price, imageUrl),
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imageUrl, height: 160, width: 140, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            _price(price),
          ],
        ),
      ),
    );
  }

  Widget _smallProductCard(BuildContext context, String name, double price, String imageUrl) {
    return GestureDetector(
      onTap: () => openDetails(context, name, price, imageUrl),
      child: Container(
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 2),
                  _price(price),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _squareBanner(String category, String description, String imageUrl, bool imageLeft) {
    return Container(
      height: 170,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Positioned(
            left: imageLeft ? -10 : null,
            right: imageLeft ? null : -15,
            top: 0,
            bottom: 0,
            child: Image.asset(imageUrl, fit: BoxFit.contain, width: 90),
          ),
          Positioned(
            left: imageLeft ? null : 16,
            right: imageLeft ? 16 : null,
            top: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 12),
                Text(description, style: const TextStyle(fontSize: 18, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- PAGINA DE DETALII ---
class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(children: [_imageHeader(), _detailsContent(context)]),
          ),

          // Butoane back / favorite
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _floatingButton(Icons.arrow_back_ios_new, () => Navigator.pop(context), Colors.black87),
                _floatingButton(Icons.favorite, () {}, Colors.redAccent),
              ],
            ),
          ),

          // "Add to Cart" fixat jos
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF333333),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  label: const Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETURI DETALII ---

  Widget _floatingButton(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _imageHeader() {
    return SizedBox(
      height: 480,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 320,
            height: 320,
            decoration: const BoxDecoration(color: Color(0xFFF6EFEA), shape: BoxShape.circle),
          ),
          Positioned(
            bottom: 20,
            child: Image.asset(product.imageUrl, height: 400, fit: BoxFit.contain),
          ),
          Positioned(
            bottom: 30,
            child: Row(
              children: [
                _dot(true),
                const SizedBox(width: 8),
                _dot(false),
                const SizedBox(width: 8),
                _dot(false),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _dot(bool selected) {
    if (!selected) {
      return Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
      );
    }
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
      child: Center(
        child: Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        ),
      ),
    );
  }

  Widget _detailsContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titlu și preț
          Row(
            children: [
              Expanded(
                child: Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              _price(product.price, 26),
            ],
          ),
          const SizedBox(height: 12),

          // Stele
          Row(
            children: [
              _stars(20),
              const SizedBox(width: 8),
              const Text("(83)", style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          _divider,

          // Culoare și mărime
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _colorSelector()),
              Expanded(child: _sizeSelector()),
            ],
          ),
          _divider,

          // Descriere
          _sectionTitle("Description"),
          const SizedBox(height: 16),
          const Text(
            "Sportswear is no longer under culture, it is no longer indie or cobbled together as it once was. Sport is fashion today. The top is oversized in fit and style, may need to size down.",
            style: TextStyle(color: Colors.black54, height: 1.6),
          ),
          _divider,

          // Recenzii
          _sectionTitle("Reviews"),
          const SizedBox(height: 24),
          _reviewStatistics(),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("47 Reviews", style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  Text(
                    "WRITE A REVIEW",
                    style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.edit, color: Colors.grey, size: 14),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          _userReview("Jennifer Rose", "5m ago", "I love it. Awesome customer service!!", "assets/images/avatar1.png"),
          const SizedBox(height: 24),
          _userReview("Kelly Rihana", "9m ago", "I'm very happy with order, it was delivered on time.", "assets/images/avatar2.png"),
          _divider,

          // Produse similare
          _sectionTitle("Similar Product"),
          const SizedBox(height: 20),
          SizedBox(
            height: 230,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _similarProductCard(context, "Rise Crop Hoodie", 43.0, "assets/images/RiseCropHoodie.png"),
                _similarProductCard(context, "Gym Crop Top", 39.99, "assets/images/GymCropTop.png"),
                _similarProductCard(context, "Sport Sweater", 47.99, "assets/images/SportSweater.png"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _colorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Color", style: TextStyle(color: Colors.grey, fontSize: 15)),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: const CircleAvatar(backgroundColor: Color(0xFFDABCA7), radius: 10),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(backgroundColor: Colors.black, radius: 12),
            const SizedBox(width: 12),
            const CircleAvatar(backgroundColor: Color(0xFFD67776), radius: 12),
          ],
        )
      ],
    );
  }

  Widget _sizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Size", style: TextStyle(color: Colors.grey, fontSize: 15)),
        const SizedBox(height: 12),
        Row(children: [_sizeIcon("S", false), _sizeIcon("M", false), _sizeIcon("L", true)]),
      ],
    );
  }

  Widget _sizeIcon(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? const Color(0xFF4A4A4A) : Colors.white,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey[400],
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Icon(Icons.keyboard_arrow_down),
      ],
    );
  }

  Widget _reviewStatistics() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text("4.9", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text("OUT OF 5", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            _stars(16),
            const SizedBox(height: 4),
            const Text("83 ratings", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            _ratingBar("5", 0.80),
            _ratingBar("4", 0.12),
            _ratingBar("3", 0.05),
            _ratingBar("2", 0.03),
            _ratingBar("1", 0.00),
          ],
        )
      ],
    );
  }

  Widget _ratingBar(String level, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(level, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.star, color: _teal, size: 12),
          const SizedBox(width: 8),
          Container(
            width: 100,
            height: 4,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(2)),
            child: Container(
              width: 100 * value,
              decoration: BoxDecoration(color: _teal, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 25,
            child: Text(
              "${(value * 100).round()}%",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }

  Widget _userReview(String name, String time, String text, String avatar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 20, backgroundColor: Colors.grey[200], backgroundImage: AssetImage(avatar)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                _stars(14),
              ],
            ),
            const Spacer(),
            Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        Text(text, style: const TextStyle(color: Colors.black54, height: 1.5)),
      ],
    );
  }

  Widget _similarProductCard(BuildContext context, String name, double price, String imageUrl) {
    return GestureDetector(
      onTap: () => openDetails(context, name, price, imageUrl),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: const Color(0xFFF6F6F6),
                height: 170,
                width: 130,
                child: Image.asset(imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            _price(price),
          ],
        ),
      ),
    );
  }
}