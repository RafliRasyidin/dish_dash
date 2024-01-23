// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_dash_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorDishDashDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DishDashDatabaseBuilder databaseBuilder(String name) =>
      _$DishDashDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DishDashDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$DishDashDatabaseBuilder(null);
}

class _$DishDashDatabaseBuilder {
  _$DishDashDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$DishDashDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$DishDashDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<DishDashDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$DishDashDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$DishDashDatabase extends DishDashDatabase {
  _$DishDashDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FavoriteDao? _favoriteDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `favorite` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `city` TEXT NOT NULL, `address` TEXT NOT NULL, `pictureId` TEXT NOT NULL, `rating` REAL NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FavoriteDao get favoriteDao {
    return _favoriteDaoInstance ??= _$FavoriteDao(database, changeListener);
  }
}

class _$FavoriteDao extends FavoriteDao {
  _$FavoriteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _favoriteInsertionAdapter = InsertionAdapter(
            database,
            'favorite',
            (Favorite item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'city': item.city,
                  'address': item.address,
                  'pictureId': item.pictureId,
                  'rating': item.rating
                }),
        _favoriteDeletionAdapter = DeletionAdapter(
            database,
            'favorite',
            ['id'],
            (Favorite item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'city': item.city,
                  'address': item.address,
                  'pictureId': item.pictureId,
                  'rating': item.rating
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Favorite> _favoriteInsertionAdapter;

  final DeletionAdapter<Favorite> _favoriteDeletionAdapter;

  @override
  Future<List<Favorite>> getFavorites() async {
    return _queryAdapter.queryList('SELECT * FROM favorite',
        mapper: (Map<String, Object?> row) => Favorite(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String,
            city: row['city'] as String,
            address: row['address'] as String,
            pictureId: row['pictureId'] as String,
            rating: row['rating'] as double));
  }

  @override
  Future<Favorite?> getFavoriteById(String id) async {
    return _queryAdapter.query('SELECT * FROM favorite WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Favorite(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String,
            city: row['city'] as String,
            address: row['address'] as String,
            pictureId: row['pictureId'] as String,
            rating: row['rating'] as double),
        arguments: [id]);
  }

  @override
  Future<List<Favorite>> searchFavorite(String search) async {
    return _queryAdapter.queryList(
        'SELECT * FROM favorite WHERE name LIKE \'%\'||?1||\'%\'',
        mapper: (Map<String, Object?> row) => Favorite(
            id: row['id'] as String,
            name: row['name'] as String,
            description: row['description'] as String,
            city: row['city'] as String,
            address: row['address'] as String,
            pictureId: row['pictureId'] as String,
            rating: row['rating'] as double),
        arguments: [search]);
  }

  @override
  Future<void> insertFavorite(Favorite favorite) async {
    await _favoriteInsertionAdapter.insert(favorite, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFavorite(Favorite favorite) async {
    await _favoriteDeletionAdapter.delete(favorite);
  }
}
