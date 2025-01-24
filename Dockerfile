ARG BASE=node:20.18.0
FROM ${BASE} AS base

WORKDIR /app

# Install dependencies (this step is cached as long as the dependencies don't change)
COPY package.json pnpm-lock.yaml ./

RUN corepack enable pnpm && pnpm install

# Copy the rest of your app's source code
COPY . .

# Expose the port the app runs on
EXPOSE 5173

# Production image
FROM base AS agent-reid-production

# Set non-sensitive build arguments with defaults
ARG VITE_LOG_LEVEL=debug
# Declare runtime environment variables (values to be provided at runtime)
ENV WRANGLER_SEND_METRICS=false \
  GROQ_API_KEY= \
  HUGGINGFACE_API_KEY= \
  OPENAI_API_KEY= \
  # ANTHROPIC_API_KEY= \
  OPEN_ROUTER_API_KEY= \
  GOOGLE_GENERATIVE_AI_API_KEY= \
  OLLAMA_API_BASE_URL= \
  XAI_API_KEY= \
  TOGETHER_API_KEY= \
  TOGETHER_API_BASE_URL= \
  # AWS_BEDROCK_CONFIG= \
  VITE_LOG_LEVEL=${VITE_LOG_LEVEL} \
  DEFAULT_NUM_CTX= \
  RUNNING_IN_DOCKER=true

# Pre-configure wrangler to disable metrics
RUN mkdir -p /root/.config/.wrangler && \
  echo '{"enabled":false}' > /root/.config/.wrangler/metrics.json

RUN pnpm run build

CMD ["pnpm", "run", "dockerstart"]

# Development image
FROM base AS agent-reid-development

# Development environment variables will be provided at runtime
ENV VITE_LOG_LEVEL=${VITE_LOG_LEVEL} \
  RUNNING_IN_DOCKER=true

RUN mkdir -p /app/run
CMD ["pnpm", "run", "dev", "--host"]
