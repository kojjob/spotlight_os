import { Controller } from "@hotwired/stimulus"
import * as d3 from "d3"

export default class extends Controller {
  static targets = ["container", "filters", "metrics", "details"]
  static values = {
    dealRoomId: String,
    height: { type: Number, default: 600 },
    width: { type: Number, default: 1000 }
  }

  connect() {
    this.initializeTimeline()
    this.loadData()
    
    // Listen for timeline data updates from deal rooms controller
    this.element.addEventListener('timeline:dataUpdated', this.handleTimelineUpdate.bind(this))
  }

  disconnect() {
    this.element.removeEventListener('timeline:dataUpdated', this.handleTimelineUpdate.bind(this))
  }

  handleTimelineUpdate(event) {
    const { timelineData } = event.detail
    if (timelineData) {
      this.timelineData = timelineData
      this.renderVisualization()
    }
  }

  initializeTimeline() {
    // Clear any existing content
    this.containerTarget.innerHTML = ""
    
    // Set up dimensions and margins
    this.margin = { top: 20, right: 30, bottom: 40, left: 100 }
    this.width = this.widthValue - this.margin.left - this.margin.right
    this.height = this.heightValue - this.margin.top - this.margin.bottom

    // Create SVG
    this.svg = d3.select(this.containerTarget)
      .append("svg")
      .attr("width", this.widthValue)
      .attr("height", this.heightValue)
      .attr("class", "timeline-svg")

    // Create main group
    this.g = this.svg.append("g")
      .attr("transform", `translate(${this.margin.left},${this.margin.top})`)

    // Initialize scales
    this.xScale = d3.scaleTime().range([0, this.width])
    this.yScale = d3.scaleBand().range([0, this.height]).padding(0.1)
    this.colorScale = d3.scaleOrdinal()
      .domain(["conversation", "milestone", "activity"])
      .range(["#3B82F6", "#10B981", "#F59E0B"])

    // Create axes groups
    this.xAxisGroup = this.g.append("g")
      .attr("class", "x-axis")
      .attr("transform", `translate(0,${this.height})`)

    this.yAxisGroup = this.g.append("g")
      .attr("class", "y-axis")

    // Create tooltip
    this.tooltip = d3.select("body").append("div")
      .attr("class", "timeline-tooltip")
      .style("opacity", 0)
      .style("position", "absolute")
      .style("background", "rgba(0, 0, 0, 0.8)")
      .style("color", "white")
      .style("padding", "10px")
      .style("border-radius", "5px")
      .style("pointer-events", "none")
      .style("font-size", "12px")
      .style("z-index", "1000")
  }

  async loadTimelineData() {
    try {
      const response = await fetch(`/api/deal_rooms/${this.dealRoomIdValue}`)
      const data = await response.json()
      
      this.timelineData = data.timeline_visualization
      this.renderTimeline()
      this.renderMetrics()
      this.renderFilters()
    } catch (error) {
      console.error("Error loading timeline data:", error)
    }
  }

  renderTimeline() {
    if (!this.timelineData || !this.timelineData.events) return

    const events = this.timelineData.events
    
    // Update scales
    const dateExtent = d3.extent(events, d => new Date(d.date))
    this.xScale.domain(dateExtent)
    
    const eventTypes = [...new Set(events.map(d => d.type))]
    this.yScale.domain(eventTypes)

    // Update axes
    this.xAxisGroup.call(d3.axisBottom(this.xScale).tickFormat(d3.timeFormat("%m/%d")))
    this.yAxisGroup.call(d3.axisLeft(this.yScale))

    // Create timeline line
    this.renderTimelineLine(events)
    
    // Render events
    this.renderEvents(events)
    
    // Render milestones
    this.renderMilestones()
  }

  renderTimelineLine(events) {
    // Remove existing timeline line
    this.g.selectAll(".timeline-line").remove()
    
    // Create main timeline line
    this.g.append("line")
      .attr("class", "timeline-line")
      .attr("x1", 0)
      .attr("x2", this.width)
      .attr("y1", this.height / 2)
      .attr("y2", this.height / 2)
      .attr("stroke", "#E5E7EB")
      .attr("stroke-width", 2)
  }

  renderEvents(events) {
    // Remove existing events
    this.g.selectAll(".event-group").remove()
    
    const eventGroups = this.g.selectAll(".event-group")
      .data(events)
      .enter()
      .append("g")
      .attr("class", "event-group")
      .attr("transform", d => {
        const x = this.xScale(new Date(d.date))
        const y = this.yScale(d.type) + this.yScale.bandwidth() / 2
        return `translate(${x},${y})`
      })

    // Add event circles
    eventGroups.append("circle")
      .attr("r", d => this.getEventRadius(d))
      .attr("fill", d => this.getEventColor(d))
      .attr("stroke", "white")
      .attr("stroke-width", 2)
      .attr("class", "event-circle")
      .style("cursor", "pointer")
      .on("mouseover", (event, d) => this.showTooltip(event, d))
      .on("mouseout", () => this.hideTooltip())
      .on("click", (event, d) => this.showEventDetails(d))

    // Add event labels for important events
    eventGroups.filter(d => d.type === "milestone")
      .append("text")
      .attr("dy", -15)
      .attr("text-anchor", "middle")
      .attr("font-size", "10px")
      .attr("fill", "#374151")
      .text(d => d.title)

    // Add connecting lines to timeline
    eventGroups.append("line")
      .attr("x1", 0)
      .attr("x2", 0)
      .attr("y1", 0)
      .attr("y2", d => {
        const timelineY = this.height / 2 - (this.yScale(d.type) + this.yScale.bandwidth() / 2)
        return timelineY
      })
      .attr("stroke", "#D1D5DB")
      .attr("stroke-width", 1)
      .attr("stroke-dasharray", "2,2")
  }

  renderMilestones() {
    if (!this.timelineData.milestones) return

    const milestones = this.timelineData.milestones
    
    // Remove existing milestone track
    this.g.selectAll(".milestone-track").remove()
    
    const milestoneTrack = this.g.append("g")
      .attr("class", "milestone-track")
      .attr("transform", `translate(0,${this.height + 20})`)

    // Create milestone progress bar
    const progressWidth = this.width
    const currentStageIndex = milestones.findIndex(m => m.stage === this.getCurrentStage())
    
    milestoneTrack.append("rect")
      .attr("width", progressWidth)
      .attr("height", 4)
      .attr("fill", "#E5E7EB")
      .attr("rx", 2)

    if (currentStageIndex >= 0) {
      const progressPercent = (currentStageIndex + 1) / milestones.length
      milestoneTrack.append("rect")
        .attr("width", progressWidth * progressPercent)
        .attr("height", 4)
        .attr("fill", "#10B981")
        .attr("rx", 2)
    }

    // Add milestone markers
    const milestoneMarkers = milestoneTrack.selectAll(".milestone-marker")
      .data(milestones)
      .enter()
      .append("g")
      .attr("class", "milestone-marker")
      .attr("transform", (d, i) => {
        const x = (progressWidth / (milestones.length - 1)) * i
        return `translate(${x},0)`
      })

    milestoneMarkers.append("circle")
      .attr("r", 6)
      .attr("cy", 2)
      .attr("fill", (d, i) => i <= currentStageIndex ? "#10B981" : "#E5E7EB")
      .attr("stroke", "white")
      .attr("stroke-width", 2)

    milestoneMarkers.append("text")
      .attr("y", 20)
      .attr("text-anchor", "middle")
      .attr("font-size", "10px")
      .attr("fill", "#6B7280")
      .text(d => d.title)
  }

  renderMetrics() {
    if (!this.metricsTarget || !this.timelineData.metrics) return

    const metrics = this.timelineData.metrics
    
    this.metricsTarget.innerHTML = `
      <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
        <div class="bg-white p-4 rounded-lg shadow">
          <div class="text-2xl font-bold text-blue-600">${metrics.total_events}</div>
          <div class="text-sm text-gray-500">Total Events</div>
        </div>
        <div class="bg-white p-4 rounded-lg shadow">
          <div class="text-2xl font-bold text-green-600">${metrics.conversation_count}</div>
          <div class="text-sm text-gray-500">Conversations</div>
        </div>
        <div class="bg-white p-4 rounded-lg shadow">
          <div class="text-2xl font-bold text-purple-600">${metrics.days_in_pipeline}</div>
          <div class="text-sm text-gray-500">Days in Pipeline</div>
        </div>
        <div class="bg-white p-4 rounded-lg shadow">
          <div class="text-2xl font-bold text-orange-600">${Math.round(metrics.average_response_time)}h</div>
          <div class="text-sm text-gray-500">Avg Response Time</div>
        </div>
        <div class="bg-white p-4 rounded-lg shadow">
          <div class="text-2xl font-bold text-red-600">${Math.round(metrics.engagement_score)}%</div>
          <div class="text-sm text-gray-500">Engagement Score</div>
        </div>
      </div>
    `
  }

  renderFilters() {
    if (!this.filtersTarget || !this.timelineData.filters) return

    const filters = this.timelineData.filters
    
    this.filtersTarget.innerHTML = `
      <div class="flex flex-wrap gap-4 mb-4">
        <div class="flex items-center space-x-2">
          <label class="text-sm font-medium text-gray-700">Event Type:</label>
          <select data-action="change->timeline-visualization#filterByType" class="border rounded px-2 py-1">
            <option value="all">All Types</option>
            ${filters.event_types.map(type => `<option value="${type}">${type.charAt(0).toUpperCase() + type.slice(1)}</option>`).join('')}
          </select>
        </div>
        <div class="flex items-center space-x-2">
          <label class="text-sm font-medium text-gray-700">Date Range:</label>
          <select data-action="change->timeline-visualization#filterByDate" class="border rounded px-2 py-1">
            ${filters.date_ranges.map(range => `<option value="${range}">${range.replace('_', ' ').toUpperCase()}</option>`).join('')}
          </select>
        </div>
      </div>
    `
  }

  getEventRadius(event) {
    const baseRadius = 6
    if (event.type === "milestone") return baseRadius + 2
    if (event.type === "conversation") return baseRadius + (event.duration ? Math.min(event.duration / 10, 4) : 0)
    return baseRadius
  }

  getEventColor(event) {
    if (event.color) return event.color
    return this.colorScale(event.type)
  }

  getCurrentStage() {
    // This would come from the deal room data
    return "needs_analysis" // placeholder
  }

  showTooltip(event, data) {
    const tooltip = this.tooltip
    
    tooltip.transition().duration(200).style("opacity", .9)
    tooltip.html(`
      <div class="font-semibold">${data.title}</div>
      <div class="text-sm">${new Date(data.date).toLocaleDateString()}</div>
      <div class="text-sm mt-1">${data.description || ''}</div>
      ${data.duration ? `<div class="text-xs mt-1">Duration: ${data.duration}min</div>` : ''}
    `)
    .style("left", (event.pageX + 10) + "px")
    .style("top", (event.pageY - 28) + "px")
  }

  hideTooltip() {
    this.tooltip.transition().duration(500).style("opacity", 0)
  }

  showEventDetails(event) {
    if (!this.detailsTarget) return
    
    this.detailsTarget.innerHTML = `
      <div class="bg-white p-6 rounded-lg shadow-lg">
        <h3 class="text-lg font-semibold mb-2">${event.title}</h3>
        <p class="text-gray-600 mb-4">${event.description}</p>
        <div class="grid grid-cols-2 gap-4 text-sm">
          <div>
            <span class="font-medium">Date:</span> ${new Date(event.date).toLocaleString()}
          </div>
          <div>
            <span class="font-medium">Type:</span> ${event.type.charAt(0).toUpperCase() + event.type.slice(1)}
          </div>
          ${event.duration ? `<div><span class="font-medium">Duration:</span> ${event.duration} minutes</div>` : ''}
          ${event.participants ? `<div><span class="font-medium">Participants:</span> ${event.participants.join(', ')}</div>` : ''}
        </div>
      </div>
    `
  }

  filterByType(event) {
    const selectedType = event.target.value
    // Implement filtering logic
    this.applyFilters({ type: selectedType })
  }

  filterByDate(event) {
    const selectedRange = event.target.value
    // Implement date filtering logic
    this.applyFilters({ dateRange: selectedRange })
  }

  applyFilters(filters) {
    // Re-render timeline with filtered data
    let filteredEvents = [...this.timelineData.events]
    
    if (filters.type && filters.type !== 'all') {
      filteredEvents = filteredEvents.filter(event => event.type === filters.type)
    }
    
    if (filters.dateRange) {
      const now = new Date()
      let cutoffDate
      
      switch (filters.dateRange) {
        case 'last_7_days':
          cutoffDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000)
          break
        case 'last_30_days':
          cutoffDate = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000)
          break
        default:
          cutoffDate = null
      }
      
      if (cutoffDate) {
        filteredEvents = filteredEvents.filter(event => new Date(event.date) >= cutoffDate)
      }
    }
    
    // Update the visualization with filtered data
    this.renderFilteredTimeline(filteredEvents)
  }

  renderFilteredTimeline(filteredEvents) {
    // Update scales with filtered data
    if (filteredEvents.length > 0) {
      const dateExtent = d3.extent(filteredEvents, d => new Date(d.date))
      this.xScale.domain(dateExtent)
      
      // Re-render with filtered data
      this.renderEvents(filteredEvents)
      this.xAxisGroup.call(d3.axisBottom(this.xScale).tickFormat(d3.timeFormat("%m/%d")))
    }
  }
}