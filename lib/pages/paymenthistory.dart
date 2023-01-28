import 'package:flutter/material.dart';
import 'package:ice_app_new/models/paymenthistory.dart';
import 'package:ice_app_new/providers/paymentreceive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymenthistoryPage extends StatefulWidget {
  static const routeName = '/paymenthistory';
  @override
  _PaymenthistoryPageState createState() => _PaymenthistoryPageState();
}

class _PaymenthistoryPageState extends State<PaymenthistoryPage> {
  Future _paymenthistoryFuture;
  Future _obtainpaymenthistoryFuture() {
    Provider.of<PaymentreceiveData>(context, listen: false).fetPaymenthistory();
  }

  @override
  void initState() {
    _paymenthistoryFuture = _obtainpaymenthistoryFuture();
    // TODO: implement initState
    super.initState();
  }

  Widget builditem(List<Paymenthistory> data) {
    var formatter = NumberFormat('#,##,##0.#');
    Widget list;
    if (data.isNotEmpty) {
      if (data.length > 0) {
        list = new ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: ValueKey(data[index]),
                background: Container(
                  color: Theme.of(context).errorColor,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) {
                  return showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('แจ้งเตือน'),
                      content: Text('ต้องการยกเลิกการชำระเงินใช่หรือไม่'),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text('ยืนยัน'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('ไม่'),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) async {
                  // print(widget._orders[widget._index].id);
                  bool iscancel = await Provider.of<PaymentreceiveData>(context,
                          listen: false)
                      .paymentcancel(data[index].payment_id,
                          data[index].order_id, data[index].payment_amount);

                  if (iscancel) {
                    setState(() {
                      data.removeAt(index);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          children: <Widget>[
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "ทำรายการสำเร็จ",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green,
                      ));
                    });
                  }
                },
                child: GestureDetector(
                  child: Card(
                    //  color: Colors.blue[300],

                    child: Padding(
                      padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                      child: ListTile(
                        title: Text(
                          'เลขที่รับชำระ: ${data[index].journal_no}\nเลขที่ขาย: ${data[index].order_no}\nวันที่ขาย: ${data[index].order_date}',
                        ),
                        subtitle: Text(
                          'ลูกค้า: ${data[index].customer_name}\nวันที่: ${data[index].payment_date}',
                          style: TextStyle(color: Colors.black54),
                        ),
                        trailing: Text(
                          '${data[index].payment_amount}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
        return list;
      }
    } else {
      return Center(
        child: Text('ไม่พบข้อมูล'),
      );
    }
  }

  Widget buildlist() {
    PaymentreceiveData payment =
        Provider.of<PaymentreceiveData>(context, listen: false);
    Widget content;
    content = FutureBuilder(
      future: _paymenthistoryFuture,
      builder: (context, dataSnapshort) {
        if (dataSnapshort.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshort.error != null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return builditem(payment.listpaymenthistory);
          }
        }
      },
    );
    return RefreshIndicator(
      child: content,
      onRefresh: payment.fetPaymenthistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,##0.#');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ประวัติรับชำระเงิน',
            style: TextStyle(color: Colors.white),
          ),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: buildlist(),
            ),
            Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'รวมเงิน',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: Consumer<PaymentreceiveData>(
                        builder: (context, _paymenthistory, _) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${formatter.format(_paymenthistory.sumPayment)}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
