import 'package:flutter/material.dart';
import 'package:multi_store_app/screens/address/edit_address_screen.dart';
import 'package:multi_store_app/services/global_methods.dart';

class AddressTile extends StatelessWidget {
  final String name, phone, address, landmark, city, state, pincode;
  final bool isDefault;
  final VoidCallback onPressed;
  const AddressTile({
    Key? key,
    required this.onPressed,
    required this.isDefault,
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
      child: InkWell(
        onTap: isDefault == true ? null : onPressed,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDefault == true
                ? Theme.of(context).colorScheme.tertiary.withOpacity(0.5)
                : Theme.of(context).colorScheme.primary.withOpacity(0.5),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
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
                isDefault ? const Icon(Icons.home) : const SizedBox.shrink(),
                DropdownButton<String>(
                  icon: const Icon(Icons.more_vert),
                  underline: const SizedBox.shrink(),
                  isDense: true,
                  dropdownColor: Theme.of(context).colorScheme.primary,
                  items: <String>['Edit', 'Delete'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (theValue) {
                    if (theValue == 'Edit') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const EditAddressScreen()));
                    } else if (theValue == 'Delete') {
                      GlobalMethods.warningDialog(
                        title: 'Delete address',
                        subtitle: 'Do you really want to delete this address?',
                        fct: () {},
                        context: context,
                      );
                    }
                  },
                )
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
