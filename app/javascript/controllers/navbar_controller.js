import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["mobileMenu"]

  connect() {
    console.log("Navbar controller connected successfully")
    console.log("Available targets:", this.targets)
    if (this.hasMobileMenuTarget) {
      console.log("Mobile menu target found:", this.mobileMenuTarget)
    } else {
      console.log("Mobile menu target NOT found")
    }
  }

  toggleMobile(event) {
    console.log("Mobile toggle clicked - handler called")
    event.preventDefault()
    event.stopPropagation()
    
    if (this.hasMobileMenuTarget) {
      const wasHidden = this.mobileMenuTarget.classList.contains("hidden")
      this.mobileMenuTarget.classList.toggle("hidden")
      
      // Add accessibility attributes
      const isExpanded = !this.mobileMenuTarget.classList.contains("hidden")
      event.currentTarget.setAttribute("aria-expanded", isExpanded)
      
      // Optional: Add body class to prevent scrolling when menu is open
      if (isExpanded) {
        document.body.classList.add("overflow-hidden", "md:overflow-auto")
      } else {
        document.body.classList.remove("overflow-hidden", "md:overflow-auto")
      }
      
      console.log(`Mobile menu toggled from ${wasHidden ? 'hidden' : 'visible'} to ${isExpanded ? 'visible' : 'hidden'}`)
    } else {
      console.log("ERROR: Mobile menu target not found when trying to toggle")
    }
  }
}
