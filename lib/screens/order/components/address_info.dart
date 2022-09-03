import 'package:flutter/material.dart';
import 'package:multi_store_app/screens/address/address_screen.dart';
import 'package:multi_store_app/screens/address/edit_address_screen.dart';
import 'package:multi_store_app/services/global_methods.dart';

class AddressInfo extends StatelessWidget {
  final String name, phone, address, landmark, city, state, pincode;
  const AddressInfo({
    Key? key,
    required this.name,
    required this.phone,
    required this.address,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Text(
                  name.toUpperCase().toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text('$address, $landmark, $city, $state - $pincode',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(
              height: 10,
            ),
            Text(
              phone.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ]),
        ),
      ),
    );
  }
}
