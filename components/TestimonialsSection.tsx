import { Card, CardContent } from "@/components/ui/card"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"

export default function TestimonialsSection() {
  const testimonials = [
    {
      name: "Rajesh Patel",
      location: "Gujarat",
      quote: "ShetiMitra has transformed the way I manage my farm. The equipment rental feature alone has saved me lakhs!",
      avatar: "RP"
    },
    {
      name: "Lakshmi Devi",
      location: "Andhra Pradesh",
      quote: "The weather notifications are so accurate, I've been able to protect my crops from unexpected rains multiple times.",
      avatar: "LD"
    },
    {
      name: "Gurpreet Singh",
      location: "Punjab",
      quote: "Thanks to ShetiMitra, I was able to apply for the PM-Kisan scheme easily. The support team was very helpful!",
      avatar: "GS"
    }
  ]

  return (
    <section id="testimonials" className="py-20 bg-gray-50">
      <div className="container mx-auto">
        <h2 className="text-3xl font-bold text-center mb-12">What Farmers Say About ShetiMitra</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {testimonials.map((testimonial, index) => (
            <Card key={index} className="hover:shadow-lg transition-shadow duration-300">
              <CardContent className="p-6">
                <div className="flex items-center mb-4">
                  <Avatar className="h-10 w-10 mr-4">
                    <AvatarImage src={`/placeholder.svg?text=${testimonial.avatar}`} />
                    <AvatarFallback>{testimonial.avatar}</AvatarFallback>
                  </Avatar>
                  <div>
                    <h3 className="font-semibold">{testimonial.name}</h3>
                    <p className="text-sm text-gray-500">{testimonial.location}</p>
                  </div>
                </div>
                <p className="italic">"{testimonial.quote}"</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  )
}

