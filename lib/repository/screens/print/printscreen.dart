import 'package:flutter/material.dart';
import 'package:blinkit/repository/widgets/uihelper.dart';

class PrintScreen extends StatelessWidget {
  PrintScreen({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFBF0CE),
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
                _buildProfileButton(),
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

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildPrintStoreHeader(),
          const SizedBox(height: 32),
          _buildDocumentCard(),
        ],
      ),
    );
  }

  Widget _buildPrintStoreHeader() {
    return Column(
      children: [
        UiHelper.CustomText(
          text: "Print Store",
          color: Colors.black,
          fontSize: 32,
          fontweight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        UiHelper.CustomText(
          text: "Blinkit ensures secure prints at every stage",
          color: const Color(0XFF9C9C9C),
          fontSize: 16,
          fontweight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildDocumentCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UiHelper.CustomText(
                  text: "Documents",
                  color: Colors.black,
                  fontSize: 20,
                  fontweight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                _buildFeatureRow("Price starting at rs 3/page"),
                _buildFeatureRow("Paper quality: 70 GSM"),
                _buildFeatureRow("Single side prints"),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF27AF34),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.upload_file, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "Upload Files",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Hero(
              tag: 'document_image',
              child: UiHelper.CustomImage(img: "document.png"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          UiHelper.CustomImage(img: "star.png"),
          const SizedBox(width: 12),
          Expanded(
            child: UiHelper.CustomText(
              text: text,
              color: const Color(0XFF9C9C9C),
              fontSize: 15,
              fontweight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}