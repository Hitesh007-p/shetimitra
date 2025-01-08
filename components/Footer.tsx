import Link from 'next/link'
import { Facebook, Twitter, Instagram } from 'lucide-react'

export default function Footer() {
  return (
    <footer className="bg-green-900 text-white py-12">
      <div className="container mx-auto grid grid-cols-1 md:grid-cols-4 gap-8">
        <div>
          <h3 className="text-2xl font-bold mb-4">ShetiMitra</h3>
          <p className="text-green-200">Empowering farmers with essential resources and services.</p>
        </div>
        <div>
          <h4 className="text-lg font-semibold mb-4">Quick Links</h4>
          <ul className="space-y-2">
            <li><Link href="#features" className="text-green-200 hover:text-white transition-colors duration-200">Features</Link></li>
            <li><Link href="#services" className="text-green-200 hover:text-white transition-colors duration-200">Services</Link></li>
            <li><Link href="#showcase" className="text-green-200 hover:text-white transition-colors duration-200">App Showcase</Link></li>
            <li><Link href="#testimonials" className="text-green-200 hover:text-white transition-colors duration-200">Testimonials</Link></li>
          </ul>
        </div>
        <div>
          <h4 className="text-lg font-semibold mb-4">Contact Us</h4>
          <p className="text-green-200">Email: support@shetimitra.com</p>
          <p className="text-green-200">Phone: +91 1234567890</p>
        </div>
        <div>
          <h4 className="text-lg font-semibold mb-4">Follow Us</h4>
          <div className="flex space-x-4">
            <a href="#" className="text-green-200 hover:text-white transition-colors duration-200">
              <Facebook />
            </a>
            <a href="#" className="text-green-200 hover:text-white transition-colors duration-200">
              <Twitter />
            </a>
            <a href="#" className="text-green-200 hover:text-white transition-colors duration-200">
              <Instagram />
            </a>
          </div>
        </div>
      </div>
      <div className="mt-8 pt-8 border-t border-green-700 text-center text-green-200">
        <p>&copy; 2023 ShetiMitra. All rights reserved.</p>
      </div>
    </footer>
  )
}

