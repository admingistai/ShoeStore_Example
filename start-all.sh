#!/bin/bash

# VERTEX Athletic Website Launcher
# This script starts the website

echo "🚀 Starting VERTEX Athletic Website..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to clean up existing processes on required ports
cleanup_ports() {
    echo -e "${YELLOW}🧹 Cleaning up existing processes...${NC}"
    
    # Kill any existing processes on port 3000
    if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${BLUE}   Killing process on port 3000${NC}"
        lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    fi
    
    # Also kill any remaining Next.js processes
    pkill -f "next dev" 2>/dev/null || true
    
    # Wait a moment for processes to fully terminate
    sleep 2
    echo -e "${GREEN}✅ Cleanup completed${NC}"
    echo ""
}

# Function to clean up processes on exit
cleanup() {
    echo ""
    echo -e "${YELLOW}🛑 Shutting down the website...${NC}"
    
    # Kill the website process
    if [ ! -z "$WEBSITE_PID" ]; then
        echo -e "${BLUE}   Stopping website (PID: $WEBSITE_PID)${NC}"
        kill $WEBSITE_PID 2>/dev/null
    fi
    
    # Wait a moment for graceful shutdown
    sleep 2
    
    # Force kill if still running
    pkill -f "next dev" 2>/dev/null
    
    echo -e "${GREEN}✅ Website stopped${NC}"
    exit 0
}

# Set up trap to call cleanup on exit
trap cleanup SIGINT SIGTERM EXIT

# Clean up any existing processes first
cleanup_ports

echo -e "${BLUE}📊 Starting the website on:${NC}"
echo -e "${BLUE}   • Website:        http://localhost:3000${NC}"
echo ""

# Start the main website (Next.js)
echo -e "${GREEN}🌐 Starting VERTEX Athletic website...${NC}"
npm run dev > website.log 2>&1 &
WEBSITE_PID=$!
echo -e "${BLUE}   Website PID: $WEBSITE_PID${NC}"

# Wait a moment for the website to start
sleep 5

echo ""
echo -e "${GREEN}🎉 Website started successfully!${NC}"
echo ""
echo -e "${YELLOW}📝 Access your website:${NC}"
echo -e "${BLUE}   • Main Website:   http://localhost:3000${NC}"
echo ""
echo -e "${YELLOW}📋 Log file:${NC}"
echo -e "${BLUE}   • Website:        ./website.log${NC}"
echo ""
echo -e "${YELLOW}⏹️  Press Ctrl+C to stop the website${NC}"
echo ""

# Monitor process and wait
while true; do
    # Check if the process has died
    if ! kill -0 $WEBSITE_PID 2>/dev/null; then
        echo -e "${RED}❌ Website process died${NC}"
        break
    fi
    
    sleep 5
done

# If we get here, something went wrong
echo -e "${RED}❌ The website stopped unexpectedly${NC}"
echo -e "${YELLOW}📋 Check the log file for more information${NC}"