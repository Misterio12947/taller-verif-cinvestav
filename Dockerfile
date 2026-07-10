# Dockerfile — Slidev para el Curso Propedéutico de Functional Verification
# Uso:
#   docker build -t verif-propedeutico .
#   docker run --rm -it -p 3030:3030 -v "$PWD":/slides verif-propedeutico

FROM node:20-alpine

WORKDIR /slides

# Dependencias del sistema para Playwright/Chromium (necesario para exportar PDF)
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    bash \
    git

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Slidev + tema + addons
RUN npm install -g \
    @slidev/cli@latest \
    @slidev/theme-default@latest \
    @slidev/theme-seriph@latest \
    playwright-chromium

EXPOSE 3030

# Por defecto arranca el servidor de slides
CMD ["slidev", "slides.md", "--remote", "--port", "3030"]
