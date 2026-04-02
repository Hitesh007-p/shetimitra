import 'package:shetimitra/pages/nursury.dart';
import 'package:shetimitra/pages/seeds.dart';

import '../models/service.dart';

List<Service> services = [
  Service(
    name: 'serviceSeeds',
    image: 'assets/services/seeds.jpg',
    destination: const SeedsScreen(),
  ),
  const Service(
    name: 'serviceNursery',
    image: 'assets/services/seedlings.jpg',
    destination: NursaryScreen(),
  ),
  const Service(
    name: 'serviceMachinery',
    image: 'assets/services/machinery.jpg',
    destination: NursaryScreen(),
  ),
  const Service(
    name: 'serviceDroneSpraying',
    image: 'assets/services/droan.jpeg',
    destination: NursaryScreen(),
  ),
  const Service(
    name: 'serviceSoilTesting',
    image: 'assets/services/soil.jpeg',
    destination: NursaryScreen(),
  ),
  const Service(
    name: 'serviceCropMedicine',
    image: 'assets/services/crop_disease.jpg',
    destination: NursaryScreen(),
  ),
];
