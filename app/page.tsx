import Header from '@/components/Header'
import Footer from '@/components/Footer'
import HeroSection from '@/components/HeroSection'
import FeaturesSection from '@/components/FeaturesSection'
import ServicesSection from '@/components/ServicesSection'
import AppShowcase from '@/components/AppShowcase'
import TestimonialsSection from '@/components/TestimonialsSection'
import DownloadCTA from '@/components/DownloadCTA'

export default function Home() {
  return (
    <div className="flex flex-col min-h-screen">
      <Header />
      <main className="flex-grow">
        <HeroSection />
        <FeaturesSection />
        <ServicesSection />
        <AppShowcase />
        <TestimonialsSection />
        <DownloadCTA />
      </main>
      <Footer />
    </div>
  )
}

