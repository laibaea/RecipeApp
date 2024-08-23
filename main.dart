import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'db/database_helper.dart';
import 'models/recipe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecipeProvider(),
      child: MaterialApp(
        title: 'Recipe App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: RecipeListScreen(),
      ),
    );
  }
}

class RecipeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  Future<void> fetchRecipes() async {
    _recipes = await _apiService.fetchRecipes();
    notifyListeners();
  }

  Future<void> saveRecipe(Recipe recipe) async {
    await _dbHelper.insert(recipe);
    notifyListeners();
  }

  Future<void> deleteRecipe(String id) async {
    await _dbHelper.delete(id);
    notifyListeners();
  }
}

class RecipeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipes')),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: provider.fetchRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListView.builder(
                  itemCount: provider.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = provider.recipes[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.network(recipe.imageUrl),
                        title: Text(recipe.title),
                        trailing: IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () {
                            provider.saveRecipe(recipe);
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
