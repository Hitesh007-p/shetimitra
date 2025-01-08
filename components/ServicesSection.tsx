import { CheckCircle } from 'lucide-react'

export default function ServicesSection() {
  const services = [
    "Equipment rental and sharing platform",
    "Real-time weather forecasting and alerts",
    "Market price information and trends",
    "Soil testing and analysis services",
    "Crop disease identification and treatment advice",
    "Access to agricultural experts and consultations",
    "Government scheme application assistance",
    "Farmer community forums and knowledge sharing",
    "Precision farming tools and techniques",
    "Sustainable farming practices guidance",
  ]

  return (
    <section id="services" className="py-20 bg-white">
      <div className="container mx-auto">
        <h2 className="text-3xl font-bold text-center mb-12">Our Services</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {services.map((service, index) => (
            <div key={index} className="flex items-start">
              <CheckCircle className="text-green-500 mr-2 mt-1 flex-shrink-0" />
              <span>{service}</span>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

