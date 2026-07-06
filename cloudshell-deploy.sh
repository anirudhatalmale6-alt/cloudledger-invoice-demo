#!/bin/bash
echo "=== SolidInvoice Quick Deploy ==="
mkdir -p ~/solidinvoice && cd ~/solidinvoice

cat > docker-compose.yml << 'YML'
services:
  db:
    image: mysql:8.0
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_DATABASE: solidinvoice
      MYSQL_ROOT_PASSWORD: SolidInvoice2026
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 10

  app:
    image: solidinvoice/solidinvoice:latest
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8080:8765"
    restart: always
    volumes:
      - app_data:/etc/solidinvoice
    environment:
      DATABASE_URL: "mysql://root:SolidInvoice2026@db:3306/solidinvoice"

volumes:
  db_data: {}
  app_data: {}
YML

echo "Starting services..."
docker compose up -d
echo ""
echo "Waiting for MySQL to be ready..."
sleep 20
echo ""
echo "============================================"
echo "  SolidInvoice is starting!"
echo "  Click Web Preview (top right) > Port 8080"
echo "============================================"
