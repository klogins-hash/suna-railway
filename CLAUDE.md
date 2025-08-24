# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Kortix is an open-source platform for building and managing autonomous AI agents. The project is branded as "Suna" - a generalist AI worker. It uses a microservices architecture with Docker containerization for agent sandboxing.

## Development Commands

### Frontend (Next.js)
```bash
# Development
npm run dev          # Start development server with Turbopack
npm run build        # Production build
npm start           # Start production server
npm run lint        # Run ESLint
npm run format      # Run Prettier formatting
npm run format:check # Check formatting without fixing
```

### Backend (Python/FastAPI)
```bash
# API Server
uv run api.py                    # Start FastAPI server
uv run dramatiq run_agent_background  # Start background worker
uv sync                          # Install/sync dependencies

# Setup & Management
python setup.py     # Run interactive setup wizard
python start.py     # Start/stop services based on configuration
```

### Docker Operations
```bash
docker compose up -d    # Start all services
docker compose down     # Stop all services
docker compose logs -f  # View logs
```

### Testing
```bash
# Frontend tests location: frontend/__tests__/
# Backend tests: Use pytest (no test files currently exist)
```

## Architecture Overview

The platform consists of four main components that work together:

### 1. Backend API (`/backend`)
- **FastAPI** server handling REST endpoints and WebSocket connections
- Agent orchestration and thread management
- LLM integration via **LiteLLM** (supports OpenAI, Anthropic, Google, OpenRouter)
- Tool system with MCP (Model Context Protocol) server support
- Credential encryption using Fernet
- Background task processing with **Dramatiq** and Redis

### 2. Frontend Dashboard (`/frontend`)
- **Next.js 15** with React 18 and TypeScript
- Component structure follows feature-based organization in `app/` directory
- Uses **Radix UI** components with **Tailwind CSS** styling
- State management with **Zustand** stores in `lib/stores/`
- API client in `lib/api.ts` using fetch with standard patterns
- Real-time updates via Supabase subscriptions

### 3. Agent Runtime (`/backend/sandbox`)
- Docker containers provide isolated execution environments
- Each agent gets Ubuntu/Debian container with VNC server
- Browser automation capabilities through VNC
- Persistent workspace with file system access
- Integration with Daytona cloud platform for orchestration

### 4. Data Layer
- **Supabase** (PostgreSQL) as primary database
- **Redis** for caching and session management
- Database migrations in `supabase/migrations/` (40+ migrations)
- Row Level Security (RLS) policies for multi-tenancy
- Encrypted credential storage in database

## Key Patterns and Conventions

### API Endpoints
- REST API routes defined in `backend/routes/`
- Standard pattern: `/api/v1/{resource}`
- WebSocket endpoint for real-time agent communication
- Response format: JSON with consistent error handling

### Agent System
- Agents configured via JSON in database
- Tool definitions in `backend/tools/` with XML-based function calling
- MCP servers for extensibility (`backend/mcp_servers/`)
- Agent builder tools in `backend/agent_builder/`

### Frontend Routing
- App Router (Next.js 15) with file-based routing
- Protected routes use middleware authentication
- API calls go through `/api/` proxy to backend

### Database Schema
- User/team multi-tenancy with `user_id` and `team_id` columns
- Agent configurations stored in `agents` table
- Credentials encrypted and stored in `user_credentials`
- Workflow definitions in `workflows` table
- Knowledge base files in `knowledge_files` table

### Security Considerations
- All credentials encrypted before storage
- Webhook signature verification for external triggers
- Supabase Auth with MFA support
- Docker container isolation for agent execution
- Environment variables for sensitive configuration

## Important Files and Locations

- `backend/api.py` - Main FastAPI application entry point
- `backend/routes/` - API endpoint definitions
- `backend/tools/` - Agent tool implementations
- `backend/sandbox/` - Docker container management
- `frontend/app/` - Next.js pages and components
- `frontend/components/` - Reusable UI components
- `frontend/lib/api.ts` - API client implementation
- `frontend/lib/stores/` - Zustand state stores
- `supabase/migrations/` - Database schema migrations
- `.env.example` - Environment variable template

## Development Tips

- Use `uv` for Python dependency management (not pip directly)
- Frontend uses Turbopack for faster development builds
- Check `setup.py` for automated environment configuration
- Agent Docker images follow versioning: `kortix/suna:x.x.x.xx`
- MCP servers can be added for custom tool integrations
- Database changes require new migration files in `supabase/migrations/`