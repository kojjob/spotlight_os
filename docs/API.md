# API Documentation

## Overview

The Spotlight OS API provides RESTful endpoints for managing AI assistants, leads, conversations, and appointments. The API follows Rails conventions with JSON responses and uses standard HTTP status codes.

## Authentication

### Devise Token Authentication

All API endpoints require authentication using Devise session cookies or API tokens.

#### Authentication Headers
```http
Content-Type: application/json
Accept: application/json
X-CSRF-Token: [csrf-token]
```

#### Authentication Flow
```http
POST /users/sign_in
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "password"
  }
}
```

## Base URL

```
Development: http://localhost:3000/api/v1
Production: https://your-domain.com/api/v1
```

## Response Format

### Success Response
```json
{
  "data": {
    "id": "uuid",
    "type": "assistant",
    "attributes": {
      "name": "Sales Assistant",
      "tone": "professional"
    }
  },
  "meta": {
    "timestamp": "2025-05-27T10:30:00Z"
  }
}
```

### Error Response
```json
{
  "errors": [
    {
      "status": "422",
      "title": "Validation Error",
      "detail": "Name can't be blank",
      "source": {
        "pointer": "/data/attributes/name"
      }
    }
  ]
}
```

## API Endpoints

### Users

#### Get Current User
```http
GET /api/v1/user
```

**Response:**
```json
{
  "data": {
    "id": "uuid",
    "type": "user",
    "attributes": {
      "name": "John Doe",
      "email": "john@example.com",
      "company": "Acme Corp",
      "role": "sales_rep",
      "created_at": "2025-01-01T00:00:00Z"
    }
  }
}
```

#### Update User Profile
```http
PATCH /api/v1/user
Content-Type: application/json

{
  "user": {
    "name": "John Smith",
    "company": "New Company"
  }
}
```

### Assistants

#### List Assistants
```http
GET /api/v1/assistants
```

**Query Parameters:**
- `page` (integer): Page number (default: 1)
- `per_page` (integer): Items per page (default: 25, max: 100)
- `sort` (string): Sort field (name, created_at, updated_at)
- `order` (string): Sort order (asc, desc)

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "type": "assistant",
      "attributes": {
        "name": "Sales Assistant",
        "tone": "professional",
        "role": "sales_rep",
        "script": "Hello, I'm calling about...",
        "voice_settings": {
          "voice_id": "eleven_labs_voice_id",
          "speed": 1.0,
          "pitch": 1.0
        },
        "created_at": "2025-01-01T00:00:00Z",
        "updated_at": "2025-01-01T00:00:00Z"
      },
      "relationships": {
        "user": {
          "data": {
            "id": "user_uuid",
            "type": "user"
          }
        }
      }
    }
  ],
  "meta": {
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_count": 120,
      "per_page": 25
    }
  }
}
```

#### Get Assistant
```http
GET /api/v1/assistants/{id}
```

#### Create Assistant
```http
POST /api/v1/assistants
Content-Type: application/json

{
  "assistant": {
    "name": "New Sales Assistant",
    "tone": "friendly",
    "role": "sales_rep",
    "script": "Hello, I'm calling to discuss...",
    "voice_settings": {
      "voice_id": "eleven_labs_voice_id",
      "speed": 1.0,
      "pitch": 1.0
    }
  }
}
```

#### Update Assistant
```http
PATCH /api/v1/assistants/{id}
Content-Type: application/json

{
  "assistant": {
    "name": "Updated Assistant Name",
    "script": "Updated script content..."
  }
}
```

#### Delete Assistant
```http
DELETE /api/v1/assistants/{id}
```

### Leads

#### List Leads
```http
GET /api/v1/leads
```

**Query Parameters:**
- `assistant_id` (uuid): Filter by assistant
- `status` (string): Filter by qualification status (new, qualified, proposal, closed)
- `source` (string): Filter by lead source
- `page` (integer): Page number
- `per_page` (integer): Items per page

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "type": "lead",
      "attributes": {
        "name": "Jane Smith",
        "email": "jane@company.com",
        "phone": "+1234567890",
        "source": "website",
        "status": "new",
        "qualified": false,
        "score": 75,
        "metadata": {
          "company": "Tech Corp",
          "industry": "Technology"
        },
        "created_at": "2025-01-01T00:00:00Z",
        "updated_at": "2025-01-01T00:00:00Z"
      },
      "relationships": {
        "assistant": {
          "data": {
            "id": "assistant_uuid",
            "type": "assistant"
          }
        }
      }
    }
  ]
}
```

#### Get Lead
```http
GET /api/v1/leads/{id}
```

#### Create Lead
```http
POST /api/v1/leads
Content-Type: application/json

{
  "lead": {
    "name": "New Lead",
    "email": "lead@example.com",
    "phone": "+1234567890",
    "source": "referral",
    "assistant_id": "assistant_uuid",
    "metadata": {
      "company": "Example Corp",
      "industry": "Technology"
    }
  }
}
```

#### Update Lead
```http
PATCH /api/v1/leads/{id}
Content-Type: application/json

{
  "lead": {
    "status": "qualified",
    "qualified": true,
    "score": 85
  }
}
```

#### Update Lead Status
```http
PATCH /api/v1/leads/{id}/status
Content-Type: application/json

{
  "status": "qualified"
}
```

### Conversations

#### List Conversations
```http
GET /api/v1/conversations
```

**Query Parameters:**
- `lead_id` (uuid): Filter by lead
- `assistant_id` (uuid): Filter by assistant
- `date_from` (date): Filter conversations from date
- `date_to` (date): Filter conversations to date
- `page` (integer): Page number
- `per_page` (integer): Items per page

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "type": "conversation",
      "attributes": {
        "source": "phone_call",
        "duration": 180,
        "score": 8.5,
        "sentiment": "positive",
        "status": "completed",
        "metadata": {
          "call_id": "external_call_id",
          "quality_score": 9.2
        },
        "started_at": "2025-01-01T10:00:00Z",
        "ended_at": "2025-01-01T10:03:00Z",
        "created_at": "2025-01-01T10:03:30Z"
      },
      "relationships": {
        "lead": {
          "data": {
            "id": "lead_uuid",
            "type": "lead"
          }
        },
        "assistant": {
          "data": {
            "id": "assistant_uuid",
            "type": "assistant"
          }
        }
      }
    }
  ]
}
```

#### Get Conversation
```http
GET /api/v1/conversations/{id}
```

**Response includes transcripts:**
```json
{
  "data": {
    "id": "uuid",
    "type": "conversation",
    "attributes": {
      "source": "phone_call",
      "duration": 180,
      "score": 8.5
    },
    "relationships": {
      "transcripts": {
        "data": [
          {
            "id": "transcript_uuid",
            "type": "transcript"
          }
        ]
      }
    }
  },
  "included": [
    {
      "id": "transcript_uuid",
      "type": "transcript",
      "attributes": {
        "content": "Hello, how can I help you today?",
        "speaker": "assistant",
        "sentiment": "neutral",
        "confidence": 0.95,
        "timestamp": 0.0,
        "created_at": "2025-01-01T10:00:05Z"
      }
    }
  ]
}
```

#### Create Conversation
```http
POST /api/v1/conversations
Content-Type: application/json

{
  "conversation": {
    "lead_id": "lead_uuid",
    "assistant_id": "assistant_uuid",
    "source": "phone_call",
    "metadata": {
      "call_id": "external_call_id"
    }
  }
}
```

#### Update Conversation
```http
PATCH /api/v1/conversations/{id}
Content-Type: application/json

{
  "conversation": {
    "score": 9.0,
    "status": "completed",
    "duration": 240
  }
}
```

### Transcripts

#### List Transcripts for Conversation
```http
GET /api/v1/conversations/{conversation_id}/transcripts
```

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "type": "transcript",
      "attributes": {
        "content": "Hello, how can I help you today?",
        "speaker": "assistant",
        "sentiment": "neutral",
        "confidence": 0.95,
        "timestamp": 0.0,
        "metadata": {
          "emotions": ["neutral"],
          "keywords": ["help", "today"]
        },
        "created_at": "2025-01-01T10:00:05Z"
      }
    }
  ]
}
```

#### Create Transcript
```http
POST /api/v1/conversations/{conversation_id}/transcripts
Content-Type: application/json

{
  "transcript": {
    "content": "Thank you for your time today.",
    "speaker": "assistant",
    "timestamp": 175.5,
    "sentiment": "positive",
    "confidence": 0.98
  }
}
```

### Appointments

#### List Appointments
```http
GET /api/v1/appointments
```

**Query Parameters:**
- `lead_id` (uuid): Filter by lead
- `assistant_id` (uuid): Filter by assistant
- `status` (string): Filter by status (scheduled, completed, cancelled)
- `date_from` (date): Filter appointments from date
- `date_to` (date): Filter appointments to date

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "type": "appointment",
      "attributes": {
        "scheduled_at": "2025-01-02T14:00:00Z",
        "duration": 60,
        "status": "scheduled",
        "external_link": "https://calendly.com/meeting/abc123",
        "metadata": {
          "meeting_type": "demo",
          "timezone": "America/New_York"
        },
        "created_at": "2025-01-01T10:00:00Z",
        "updated_at": "2025-01-01T10:00:00Z"
      },
      "relationships": {
        "lead": {
          "data": {
            "id": "lead_uuid",
            "type": "lead"
          }
        },
        "assistant": {
          "data": {
            "id": "assistant_uuid",
            "type": "assistant"
          }
        }
      }
    }
  ]
}
```

#### Create Appointment
```http
POST /api/v1/appointments
Content-Type: application/json

{
  "appointment": {
    "lead_id": "lead_uuid",
    "assistant_id": "assistant_uuid",
    "scheduled_at": "2025-01-02T14:00:00Z",
    "duration": 60,
    "metadata": {
      "meeting_type": "demo",
      "timezone": "America/New_York"
    }
  }
}
```

#### Update Appointment
```http
PATCH /api/v1/appointments/{id}
Content-Type: application/json

{
  "appointment": {
    "status": "completed",
    "scheduled_at": "2025-01-02T15:00:00Z"
  }
}
```

## WebSocket API (ActionCable)

### Connection

```javascript
import consumer from "./consumer"

const subscription = consumer.subscriptions.create("ConversationChannel", {
  connected() {
    console.log("Connected to conversation channel")
  },
  
  disconnected() {
    console.log("Disconnected from conversation channel")
  },
  
  received(data) {
    // Handle real-time updates
    this.updateConversation(data)
  }
})
```

### Channels

#### ConversationChannel
- Real-time transcript updates
- Conversation status changes
- Sentiment analysis results

#### LeadChannel
- Lead status updates
- Score changes
- New lead notifications

#### NotificationChannel
- System notifications
- Alert messages
- Activity updates

### Message Format

```json
{
  "type": "transcript_update",
  "conversation_id": "uuid",
  "data": {
    "id": "transcript_uuid",
    "content": "New transcript content",
    "speaker": "human",
    "sentiment": "positive",
    "timestamp": 45.2
  }
}
```

## Error Handling

### HTTP Status Codes

- `200` - OK
- `201` - Created
- `204` - No Content
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Unprocessable Entity
- `429` - Too Many Requests
- `500` - Internal Server Error

### Error Response Format

```json
{
  "errors": [
    {
      "status": "422",
      "title": "Validation Error",
      "detail": "Name can't be blank",
      "source": {
        "pointer": "/data/attributes/name"
      },
      "meta": {
        "field": "name",
        "code": "blank"
      }
    }
  ]
}
```

### Common Error Scenarios

#### Validation Errors
```json
{
  "errors": [
    {
      "status": "422",
      "title": "Validation Error",
      "detail": "Email has already been taken",
      "source": {
        "pointer": "/data/attributes/email"
      }
    }
  ]
}
```

#### Authentication Errors
```json
{
  "errors": [
    {
      "status": "401",
      "title": "Authentication Error",
      "detail": "Invalid email or password"
    }
  ]
}
```

#### Authorization Errors
```json
{
  "errors": [
    {
      "status": "403",
      "title": "Authorization Error",
      "detail": "You don't have permission to access this resource"
    }
  ]
}
```

#### Rate Limiting
```json
{
  "errors": [
    {
      "status": "429",
      "title": "Rate Limit Exceeded",
      "detail": "Too many requests. Please try again later.",
      "meta": {
        "retry_after": 60
      }
    }
  ]
}
```

## Rate Limiting

### Limits
- **Authentication endpoints**: 5 requests per minute per IP
- **API endpoints**: 100 requests per minute per user
- **WebSocket connections**: 10 concurrent connections per user

### Headers
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995200
```

## Pagination

### Request Parameters
```http
GET /api/v1/leads?page=2&per_page=50
```

### Response Meta
```json
{
  "meta": {
    "pagination": {
      "current_page": 2,
      "total_pages": 10,
      "total_count": 500,
      "per_page": 50,
      "prev_page": 1,
      "next_page": 3
    }
  }
}
```

### Link Headers
```http
Link: <https://api.example.com/leads?page=1&per_page=50>; rel="first",
      <https://api.example.com/leads?page=1&per_page=50>; rel="prev",
      <https://api.example.com/leads?page=3&per_page=50>; rel="next",
      <https://api.example.com/leads?page=10&per_page=50>; rel="last"
```

## Filtering and Searching

### Filter Parameters
```http
GET /api/v1/leads?status=qualified&source=website&created_after=2025-01-01
```

### Search Parameters
```http
GET /api/v1/leads?search=john&search_fields=name,email,company
```

### Sorting
```http
GET /api/v1/leads?sort=created_at&order=desc
```

## File Uploads

### Audio File Upload
```http
POST /api/v1/conversations/{id}/audio
Content-Type: multipart/form-data

{
  "audio_file": [binary data],
  "duration": 180,
  "format": "mp3"
}
```

### Voice Sample Upload
```http
POST /api/v1/assistants/{id}/voice_sample
Content-Type: multipart/form-data

{
  "voice_sample": [binary data],
  "format": "wav",
  "duration": 10
}
```

## Webhook Integration

### Webhook Endpoints

#### Conversation Events
```http
POST /webhooks/conversations
Content-Type: application/json

{
  "event": "conversation.completed",
  "data": {
    "conversation_id": "uuid",
    "lead_id": "uuid",
    "score": 8.5,
    "duration": 180
  },
  "timestamp": "2025-01-01T10:03:00Z"
}
```

#### Lead Events
```http
POST /webhooks/leads
Content-Type: application/json

{
  "event": "lead.qualified",
  "data": {
    "lead_id": "uuid",
    "score": 85,
    "qualification_criteria": ["budget", "authority", "need"]
  },
  "timestamp": "2025-01-01T10:00:00Z"
}
```

### Webhook Security

All webhooks include HMAC signature verification:

```http
X-Signature: sha256=signature_hash
X-Timestamp: 1640995200
```

## SDK Examples

### JavaScript/TypeScript
```typescript
import { SpotlightAPI } from '@spotlight/api-client'

const client = new SpotlightAPI({
  baseURL: 'https://api.spotlight.com/v1',
  apiKey: 'your-api-key'
})

// Create a new assistant
const assistant = await client.assistants.create({
  name: 'Sales Assistant',
  tone: 'professional',
  script: 'Hello, I\'m calling about...'
})

// Get conversations with real-time updates
const conversations = await client.conversations.list({
  lead_id: 'lead-uuid'
})
```

### Ruby
```ruby
require 'spotlight_api'

client = SpotlightAPI::Client.new(
  base_url: 'https://api.spotlight.com/v1',
  api_key: 'your-api-key'
)

# Create a new lead
lead = client.leads.create(
  name: 'Jane Doe',
  email: 'jane@example.com',
  assistant_id: 'assistant-uuid'
)
```

### Python
```python
from spotlight_api import SpotlightClient

client = SpotlightClient(
    base_url='https://api.spotlight.com/v1',
    api_key='your-api-key'
)

# Get conversation analytics
analytics = client.conversations.analytics(
    date_from='2025-01-01',
    date_to='2025-01-31'
)
```
