import 'package:flutter/material.dart';
import 'package:blinkit/repository/widgets/uihelper.dart';

class CartScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildBody(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
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
                GestureDetector(
                  onTap: () {
                    // Handle profile tap
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
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
                    child: const Icon(Icons.person, size: 24),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
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
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSearchBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                UiHelper.CustomImage(img: "cart.png"),
                const SizedBox(height: 24),
                UiHelper.CustomText(
                  text: "Reordering will be easy",
                  color: Colors.black,
                  fontSize: 20,
                  fontweight: FontWeight.bold,
                  fontfamily: "bold",
                ),
                const SizedBox(height: 8),
                UiHelper.CustomText(
                  text: "Items you order will show up here so you can buy them again easily.",
                  color: Colors.black54,
                  fontSize: 14,
                  fontweight: FontWeight.w500,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildBestsellersSection(),
        ],
      ),
    );
  }

  Widget _buildBestsellersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UiHelper.CustomText(
          text: "Bestsellers",
          color: Colors.black,
          fontSize: 20,
          fontweight: FontWeight.bold,
          fontfamily: "bold",
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildProductCard("milk.png"),
              _buildProductCard("potato.png"),
              _buildProductCard("tomato.png"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(String image) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 160,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: UiHelper.CustomImage(img: image),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: UiHelper.CustomButton(() {}),
          ),
        ],
      ),
    );
  }
}