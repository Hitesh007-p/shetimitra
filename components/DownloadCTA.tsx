import { Button } from "@/components/ui/button"
import { Apple, SmartphoneIcon as Android } from 'lucide-react'

export default function DownloadCTA() {
  return (
    <section className="py-20 bg-gradient-to-r from-green-500 to-blue-600">
      <div className="container mx-auto text-center text-white">
        <h2 className="text-4xl font-bold mb-4">Ready to Transform Your Farming?</h2>
        <p className="text-xl mb-8">Join thousands of farmers already benefiting from ShetiMitra</p>
        <div className="flex justify-center space-x-4">
          <Button size="lg" className="bg-white text-green-600 hover:bg-green-100">
            <Apple className="mr-2 h-5 w-5" /> Download for iOS
          </Button>
          <Button size="lg" className="bg-white text-green-600 hover:bg-green-100">
            <Android className="mr-2 h-5 w-5" /> Download for Android
          </Button>
        </div>
      </div>
    </section>
  )
}

