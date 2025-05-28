import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["summary", "timeline", "keyPoints", "nextSteps", "riskAssessment", "stageIndicator", "progressBar"]
  static values = { dealRoomId: String, refreshInterval: { type: Number, default: 30000 } }

  connect() {
    this.loadData()
    this.startAutoRefresh()
  }

  disconnect() {
    this.stopAutoRefresh()
  }

  loadData() {
    if (!this.dealRoomIdValue) {
      console.warn("No deal room ID provided")
      return
    }

    fetch(`/api/deal_rooms/${this.dealRoomIdValue}`)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        return response.json()
      })
      .then(data => {
        this.updateDealRoomData(data)
        this.updateAISummary(data.ai_summary)
        this.updateStageProgress(data.deal_room)
        this.dispatchTimelineUpdate(data.timeline_visualization)
      })
      .catch(error => {
        console.error('Error loading deal room data:', error)
        this.showError('Failed to load deal room data')
      })
  }

  updateDealRoomData(data) {
    if (this.hasSummaryTarget) {
      this.summaryTarget.innerHTML = this.formatSummary(data.deal_room)
    }
    
    if (this.hasTimelineTarget) {
      this.timelineTarget.innerHTML = this.formatTimeline(data.timeline)
    }
  }

  formatSummary(dealRoom) {
    return `
      <div class="deal-room-summary">
        <h3 class="text-xl font-semibold">${dealRoom.name}</h3>
        <div class="mt-2 flex items-center space-x-4">
          <span class="px-2 py-1 text-xs rounded-full ${this.getStageClass(dealRoom.stage)}">
            ${dealRoom.stage.replace('_', ' ').toUpperCase()}
          </span>
          <span class="text-sm text-gray-500">
            Last updated: ${new Date(dealRoom.updated_at).toLocaleDateString()}
          </span>
        </div>
      </div>
    `
  }

  formatTimeline(timeline) {
    if (!timeline || timeline.length === 0) {
      return '<p class="text-gray-500">No timeline events available</p>'
    }

    return timeline.map(event => `
      <div class="timeline-event border-l-4 border-blue-500 pl-4 pb-4 mb-4">
        <div class="flex justify-between items-start">
          <h4 class="font-medium">${event.title}</h4>
          <span class="text-xs text-gray-500">${new Date(event.date).toLocaleDateString()}</span>
        </div>
        ${event.content ? `<p class="text-sm text-gray-600 mt-1">${event.content}</p>` : ''}
      </div>
    `).join('')
  }

  updateAISummary(summary) {
    if (!summary) return

    if (this.hasKeyPointsTarget && summary.key_points) {
      this.keyPointsTarget.innerHTML = summary.key_points
        .map(point => `<li class="mb-1">${point}</li>`)
        .join("")
    }
    
    if (this.hasNextStepsTarget && summary.next_steps) {
      this.nextStepsTarget.innerHTML = summary.next_steps
        .map(step => `<li class="mb-1">${step}</li>`)
        .join("")
    }
    
    if (this.hasRiskAssessmentTarget && summary.risk_assessment) {
      this.riskAssessmentTarget.innerHTML = `
        <div class="p-3 rounded-lg ${this.getRiskClass(summary.risk_level)}">
          <div class="font-medium mb-1">Risk Level: ${summary.risk_level || 'Medium'}</div>
          <div class="text-sm">${summary.risk_assessment}</div>
        </div>
      `
    }
  }

  updateStageProgress(dealRoom) {
    if (this.hasStageIndicatorTarget) {
      this.stageIndicatorTarget.innerHTML = this.formatStageIndicator(dealRoom.stage)
    }
    
    if (this.hasProgressBarTarget) {
      this.progressBarTarget.innerHTML = this.formatProgressBar(dealRoom.stage)
    }
  }

  formatStageIndicator(currentStage) {
    const stages = ['initial_contact', 'needs_analysis', 'proposal', 'negotiation', 'closed_won']
    const currentIndex = stages.indexOf(currentStage)
    
    return stages.map((stage, index) => {
      const isActive = index <= currentIndex
      const isCurrent = index === currentIndex
      
      return `
        <div class="flex items-center ${index < stages.length - 1 ? 'flex-1' : ''}">
          <div class="flex items-center justify-center w-8 h-8 rounded-full ${
            isActive ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-500'
          } ${isCurrent ? 'ring-4 ring-blue-200' : ''}">
            ${index + 1}
          </div>
          <div class="ml-2 text-sm ${isActive ? 'text-blue-600 font-medium' : 'text-gray-500'}">
            ${stage.replace('_', ' ').toUpperCase()}
          </div>
          ${index < stages.length - 1 ? `
            <div class="flex-1 h-1 mx-4 ${
              index < currentIndex ? 'bg-blue-500' : 'bg-gray-200'
            }"></div>
          ` : ''}
        </div>
      `
    }).join('')
  }

  formatProgressBar(currentStage) {
    const stages = ['initial_contact', 'needs_analysis', 'proposal', 'negotiation', 'closed_won']
    const currentIndex = stages.indexOf(currentStage)
    const progressPercent = ((currentIndex + 1) / stages.length) * 100
    
    return `
      <div class="w-full bg-gray-200 rounded-full h-2">
        <div class="bg-blue-500 h-2 rounded-full transition-all duration-500" style="width: ${progressPercent}%"></div>
      </div>
      <div class="text-sm text-gray-600 mt-1">
        Progress: ${Math.round(progressPercent)}% complete
      </div>
    `
  }

  dispatchTimelineUpdate(timelineData) {
    // Dispatch custom event for timeline visualization controller
    const event = new CustomEvent('timeline:dataUpdated', {
      detail: { timelineData },
      bubbles: true
    })
    this.element.dispatchEvent(event)
  }

  getStageClass(stage) {
    const stageClasses = {
      'initial_contact': 'bg-blue-100 text-blue-800',
      'needs_analysis': 'bg-purple-100 text-purple-800',
      'proposal': 'bg-yellow-100 text-yellow-800',
      'negotiation': 'bg-orange-100 text-orange-800',
      'closed_won': 'bg-green-100 text-green-800',
      'closed_lost': 'bg-red-100 text-red-800'
    }
    return stageClasses[stage] || 'bg-gray-100 text-gray-800'
  }

  getRiskClass(riskLevel) {
    const riskClasses = {
      'low': 'bg-green-50 border border-green-200 text-green-800',
      'medium': 'bg-yellow-50 border border-yellow-200 text-yellow-800',
      'high': 'bg-red-50 border border-red-200 text-red-800'
    }
    return riskClasses[riskLevel?.toLowerCase()] || riskClasses['medium']
  }

  showError(message) {
    // Create a simple error notification
    const errorDiv = document.createElement('div')
    errorDiv.className = 'bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4'
    errorDiv.textContent = message
    
    // Insert at the top of the deal room container
    this.element.insertBefore(errorDiv, this.element.firstChild)
    
    // Remove after 5 seconds
    setTimeout(() => {
      if (errorDiv.parentNode) {
        errorDiv.parentNode.removeChild(errorDiv)
      }
    }, 5000)
  }

  startAutoRefresh() {
    if (this.refreshIntervalValue > 0) {
      this.refreshTimer = setInterval(() => {
        this.loadData()
      }, this.refreshIntervalValue)
    }
  }

  stopAutoRefresh() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
      this.refreshTimer = null
    }
  }

  // Manual refresh action
  refresh() {
    this.loadData()
  }

  // Toggle auto-refresh
  toggleAutoRefresh() {
    if (this.refreshTimer) {
      this.stopAutoRefresh()
    } else {
      this.startAutoRefresh()
    }
  }
}