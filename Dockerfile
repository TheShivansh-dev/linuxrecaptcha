# Start with a minimal Python 3.12 image
FROM python:3.12-slim  

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install system dependencies for Playwright and X11 forwarding
RUN apt-get update && apt-get install -y \
    chromium \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpangocairo-1.0-0 \
    libcups2 \
    libxkbcommon0 \
    fonts-freefont-ttf \
    x11-apps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip to the latest version
RUN pip install --upgrade pip

# Install Playwright and any other Python dependencies
RUN pip install --no-cache-dir playwright
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright browsers and required dependencies
RUN playwright install && playwright install-deps

# Set environment variables for X11 forwarding
ENV DISPLAY=:99

# Expose the port the app runs on
EXPOSE 8080

# Run the application
CMD ["python", "./app.py"]
