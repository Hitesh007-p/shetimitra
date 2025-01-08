import { CheckCircle } from 'lucide-react'

interface FeatureSectionProps {
  title: string
  description: string
  features: string[]
}

export default function FeatureSection({ title, description, features }: FeatureSectionProps) {
  return (
    <section className="py-16 bg-gray-50">
      <div className="container mx-auto">
        <h2 className="text-3xl font-bold text-center mb-4">{title}</h2>
        <p className="text-xl text-center mb-8">{description}</p>
        <ul className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {features.map((feature, index) => (
            <li key={index} className="flex items-start">
              <CheckCircle className="text-green-500 mr-2 mt-1 flex-shrink-0" />
              <span>{feature}</span>
            </li>
          ))}
        </ul>
      </div>
    </section>
  )
}

