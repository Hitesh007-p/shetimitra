import Image from 'next/image'
import { Card, CardContent } from "@/components/ui/card"

export default function AppShowcase() {
  const screenshots = [
    { src: "/placeholder.svg?height=600&width=300", alt: "Dashboard Screen" },
    { src: "/placeholder.svg?height=600&width=300", alt: "Weather Forecast Screen" },
    { src: "/placeholder.svg?height=600&width=300", alt: "Market Prices Screen" },
    { src: "/placeholder.svg?height=600&width=300", alt: "Equipment Rental Screen" },
  ]

  return (
    <section id="showcase" className="py-20 bg-gradient-to-b from-green-50 to-blue-50">
      <div className="container mx-auto">
        <h2 className="text-3xl font-bold text-center mb-12">ShetiMitra App in Action</h2>
        <div className="flex flex-wrap justify-center gap-8">
          {screenshots.map((screenshot, index) => (
            <Card key={index} className="w-64 overflow-hidden shadow-lg hover:shadow-xl transition-shadow duration-300">
              <CardContent className="p-4">
                <Image
                  src={screenshot.src}
                  alt={screenshot.alt}
                  width={300}
                  height={600}
                  className="rounded-lg"
                />
                <p className="mt-4 text-center text-sm font-medium text-gray-600">{screenshot.alt}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  )
}

