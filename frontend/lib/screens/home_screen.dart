import 'package:flutter/material.dart';
import 'package:project_crud/providers/product_provider.dart';
import 'package:project_crud/screens/add_screen.dart';
import 'package:project_crud/utils/helper.dart';
import 'package:project_crud/widgets/my_button.dart';
import 'package:project_crud/widgets/product_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProductProvider provider;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoadingMore) {
        await provider.loadMoreProducts(context);
      }
    });
    provider = context.read<ProductProvider>();
    Future.microtask(() {
      provider.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          MyButton(
            label: 'Save as PDF',
            onPressed: () async {
              await Helper.exportToPDF(provider.products, context);
            },
            color: Colors.blue,
            width: 100,
          ),
          const SizedBox(width: 5),
          MyButton(
            label: 'Add',
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()),
              );
            },
            color: Colors.blue,
            icon: Icon(Icons.add, color: Colors.white),
            width: 70,
          ),
          const SizedBox(width: 10),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              children: [
                TextField(
                  controller: provider.textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter product name',
                  ),
                  onChanged: (value) {
                    provider.deboucerSearch(value);
                  },
                ),
                Row(
                  spacing: 10,
                  children: [
                    PopupMenuButton(
                      child: Text(
                        'Sort : ${provider.sort}',
                        style: TextStyle(fontSize: 16),
                      ),
                      itemBuilder:
                          (context) =>
                              ['ID', 'Price', 'Stock']
                                  .map(
                                    (sort) => PopupMenuItem(
                                      value: sort,
                                      child: Text(sort),
                                      onTap: () async {
                                        provider.setSort = sort;
                                        await provider.getProducts();
                                      },
                                    ),
                                  )
                                  .toList(),
                    ),
                    PopupMenuButton(
                      child: Text(
                        'Order : ${provider.order}',
                        style: TextStyle(fontSize: 16),
                      ),
                      itemBuilder:
                          (context) =>
                              ['ASC', 'DESC']
                                  .map(
                                    (order) => PopupMenuItem(
                                      value: order,
                                      child: Text(order),
                                      onTap: () async {
                                        provider.setOrder = order;
                                        await provider.getProducts();
                                      },
                                    ),
                                  )
                                  .toList(),
                    ),
                    const Spacer(),
                    Text(
                      'Total : ${provider.products.length} - Page : ${provider.currentPage}',
                    ),
                  ],
                ),
                if (provider.isLoading) LinearProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await provider.getProducts();
        },
        child:
            provider.products.isNotEmpty
                ? !provider.isLoading
                    ? Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: provider.products.length,
                            itemBuilder:
                                (context, index) => ProductWidget(
                                  product: provider.products[index],
                                ),
                          ),
                        ),
                        if (provider.isLoadingMore)
                          Center(child: CircularProgressIndicator.adaptive()),
                      ],
                    )
                    : Center(child: CircularProgressIndicator.adaptive())
                : Center(
                  child: Text('No Products', style: TextStyle(fontSize: 20)),
                ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
