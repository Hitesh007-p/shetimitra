import 'package:shetimitra/pages/nursury.dart';
import 'package:shetimitra/pages/seeds.dart';

import '../models/service.dart';

List<Service> services = [
  Service(
    name: "बियाणे",
    image: "assets/services/seeds.jpg",
    destination: SeedsScreen(),
  ),
  const Service(
    name: "Nursary",
    image: "assets/services/seedlings.jpg",
    destination: NursaryScreen(),
  ),
  const Service(
    name: "मशीनरी",
    image: "assets/services/machinery.jpg",
    destination: NursaryScreen(),
  ),
  const Service(
    name: "द्रोण फावरणी",
    image: "assets/services/droan.jpeg",
    destination: NursaryScreen(),
  ),
  const Service(
    name: "माती परीक्षण",
    image: "assets/services/soil.jpeg",
    destination: NursaryScreen(),
  ),
  const Service(
    name: "फवारणी औषध",
    image: "assets/services/crop_disease.jpg",
    destination: NursaryScreen(),
  ),
];
