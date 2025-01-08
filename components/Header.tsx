import Link from 'next/link'
import { Button } from "@/components/ui/button"

export default function Header() {
  return (
    <header className="bg-white shadow-md sticky top-0 z-50">
      <div className="container mx-auto flex justify-between items-center py-4">
        <Link href="/" className="text-2xl font-bold text-green-600">ShetiMitra</Link>
        <nav>
          <ul className="flex space-x-6">
            <li><Link href="#features" className="text-gray-600 hover:text-green-600 transition-colors duration-200">Features</Link></li>
            <li><Link href="#services" className="text-gray-600 hover:text-green-600 transition-colors duration-200">Services</Link></li>
            <li><Link href="#showcase" className="text-gray-600 hover:text-green-600 transition-colors duration-200">App Showcase</Link></li>
            <li><Link href="#testimonials" className="text-gray-600 hover:text-green-600 transition-colors duration-200">Testimonials</Link></li>
          </ul>
        </nav>
        <Button className="bg-green-500 hover:bg-green-600 transition-colors duration-200">
          Download App
        </Button>
      </div>
    </header>
  )
}

