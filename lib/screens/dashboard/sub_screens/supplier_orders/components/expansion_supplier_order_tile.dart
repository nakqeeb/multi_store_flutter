import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_store_app/models/order.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../providers/auth_customer_provider.dart';
import '../../../../../providers/locale_provider.dart';
import '../../../../../services/global_methods.dart';
import '../../../../../services/push_notification.dart';
import '../../../../../services/utils.dart';

class ExpansionSupplierOrderTile extends StatelessWidget {
  final Order order;
  ExpansionSupplierOrderTile({super.key, required this.order});

  // https://peaku.co/questions/25591-el-analisis-de-la-fecha-de-mongodb-en-flutter-siempre-falla
  _getFormattedDateFromFormattedString(
      {required value,
      required String currentFormat,
      required String desiredFormat,
      isUtc = false}) {
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      try {
        dateTime =
            DateFormat(currentFormat).parse(value, isUtc = true).toLocal();
      } catch (e) {
        print("$e");
      }
    }
    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    final appLocale = AppLocalizations.of(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final deliveryStatus = order.deliveryStatus.toString() == 'preparing'
        ? appLocale!.preparing
        : order.deliveryStatus.toString() == 'shipping'
            ? appLocale!.shipping
            : order.deliveryStatus.toString() == 'delivered'
                ? appLocale!.delivered
                : '';
    final paymentStatus = order.paymentStatus == 'cash on delivery'
        ? appLocale!.cash_on_delivery
        : order.paymentStatus == 'paid by VISA'
            ? appLocale!.paid_by_visa
            : '';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              width: 1, color: Theme.of(context).colorScheme.secondary),
        ),
        child: ExpansionTile(
          title: Container(
            constraints: BoxConstraints(
                maxHeight: size.height * 0.1, maxWidth: double.infinity),
            child: Row(
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'images/inapp/spinner.gif',
                  image: order.productImage.toString(),
                  height: double.infinity,
                  width: size.width * 0.20,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.60,
                        child: Text(
                          order.productName.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.productPrice!.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            Text(
                              'x ${order.orderQuantity}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                '${appLocale!.total_price}:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                order.orderPrice!.toStringAsFixed(2),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                deliveryStatus,
                style: TextStyle(
                    color: order.deliveryStatus == 'preparing'
                        ? Colors.amber
                        : order.deliveryStatus == 'shipping'
                            ? Colors.indigoAccent
                            : Colors.green),
              )
            ],
          ),
          children: [
            Container(
              //height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: order.deliveryStatus == 'delivered'
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                    : Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${appLocale.name}: ${order.name}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.phone}: ${order.phone}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.address}: ${order.address}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.landmark}: ${order.landmark}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.province}: ${order.state}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.city}: ${order.city}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${appLocale.pincode}: ${order.pincode}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${appLocale.payment_status}: ',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          paymentStatus,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.purple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${appLocale.delivery_status}: ',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          deliveryStatus,
                          style: TextStyle(
                              fontSize: 15,
                              color: order.deliveryStatus == 'preparing'
                                  ? Colors.amber
                                  : order.deliveryStatus == 'shipping'
                                      ? Colors.indigoAccent
                                      : Colors.green),
                        ),
                      ],
                    ),
                    order.deliveryStatus == 'shipping'
                        ? Text(
                            '${appLocale.estimated_delivery_date}: ${_getFormattedDateFromFormattedString(value: order.deliveryDate, currentFormat: "yyyy-MM-ddTHH:mm:ssZ", desiredFormat: "yyyy-MM-dd").toString().split(' ')[0]}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.blue),
                          )
                        : const SizedBox.shrink(),
                    Row(
                      children: [
                        Text(
                          '${appLocale.order_date}: ',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          _getFormattedDateFromFormattedString(
                                  value: order.orderDate,
                                  currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
                                  desiredFormat: "yyyy-MM-dd HH:mm:ss")
                              .toString(),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    order.deliveryStatus == 'delivered'
                        ? Text(
                            appLocale.order_already_delivered,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.teal,
                            ),
                          )
                        : Row(
                            children: [
                              Text(
                                '${appLocale.change_delivery_status}: ',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              order.deliveryStatus == 'preparing'
                                  ? TextButton(
                                      onPressed: () {
                                        showDialog<Widget>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 150, 20, 150),
                                                child: SfDateRangePicker(
                                                  minDate: DateTime.now(),
                                                  maxDate: DateTime.now().add(
                                                    const Duration(days: 365),
                                                  ),
                                                  monthCellStyle:
                                                      DateRangePickerMonthCellStyle(
                                                    todayTextStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inversePrimary),
                                                    cellDecoration:
                                                        BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  selectionColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary,
                                                  showActionButtons: true,
                                                  confirmText: appLocale.ok,
                                                  cancelText: appLocale.cancel,
                                                  // controller: _dateRangePickerController,
                                                  onSubmit: (date) async {
                                                    if (date == null) {
                                                      return;
                                                    }

                                                    GlobalMethods.loadingDialog(
                                                        title: appLocale
                                                            .please_wait,
                                                        context: context);
                                                    await orderProvider
                                                        .updateOrder(
                                                            order.id,
                                                            'shipping',
                                                            date as DateTime);
                                                    final customer = await Provider
                                                            .of<AuthCustomerProvider>(
                                                                context,
                                                                listen: false)
                                                        .fetchCustomerById(order
                                                            .customer!.id!);
                                                    // print('This is order customer name ${customer.name}');
                                                    await PushNotification
                                                        .sendNotificationNow(
                                                      deviceRegistrationToken:
                                                          customer.fcmToken!,
                                                      title: appLocale
                                                          .order_shipped,
                                                      body: appLocale
                                                          .your_order_shipped,
                                                    );
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  onCancel: () {
                                                    // _dateRangePickerController
                                                    //     .selectedDate = null;
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              );
                                            });
                                        /* DatePicker.showDatePicker(
                                          context,
                                          locale: isArabic
                                              ? LocaleType.ar
                                              : LocaleType.en,
                                          minTime: DateTime.now(),
                                          maxTime: DateTime.now().add(
                                            const Duration(days: 365),
                                          ),
                                          onConfirm: (date) async {
                                            await orderProvider
                                                .updateOrder(
                                                    order.id, 'shipping', date)
                                                .whenComplete(() async {
                                              final customer =
                                                  await authCustomerProvider
                                                      .fetchCustomerById(
                                                          order.customer!.id!);
                                              // print('This is order customer name ${customer.name}');
                                              PushNotification
                                                  .sendNotificationNow(
                                                deviceRegistrationToken:
                                                    customer.fcmToken!,
                                                title: appLocale.order_shipped,
                                                body: appLocale
                                                    .your_order_shipped,
                                              );
                                            });
                                          },
                                          theme: DatePickerTheme(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            cancelStyle: const TextStyle(
                                                color: Colors.red),
                                            doneStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface),
                                            itemStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface),
                                          ),
                                        ); */
                                      },
                                      child: Text(
                                        '${appLocale.shipping}${appLocale.question_mark}',
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () async {
                                        GlobalMethods.loadingDialog(
                                            title: appLocale.please_wait,
                                            context: context);
                                        await orderProvider.updateOrder(
                                            order.id, 'delivered', null);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        '${appLocale.delivered}${appLocale.question_mark}',
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                    )
                            ],
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
