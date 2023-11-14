import 'package:badges/badges.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/product/product.dart';
import 'package:digimartbox/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:digimartbox/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digimartbox/src/models/category/category.dart';

class ClientProductsListPage extends StatelessWidget {
  ClientProductsListPage({Key? key}) : super(key: key);
  final ClientProductsListController clientController = Get.put(ClientProductsListController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: clientController.getCategories(),
      builder: (context, AsyncSnapshot<List<Category>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return buildTabbedScreen(snapshot.data!, context);
        }
      },
    );
  }

  DefaultTabController buildTabbedScreen(
      List<Category> categories, BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: AppBar(
            flexibleSpace: SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                margin: const EdgeInsets.only(top: 7),
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    _textFieldSearch(context),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => clientController.goToOrderCreate(),
                      child: Badge(
                        badgeColor: Colors.red,
                        padding: const EdgeInsets.all(7),
                        badgeContent: Obx(
                          () => Text(
                            clientController.quantityProducts.value.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        child: InkWell(
                          onTap: () => clientController.goToOrderCreate(),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              onTap: (index) => clientController.selectedTabIndex.value = index,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              isScrollable: true,
              indicatorColor: Constants.colorGreenPrimary,
              unselectedLabelColor: Colors.white,
              tabs: List<Widget>.generate(categories.length, (index) {
                return Tab(
                  child: Text(categories[index].name ?? '-'),
                );
              }),
            ),
          ),
        ),
        body: Container(
          color: Constants.colorGreyBackground,
          child: Obx(() {
            final selectedCategory =
                categories[clientController.selectedTabIndex.value];
            return FutureBuilder<List<Product>>(
              future:
                  clientController.getProducts(selectedCategory.idCategory!),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      return itemWidget(snapshot.data![index], context);
                    },
                  );
                } else {
                  return NoDataWidget(textMessage: 'No hay productos');
                }
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _textFieldSearch(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: TextField(
          decoration: InputDecoration(
              hintText: 'Buscar producto',
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              hintStyle: const TextStyle(fontSize: 17, color: Colors.grey),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.all(12)),
        ),
      ),
    );
  }

  Widget itemWidget(Product product, BuildContext context) {
    return GestureDetector(
      onTap: () => clientController.openBottomSheet(context, product),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            InkWell(
              onTap: () => clientController.openBottomSheet(context, product),
              child: Container(
                margin: const EdgeInsets.all(8),
                child: Image.network(
                  product.image,
                  height: 120,
                  width: 120,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                product.name,
                maxLines: 2,
                style: TextStyle(
                    fontSize: 15,
                    color: Constants.colorSecondary,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'L. ${product.price.toString()}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                  Icon(
                    Icons.shopping_cart_checkout,
                    color: Constants.colorSecondary,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
