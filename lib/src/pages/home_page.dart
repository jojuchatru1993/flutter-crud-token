import 'package:flutter/material.dart';
import 'package:form/src/models/product_model.dart';
import 'package:form/src/providers/products_provider.dart';

// import 'package:form/src/blocs/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productsProvider = new ProductsProviders();

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _createList(),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'product')
          .then((value) => setState(() {})),
    );
  }

  Widget _createList() {
    return FutureBuilder(
        future: productsProvider.getProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data;
            return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, i) => _createItem(context, products[i]));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _createItem(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        productsProvider.deleteProduct(product.id);
      },
      child: Card(
          child: Column(
        children: [
          (product.photoUrl == null)
              ? Image(image: AssetImage('assets/no-image.png'))
              : FadeInImage(
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(product.photoUrl),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover),
          ListTile(
            title: Text('${product.title} - ${product.value}'),
            subtitle: Text(product.id),
            onTap: () =>
                Navigator.pushNamed(context, 'product', arguments: product)
                    .then((value) => setState(() {})),
          )
        ],
      )),
    );
  }
}
