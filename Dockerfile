# Start from a Python image
FROM python:3.11-slim

# Install dependencies required for Chrome and ChromeDriver
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libvulkan1 \
    libx11-6 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Download and install Google Chrome
RUN wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i /tmp/google-chrome.deb && \
    apt-get -f install -y && \
    rm /tmp/google-chrome.deb

# Debugging: Check if Google Chrome is installed and where it's located
RUN echo "Checking if Google Chrome is installed..." && \
    ls -l /usr/bin/ && \
    which google-chrome-stable || echo "Google Chrome not found" && \
    google-chrome-stable --version || echo "Google Chrome installation failed"

# Install ChromeDriver
RUN CHROME_VERSION=$(google-chrome-stable --version | sed 's/[^0-9]*\([0-9.]*\).*/\1/') && \
    CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") && \
    wget -q -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Install Python dependencies (e.g., Selenium)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Set up the working directory and copy the current files
WORKDIR /app
COPY . .

# Set the default command (if you have a test script)
CMD ["python", "your_test_script.py"]
