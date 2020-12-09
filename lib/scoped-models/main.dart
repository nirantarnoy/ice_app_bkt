import 'package:scoped_model/scoped_model.dart';

import './connected_user.dart';
import './connected_product.dart';
import './connected_order.dart';
import 'connected_delivery_route.dart';

class MainModel extends Model
    with
        ConnectedUserModel,
        UsersModel,
        UtilityModel,
        ConnectedProductsModel,
        ProductsModel,
        ConnectedOrdersModel,
        OrdersModel,
        ConnectedDeliveryRouteModel,
        DeliveryRouteModel {}
