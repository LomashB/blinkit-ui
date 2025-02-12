import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

// Models
class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
}

// Provider with improved state management
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(String id, String name, double price, String image) {
    final existingItemIndex = _items.indexWhere((item) => item.id == id);

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
    } else {
      _items.add(CartItem(
        id: id,
        name: name,
        price: price,
        quantity: 1,
        image: image,
      ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    final existingItemIndex = _items.indexWhere((item) => item.id == id);
    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        _items[existingItemIndex].quantity -= 1;
      } else {
        _items.removeAt(existingItemIndex);
      }
      notifyListeners();
    }
  }

  void updateQuantity(String id, int quantity) {
    final existingItemIndex = _items.indexWhere((item) => item.id == id);
    if (existingItemIndex >= 0) {
      if (quantity <= 0) {
        _items.removeAt(existingItemIndex);
      } else {
        _items[existingItemIndex].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

// Enhanced UI Helper
class UiHelper {
  static Widget CustomText({
    required String text,
    required Color color,
    required double fontSize,
    required FontWeight fontweight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: fontSize,
        fontWeight: fontweight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  static Widget CustomImage({
    required String img,
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Image.asset(
      'assets/images/$img',
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Icon(Icons.image_not_supported, color: Colors.grey),
        );
      },
    );
  }

  static Widget ShimmerLoading({
    required double width,
    required double height,
    double borderRadius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// Enhanced Home Screen
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  bool _isScrolled = false;

  // Enhanced Sample Data
  final List<Map<String, dynamic>> banners = [
    {
      "id": "1",
      "image": "Blinkit Onboarding Screen.png",
      "title": "Mega Diwali Sale",
      "subtitle": "Up to 50% off on fresh fruits",
    },
    {
      "id": "2",
      "image": "image 1 (1).png",
      "title": "Fresh Arrivals",
      "subtitle": "Organic vegetables just arrived",
    },
    {
      "id": "3",
      "image": "Blinkit Onboarding Screen.png",
      "title": "Mega Christmas Sale",
      "subtitle": "Up to 50% off on fresh fruits",
    },
    {
      "id": "4",
      "image": "image 1 (1).png",
      "title": "New Arrivals",
      "subtitle": "Organic vegetables just arrived",
    },
  ];

  final List<Map<String, dynamic>> categories = [
    {
      "id": "1",
      "image": "image 24.png",
      "name": "Fruits & Vegetables",
      "color": Color(0xFFE8F5E9),
      "items": "150+ items"
    },
    {
      "id": "2",
      "image": "image 25.png",
      "name": "Dairy & Breakfast",
      "color": Color(0xFFF3E5F5),
      "items": "120+ items"
    },
    {
      "id": "3",
      "image": "image 36.png",
      "name": "Snacks & Munchies",
      "color": Color(0xFFFFF3E0),
      "items": "100+ items"
    },
    {
      "id": "4",
      "image": "image 37.png",
      "name": "Beverages",
      "color": Color(0xFFE3F2FD),
      "items": "70+ items"
    },
    {
      "id": "5",
      "image": "image 41.png",
      "name": "Personal Care",
      "color": Color(0xFFE8F5E9),
      "items": "110+ items"
    },
    {
      "id": "6",
      "image": "image 42.png",
      "name": "Pet Care",
      "color": Color(0xFFF3E5F5),
      "items": "10+ items"
    },
    {
      "id": "7",
      "image": "image 43.png",
      "name": "Hygiene Store",
      "color": Color(0xFFFFF3E0),
      "items": "50+ items"
    },
    {
      "id": "8",
      "image": "image 45 (1).png",
      "name": "Fresh juices",
      "color": Color(0xFFE3F2FD),
      "items": "10+ items"
    },
  ];

  final List<Map<String, dynamic>> products = [
    {
      "id": "1",
      "name": "Fresh Red Apple",
      "image": "image 40.png",
      "price": 120.0,
      "unit": "1 kg",
      "category": "Fruits",
      "rating": 4.5,
      "reviews": 128,
      "isOrganic": false
    },
    {
      "id": "2",
      "name": "Organic Banana",
      "image": "image 57.png",
      "price": 60.0,
      "unit": "12 pcs",
      "category": "Fruits",
      "rating": 4.3,
      "reviews": 96,
      "isOrganic": true
    },
    {
      "id": "3",
      "name": "Icecream vanila",
      "image": "image 24.png",
      "price": 220.0,
      "unit": "1 kg",
      "category": "Fruits",
      "rating": 4.5,
      "reviews": 128,
      "isOrganic": false
    },
    {
      "id": "4",
      "name": "4 seater sofa",
      "image": "image 39.png",
      "price": 11000.0,
      "unit": "1pcs",
      "category": "seat",
      "rating": 4.3,
      "reviews": 96,
      "isOrganic": false
    },
    {
      "id": "5",
      "name": "Diya for Diwali",
      "image": "image 50.png",
      "price": 120.0,
      "unit": "1 kg",
      "category": "Fruits",
      "rating": 4.5,
      "reviews": 128,
      "isOrganic": true
    },
    {
      "id": "6",
      "name": "Organic Potato",
      "image": "image 57.png",
      "price": 60.0,
      "unit": "12 pcs",
      "category": "Fruits",
      "rating": 4.3,
      "reviews": 96,
      "isOrganic": true
    },
    {
      "id": "7",
      "name": "Aashirwad aata",
      "image": "image 42.png",
      "price": 220.0,
      "unit": "1 kg",
      "category": "Fruits",
      "rating": 4.5,
      "reviews": 128,
      "isOrganic": false
    },
    {
      "id": "8",
      "name": "Banana chips",
      "image": "image 31.png",
      "price": 110.0,
      "unit": "12 pcs",
      "category": "Fruits",
      "rating": 4.3,
      "reviews": 96,
      "isOrganic": true
    },
  ];


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 0;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                // Implement refresh logic
                await Future.delayed(Duration(seconds: 1));
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildAppBar(screenSize),
                  _buildSearchBar(),
                  _buildBanners(),
                  _buildCategories(),
                  _buildSectionTitle('Popular Products'),
                  _buildPopularProducts(cart),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: padding.bottom + (cart.itemCount > 0 ? 80 : 16),
                    ),
                  ),
                ],
              ),
            ),
            if (cart.itemCount > 0) _buildCartButton(cart),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(Size screenSize) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Color(0XFFEC0505),
      elevation: _isScrolled ? 4 : 0,
      flexibleSpace: FlexibleSpaceBar(
        title: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _isScrolled ? 1.0 : 0.0,
          child: Text(
            'Blinkit',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        background: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0XFFEC0505),
                Color(0XFFEC0505).withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Delivery to:',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Home',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Delivery in 16 minutes',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.person_outline),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search for products...',
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey[400],
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[400],
              ),
              suffixIcon: Icon(
                Icons.mic_none_outlined,
                color: Colors.grey[400],
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanners() {
    return SliverToBoxAdapter(
      child: Container(
        height: 180,
        child: PageView.builder(
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('assets/images/${banner["image"]}'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banner["title"],
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      banner["subtitle"],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final category = categories[index];
            return _buildCategoryCard(category);
          },
          childCount: categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
        decoration: BoxDecoration(
        color: category["color"],
        borderRadius: BorderRadius.circular(16),
    boxShadow: [
    BoxShadow(color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    ],
        ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.2,
              child: Hero(
                tag: 'category-${category["id"]}',
                child: UiHelper.CustomImage(
                  img: category["image"],
                  width: 120,
                  height: 120,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category["name"],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category["items"],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: GoogleFonts.poppins(
                  color: Color(0XFFEC0505),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularProducts(CartProvider cart) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final product = products[index];
            return _buildProductCard(product, cart);
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, CartProvider cart) {
    final isInCart = cart.items.any((item) => item.id == product["id"]);
    final cartItem = isInCart
        ? cart.items.firstWhere((item) => item.id == product["id"])
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Hero(
                  tag: 'product-${product["id"]}',
                  child: UiHelper.CustomImage(
                    img: product["image"],
                    height: 120,
                    width: double.infinity,
                  ),
                ),
              ),
              if (product["isOrganic"])
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Organic',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product["name"],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${product["rating"]}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '(${product["reviews"]})',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${product["price"]}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFFEC0505),
                          ),
                        ),
                        Text(
                          product["unit"],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    if (!isInCart)
                      ElevatedButton(
                        onPressed: () {
                          cart.addItem(
                            product["id"],
                            product["name"],
                            product["price"],
                            product["image"],
                          );
                          Fluttertoast.showToast(
                            msg: "Added to cart!",
                            backgroundColor: Colors.black87,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFEC0505),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          'ADD',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFEC0505),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildQuantityButton(
                              icon: Icons.remove,
                              onPressed: () => cart.removeItem(product["id"]),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${cartItem!.quantity}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildQuantityButton(
                              icon: Icons.add,
                              onPressed: () => cart.addItem(
                                product["id"],
                                product["name"],
                                product["price"],
                                product["image"],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCartButton(CartProvider cart) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        color: Color(0XFFEC0505),
        child: InkWell(
          onTap: () => _showCartBottomSheet(context, cart),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${cart.itemCount} ${cart.itemCount == 1 ? 'item' : 'items'}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Tap to view cart',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '₹${cart.totalAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCartBottomSheet(BuildContext context, CartProvider cart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CartBottomSheet(cart: cart),
    );
  }
}

// Enhanced Cart Bottom Sheet
class CartBottomSheet extends StatelessWidget {
  final CartProvider cart;

  const CartBottomSheet({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: cart.items.isEmpty
                    ? _buildEmptyCart()
                    : _buildCartItems(cart),
              ),
              if (cart.items.isNotEmpty) _buildCheckoutSection(cart),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Cart',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Color(0XFFEC0505).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cart.itemCount} items',
                  style: GoogleFonts.poppins(
                    color: Color(0XFFEC0505),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon(
        Icons.shopping_cart_outlined,
        size: 80,
        color: Colors.grey[300],
    ),
    SizedBox(height: 24),
    Text(
    'Your cart is empty',
    style: GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey[800],
    ),
    ),
    SizedBox(height: 8),
          Text(
            'Add items to begin shopping',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => {

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0XFFEC0505),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: Text(
              'Start Shopping',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        ),
    );
  }

  Widget _buildCartItems(CartProvider cart) {
    return ListView.builder(
      itemCount: cart.items.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 28,
            ),
          ),
          onDismissed: (direction) {
            cart.updateQuantity(item.id, 0);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item.name} removed from cart'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.addItem(
                      item.id,
                      item.name,
                      item.price,
                      item.image,
                    );
                  },
                ),
              ),
            );
          },
          child: CartItemCard(item: item, cart: cart),
        );
      },
    );
  }

  Widget _buildCheckoutSection(CartProvider cart) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '₹${cart.totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Fee',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '₹40.00',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${(cart.totalAmount + 40).toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFFEC0505),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Fluttertoast.showToast(
                msg: "Order placed successfully!",
                backgroundColor: Colors.green,
              );
              cart.clearCart();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0XFFEC0505),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined),
                SizedBox(width: 8),
                Text(
                  'Proceed to Checkout',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartProvider cart;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Hero(
              tag: 'cart-${item.id}',
              child: UiHelper.CustomImage(
                img: item.image,
                width: 80,
                height: 80,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '₹${item.price}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFFEC0505),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0XFFEC0505),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white, size: 20),
                  onPressed: () => cart.removeItem(item.id),
                ),
                Container(
                  constraints: BoxConstraints(minWidth: 30),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.quantity}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: () => cart.addItem(
                    item.id,
                    item.name,
                    item.price,
                    item.image,
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

// Main App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: MaterialApp(
        title: 'Blinkit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0XFFEC0505),
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: Color(0XFFEC0505),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}