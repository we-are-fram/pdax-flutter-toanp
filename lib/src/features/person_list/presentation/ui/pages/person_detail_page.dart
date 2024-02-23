import 'package:flutter/material.dart';
import 'package:fram_flutter_assignment/src/features/person_list/data/models/person.dart';
import 'package:fram_flutter_assignment/src/features/person_list/presentation/ui/widgets/person_avatar.dart';

class PersonDetailPage extends StatelessWidget {
  final Person person;

  const PersonDetailPage({Key? key, required this.person}) : super(key: key);

  static String get routeName {
    return "/PersonDetailPage";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person Details'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PersonAvatar(image: person.image),
                SizedBox(height: 16),
                Text(
                  'Name: ${person.name}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('Email: ${person.email}'),
                SizedBox(height: 8),
                Text('Birthday: ${person.birthday.toString()}'),
                SizedBox(height: 8),
                Text('Gender: ${person.gender.toString()}'),
                SizedBox(height: 8),
                Text('Website: ${person.websiteUrl}'),
                SizedBox(height: 8),
                Text('Phone: ${person.phone}'),
                SizedBox(height: 16),
                Text(
                  'Address:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Street: ${person.address.street}'),
                SizedBox(height: 8),
                Text('Street Name: ${person.address.streetName}'),
                SizedBox(height: 8),
                Text('Building Number: ${person.address.buildingNumber}'),
                SizedBox(height: 8),
                Text('City: ${person.address.city}'),
                SizedBox(height: 8),
                Text('Zipcode: ${person.address.zipcode}'),
                SizedBox(height: 8),
                Text('Country: ${person.address.country}'),
                SizedBox(height: 8),
                Text('County Code: ${person.address.countyCode}'),
                SizedBox(height: 8),
                Text('Latitude: ${person.address.latitude.toString()}'),
                SizedBox(height: 8),
                Text('Longitude: ${person.address.longitude.toString()}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
