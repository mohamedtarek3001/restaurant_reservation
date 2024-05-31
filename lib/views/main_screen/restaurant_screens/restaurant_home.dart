// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_reservation/business_logic/login_cubit.dart';
import 'package:restaurant_reservation/business_logic/refresh_token_cubit.dart';
import 'package:restaurant_reservation/business_logic/restaurant_cubit.dart';
import 'package:restaurant_reservation/models/desert_model.dart';
import 'package:restaurant_reservation/models/menus_model.dart';
import 'package:restaurant_reservation/models/restaurant_desert_model.dart';
import 'package:restaurant_reservation/models/restaurant_menus_model.dart';
import 'package:restaurant_reservation/models/restaurant_tables_model.dart';
import 'package:restaurant_reservation/models/tables_model.dart';
import 'package:restaurant_reservation/views/main_screen/restaurant_screens/desert_dialog_form.dart';
import 'package:restaurant_reservation/views/main_screen/restaurant_screens/menu_dialog_form.dart';
import 'package:restaurant_reservation/views/main_screen/restaurant_screens/tables_dialog_form.dart';

class RestaurantHome extends StatelessWidget {
  const RestaurantHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      child: SingleChildScrollView(
        child: BlocBuilder<RestaurantCubit, RestaurantState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: _buildSectionTitle(
                  'Tables',
                  context,
                  () async {
                    TablesModel? Table = await showDialog<TablesModel>(
                      context: context,
                      builder: (BuildContext context) {
                        return TableFormDialog(table: TablesModel(restaurant: BlocProvider.of<LoginCubit>(context).RestaurantId ?? ''));
                      },
                    );
                    if (Table?.tableNumber == null) {
                      return;
                    }
                    String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                    showDialog(
                      context: context,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );
                    await context.read<RestaurantCubit>().PostTables(token ?? '', Table ?? TablesModel());
                    await context.read<RestaurantCubit>().getRestaurantTables(BlocProvider.of<LoginCubit>(context).RestaurantId ?? '', token ?? '');

                    Navigator.canPop(context) ? Navigator.pop(context) : false;
                  },
                )),
                Center(child: _buildTableSection(context.read<RestaurantCubit>().customerTables, context)),
                Center(
                    child: _buildSectionTitle(
                  'Menu',
                  context,
                  () async {
                    MenuModel? Menu = await showDialog<MenuModel>(
                      context: context,
                      builder: (BuildContext context) {
                        return MenuFormDialog(menu: MenuModel(restaurant: BlocProvider.of<LoginCubit>(context).RestaurantId ?? ''));
                      },
                    );
                    if (Menu?.name == null) {
                      return;
                    }
                    String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                    showDialog(
                      context: context,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );
                    await context.read<RestaurantCubit>().PostMenus(token ?? '', Menu ?? MenuModel());
                    await context.read<RestaurantCubit>().getRestaurantMenus(BlocProvider.of<LoginCubit>(context).RestaurantId ?? '', token ?? '');

                    Navigator.canPop(context) ? Navigator.pop(context) : false;
                  },
                )),
                Center(child: _buildMenuSection(context.read<RestaurantCubit>().customerMenus, context)),
                Center(
                    child: _buildSectionTitle(
                  'Deserts',
                  context,
                  () async {
                    DesertModel? Dessert = await showDialog<DesertModel>(
                      context: context,
                      builder: (BuildContext context) {
                        return DessertFormDialog(dessert: DesertModel(restaurant: BlocProvider.of<LoginCubit>(context).RestaurantId ?? ''));
                      },
                    );
                    if (Dessert?.name == null) {
                      return;
                    }
                    String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                    showDialog(
                      context: context,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );
                    await context.read<RestaurantCubit>().PostDesert(token ?? '', Dessert ?? DesertModel());
                    await context.read<RestaurantCubit>().getRestaurantDesert(BlocProvider.of<LoginCubit>(context).RestaurantId ?? '', token ?? '');
                    Navigator.canPop(context) ? Navigator.pop(context) : false;
                  },
                )),
                Center(child: _buildDessertSection(context.read<RestaurantCubit>().customerDeserts, context)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context, Function()? ontap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
          ),
          const Spacer(),
          IconButton(onPressed: ontap, icon: const Icon(Icons.add))
        ],
      ),
    );
  }

  Widget _buildTableSection(List<RestaurantTablesModel> tables, BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tables.length,
        itemBuilder: (context, index) {
          return BlocBuilder<RestaurantCubit, RestaurantState>(
            builder: (context, state) {
              return InkWell(
                onTap: () async {
                  TablesModel table = TablesModel(
                    id: tables[index].id,
                    isReserved: tables[index].isReserved,
                    tableNumber: tables[index].tableNumber,
                    capacity: tables[index].capacity,
                    restaurant: BlocProvider.of<LoginCubit>(context).RestaurantId ?? '0',
                  );

                  TablesModel? updatedTable = await showDialog<TablesModel>(
                    context: context,
                    builder: (BuildContext context) {
                      return TableFormDialog(table: table);
                    },
                  );

                  if (updatedTable != null) {
                    print('Updated Table: ${updatedTable.id}, ${updatedTable.isReserved}, ${updatedTable.tableNumber}, ${updatedTable.capacity}, ${updatedTable.restaurant}');
                    // Handle the updated table data
                  }
                  if (updatedTable?.tableNumber == null) {
                    return;
                  }
                  String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                  showDialog(
                    context: context,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );
                  await context.read<RestaurantCubit>().PutTables(token ?? '', updatedTable ?? TablesModel());
                  await context.read<RestaurantCubit>().getRestaurantTables(BlocProvider.of<LoginCubit>(context).RestaurantId ?? '', token ?? '');

                  Navigator.canPop(context) ? Navigator.pop(context) : false;
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Table ${tables[index].id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text((tables[index].isReserved ?? false) ? "Reserved" : "Not reseved", style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDessertSection(List<RestaurantDesertModel> desserts, BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: desserts.length,
        itemBuilder: (context, index) {
          return BlocBuilder<RestaurantCubit, RestaurantState>(
            builder: (context, state) {
              return InkWell(
                onTap: () async {
                  DesertModel dessert = DesertModel(
                    id: desserts[index].id,
                    restaurant: (BlocProvider.of<LoginCubit>(context).RestaurantId ?? '0'),
                    name: desserts[index].name,
                    description: desserts[index].description,
                    price: (desserts[index].price.toString()),
                  );

                  DesertModel? updatedDessert = await showDialog<DesertModel>(
                    context: context,
                    builder: (BuildContext context) {
                      return DessertFormDialog(dessert: dessert);
                    },
                  );

                  if (updatedDessert != null) {
                    print('Updated Dessert: ${updatedDessert.restaurant}, ${updatedDessert.name}, ${updatedDessert.description}, ${updatedDessert.price}');
                    // Handle the updated dessert data
                  }
                  if (updatedDessert?.name == null) {
                    return;
                  }
                  String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                  showDialog(
                    context: context,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );
                  await context.read<RestaurantCubit>().PutDesert(token ?? '', updatedDessert);
                  await context.read<RestaurantCubit>().getRestaurantDesert(BlocProvider.of<LoginCubit>(context).RestaurantId ?? '', token ?? '');
                  Navigator.canPop(context) ? Navigator.pop(context) : false;
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(desserts[index].name ?? "not available", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('${desserts[index].price}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(List<RestaurantMenusModel> menus, BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menus.length,
        itemBuilder: (context, index) {
          return BlocBuilder<RestaurantCubit, RestaurantState>(
            builder: (context, state) {
              return InkWell(
                onTap: () async {
                  MenuModel menu = MenuModel(
                    id: menus[index].id,
                    restaurant: (BlocProvider.of<LoginCubit>(context).RestaurantId ?? '0'),
                    name: menus[index].name,
                    description: menus[index].description,
                    price: (menus[index].price.toString()),
                  );

                  MenuModel? updatedMenu = await showDialog<MenuModel>(
                    context: context,
                    builder: (BuildContext context) {
                      return MenuFormDialog(menu: menu);
                    },
                  );

                  if (updatedMenu != null) {
                    print('Updated Menu: ${updatedMenu.id}, ${updatedMenu.restaurant}, ${updatedMenu.name}, ${updatedMenu.description}, ${updatedMenu.price}');
                    // Handle the updated menu data
                  }
                  if (updatedMenu?.name == null) {
                    return;
                  }
                  String? token = await BlocProvider.of<RefreshTokenCubit>(context).get_access_token(BlocProvider.of<LoginCubit>(context).loggedUser?.refreshToken ?? '');
                  showDialog(
                    context: context,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );
                  await context.read<RestaurantCubit>().PutMenus(token ?? '', updatedMenu ?? MenuModel());
                  await context.read<RestaurantCubit>().getRestaurantMenus(BlocProvider.of<LoginCubit>(context).RestaurantId ?? '', token ?? '');

                  Navigator.canPop(context) ? Navigator.pop(context) : false;
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(menus[index].name ?? 'not available', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('${menus[index].price}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
