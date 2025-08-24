# Backend-only Dockerfile for Railway deployment
FROM python:3.11-slim as base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Set working directory
WORKDIR /app

# Copy backend files
COPY backend/ ./backend/
COPY start.py ./

# Install Python dependencies for backend
WORKDIR /app/backend
RUN uv sync

# Set final working directory
WORKDIR /app

# Expose port
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:$PORT/health || exit 1

# Railway deployment - start backend directly
WORKDIR /app/backend
CMD ["uv", "run", "gunicorn", "api:app", "--workers", "2", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:$PORT", "--timeout", "1800"]
