import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Tractor, Cloud, TrendingUp, Leaf, Sprout, Bell } from 'lucide-react'

export default function FeaturesSection() {
  const features = [
    { title: "Equipment Rental", description: "Access modern farming equipment without high ownership costs.", icon: Tractor },
    { title: "Weather Alerts", description: "Stay informed with real-time weather updates and forecasts.", icon: Cloud },
    { title: "Market Prices", description: "Get up-to-date market prices for your crops and livestock.", icon: TrendingUp },
    { title: "Crop Management", description: "Optimize your crop cycles with expert advice and tracking tools.", icon: Leaf },
    { title: "Soil Health", description: "Monitor and improve your soil quality for better yields.", icon: Sprout },
    { title: "Govt. Scheme Notifications", description: "Stay updated on the latest agricultural schemes and subsidies.", icon: Bell },
  ]

  return (
    <section id="features" className="py-20 bg-gray-50">
      <div className="container mx-auto">
        <h2 className="text-3xl font-bold text-center mb-12">Key Features of ShetiMitra</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <Card key={index} className="hover:shadow-lg transition-shadow duration-300">
              <CardHeader>
                <feature.icon className="w-12 h-12 text-green-500 mb-4" />
                <CardTitle>{feature.title}</CardTitle>
              </CardHeader>
              <CardContent>
                <CardDescription>{feature.description}</CardDescription>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  )
}

