import 'package:flutter/material.dart';
import 'package:blinkit/repository/widgets/uihelper.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> groceryKitchen = [
    {"img": "image 41.png", "text": "Vegetables &\nFruits"},
    {"img": "image 42.png", "text": "Atta, Dal &\nRice"},
    {"img": "image 43.png", "text": "Oil, Ghee &\nMasala"},
    {"img": "image 44 (1).png", "text": "Dairy, Bread &\nMilk"},
    {"img": "image 45 (1).png", "text": "Biscuits &\nBakery"}
  ];

  final List<Map<String, String>> secondGrocery = [
    {"img": "image 21.png", "text": "Dry Fruits &\nCereals"},
    {"img": "image 22.png", "text": "Kitchen &\nAppliances"},
    {"img": "image 23.png", "text": "Tea &\nCoffees"},
    {"img": "image 24.png", "text": "Ice Creams &\nmuch more"},
    {"img": "image 25.png", "text": "Noodles &\nPacket Food"}
  ];

  final List<Map<String, String>> snacksAndDrinks = [
    {"img": "image 31.png", "text": "Chips &\nNamkeens"},
    {"img": "image 32.png", "text": "Sweets &\nChocolates"},
    {"img": "image 33.png", "text": "Drinks &\nJuices"},
    {"img": "image 34.png", "text": "Sauces &\nSpreads"},
    {"img": "image 35.png", "text": "Beauty &\nCosmetics"}
  ];

  final List<Map<String, String>> household = [
    {"img": "image 36.png", "text": "Cleaning"},
    {"img": "image 37.png", "text": "Personal Care"},
    {"img": "image 38.png", "text": "Home Care"},
    {"img": "image 39.png", "text": "Pet Care"},
    {"img": "image 40.png", "text": "Baby Care"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),
            SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),
            SliverFillRemaining(
              child: _buildCategoryLists(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0XFFF7CB45),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UiHelper.CustomText(
                    text: "Blinkit in",
                    color: Colors.black87,
                    fontSize: 16,
                    fontweight: FontWeight.w500,
                  ),
                  const SizedBox(height: 4),
                  UiHelper.CustomText(
                    text: "16 minutes",
                    color: Colors.black,
                    fontSize: 24,
                    fontweight: FontWeight.bold,
                    fontfamily: "bold",
                  ),
                ],
              ),
              _buildProfileButton(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: UiHelper.CustomText(
                  text: "HOME - Sujal Dave, Ratanada, Jodhpur (Raj)",
                  color: Colors.black87,
                  fontSize: 14,
                  fontweight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {},
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: UiHelper.CustomTextField(controller: searchController),
    );
  }

  Widget _buildCategoryLists() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategorySection("Grocery & Kitchen", groceryKitchen),
          _buildCategorySection("More Groceries", secondGrocery),
          _buildCategorySection("Snacks & Drinks", snacksAndDrinks),
          _buildCategorySection("Household Essentials", household),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UiHelper.CustomText(
                text: title,
                color: Colors.black,
                fontSize: 18,
                fontweight: FontWeight.bold,
                fontfamily: "bold",
              ),
              TextButton(
                onPressed: () {},
                child: const Text("See All"),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) => _buildCategoryCard(items[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, String> item) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0XFFD9EBEB),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: UiHelper.CustomImage(img: item["img"]!),
              ),
            ),
          ),
          const SizedBox(height: 8),
          UiHelper.CustomText(
            text: item["text"]!,
            color: Colors.black87,
            fontSize: 12,
            fontweight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}