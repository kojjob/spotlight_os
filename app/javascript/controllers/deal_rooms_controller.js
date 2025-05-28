import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["summary", "timeline", "keyPoints", "nextSteps", "riskAssessment"]

  connect() {
    this.loadData()
  }

  loadData() {
    fetch(`/api/deal_rooms/${this.element.dataset.dealRoomId}`)
      .then(response => response.json())
      .then(data => {
        this.summaryTarget.innerHTML = this.formatSummary(data.deal_room)
        this.timelineTarget.innerHTML = this.formatTimeline(data.timeline_events)
        this.updateAISummary(data.ai_summary)
      })
  }

  formatSummary(data) {
    return `<h3>${data.name}</h3>`
  }

  formatTimeline(timeline) {
    return timeline.map(event => `<div>${event}</div>`).join("")
  }

  updateAISummary(summary) {
    this.keyPointsTarget.innerHTML = summary.key_points
      .map(point => `<li>${point}</li>`)
      .join("")
    
    this.nextStepsTarget.innerHTML = summary.next_steps
      .map(step => `<li>${step}</li>`)
      .join("")
    
    this.riskAssessmentTarget.textContent = summary.risk_assessment
  }
}