#!/bin/bash

# Simple Interest Calculator
# Formula: Simple Interest = (Principal × Rate × Time) / 100
# Total Amount = Principal + Simple Interest

# Color codes for better output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display banner
display_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║           SIMPLE INTEREST CALCULATOR                     ║"
    echo "║                                                          ║"
    echo "║     Formula: SI = (P × R × T) / 100                      ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to validate input (positive numbers only)
validate_input() {
    local value=$1
    local field_name=$2
    
    # Check if input is empty
    if [[ -z "$value" ]]; then
        echo -e "${RED}Error: $field_name cannot be empty!${NC}"
        return 1
    fi
    
    # Check if input is a valid number (allows decimals)
    if ! [[ "$value" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        echo -e "${RED}Error: $field_name must be a valid positive number!${NC}"
        return 1
    fi
    
    # Check if number is greater than 0
    if (( $(echo "$value <= 0" | bc -l) )); then
        echo -e "${RED}Error: $field_name must be greater than 0!${NC}"
        return 1
    fi
    
    return 0
}

# Function to calculate simple interest
calculate_interest() {
    local principal=$1
    local rate=$2
    local time=$3
    
    # Calculate simple interest using bc for floating point arithmetic
    # Formula: SI = (P × R × T) / 100
    local simple_interest=$(echo "scale=2; ($principal * $rate * $time) / 100" | bc -l)
    
    # Calculate total amount
    local total_amount=$(echo "scale=2; $principal + $simple_interest" | bc -l)
    
    echo "$simple_interest|$total_amount"
}

# Function to display results
display_results() {
    local principal=$1
    local rate=$2
    local time=$3
    local simple_interest=$4
    local total_amount=$5
    
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    CALCULATION RESULTS                    ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "${BLUE}┌────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│${NC} ${YELLOW}Input Details:${NC}                                              ${BLUE}│${NC}"
    echo -e "${BLUE}├────────────────────────────────────────────────────────┤${NC}"
    printf "${BLUE}│${NC} Principal Amount:      %15s %-20s ${BLUE}│${NC}\n" "$principal" "$"
    printf "${BLUE}│${NC} Rate of Interest:      %15s %-20s ${BLUE}│${NC}\n" "$rate" "%"
    printf "${BLUE}│${NC} Time Period:           %15s %-20s ${BLUE}│${NC}\n" "$time" "years"
    echo -e "${BLUE}├────────────────────────────────────────────────────────┤${NC}"
    
    echo -e "${BLUE}│${NC} ${GREEN}Results:${NC}                                                ${BLUE}│${NC}"
    echo -e "${BLUE}├────────────────────────────────────────────────────────┤${NC}"
    printf "${BLUE}│${NC} ${PURPLE}Simple Interest:${NC}       %15s %-20s ${BLUE}│${NC}\n" "$simple_interest" "$"
    printf "${BLUE}│${NC} ${PURPLE}Total Amount:${NC}          %15s %-20s ${BLUE}│${NC}\n" "$total_amount" "$"
    echo -e "${BLUE}└────────────────────────────────────────────────────────┘${NC}"
    
    # Additional breakdown
    echo -e "\n${CYAN}📊 Calculation Breakdown:${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────────${NC}"
    echo -e "  Simple Interest = ($principal × $rate × $time) / 100"
    echo -e "  Simple Interest = $(echo "scale=2; $principal * $rate * $time" | bc -l) / 100"
    echo -e "  Simple Interest = $simple_interest"
    echo -e "  Total Amount = $principal + $simple_interest = $total_amount"
    echo -e "${CYAN}────────────────────────────────────────────────────────${NC}\n"
}

# Main function
main() {
    clear
    display_banner
    
    # Method 1: Accept command line arguments
    if [[ $# -eq 3 ]]; then
        echo -e "${YELLOW}Using command line arguments...${NC}\n"
        principal=$1
        rate=$2
        time=$3
        
        # Validate command line arguments
        if validate_input "$principal" "Principal" && \
           validate_input "$rate" "Rate of Interest" && \
           validate_input "$time" "Time Period"; then
            
            # Calculate interest
            IFS='|' read -r simple_interest total_amount <<< "$(calculate_interest "$principal" "$rate" "$time")"
            
            # Display results
            display_results "$principal" "$rate" "$time" "$simple_interest" "$total_amount"
        else
            echo -e "${RED}Invalid input provided. Please check your arguments.${NC}"
            echo -e "${YELLOW}Usage: ./simple-interest.sh <principal> <rate> <time>${NC}"
            exit 1
        fi
    
    # Method 2: Interactive input (default)
    else
        echo -e "${YELLOW}Interactive Mode: Please enter the following details:${NC}\n"
        
        # Get principal amount
        while true; do
            echo -ne "${CYAN}Enter Principal Amount: ${NC}"
            read principal
            if validate_input "$principal" "Principal"; then
                break
            fi
        done
        
        # Get rate of interest
        while true; do
            echo -ne "${CYAN}Enter Rate of Interest (%): ${NC}"
            read rate
            if validate_input "$rate" "Rate of Interest"; then
                break
            fi
        done
        
        # Get time period
        while true; do
            echo -ne "${CYAN}Enter Time Period (years): ${NC}"
            read time
            if validate_input "$time" "Time Period"; then
                break
            fi
        done
        
        # Calculate interest
        IFS='|' read -r simple_interest total_amount <<< "$(calculate_interest "$principal" "$rate" "$time")"
        
        # Display results
        display_results "$principal" "$rate" "$time" "$simple_interest" "$total_amount"
    fi
    
    # Option to calculate again
    echo -ne "${YELLOW}Would you like to calculate again? (y/n): ${NC}"
    read -r again
    if [[ "$again" =~ ^[Yy]$ ]]; then
        main
    else
        echo -e "\n${GREEN}Thank you for using the Simple Interest Calculator! Goodbye! 👋${NC}\n"
        exit 0
    fi
}

# Display usage information
show_usage() {
    echo -e "${CYAN}Simple Interest Calculator - Usage:${NC}"
    echo "  ./simple-interest.sh                    # Interactive mode"
    echo "  ./simple-interest.sh <principal> <rate> <time>  # Command line mode"
    echo ""
    echo "Examples:"
    echo "  ./simple-interest.sh 1000 5 3           # Calculate interest for $1000 at 5% for 3 years"
    echo "  ./simple-interest.sh 2500 7.5 2         # Calculate interest for $2500 at 7.5% for 2 years"
    echo ""
}

# Check if help is requested
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

# Check if bc is installed (required for floating point calculations)
if ! command -v bc &> /dev/null; then
    echo -e "${RED}Error: 'bc' command not found.${NC}"
    echo -e "${YELLOW}Please install bc using:${NC}"
    echo "  Ubuntu/Debian: sudo apt-get install bc"
    echo "  CentOS/RHEL:   sudo yum install bc"
    echo "  macOS:         brew install bc"
    exit 1
fi

# Run the main function with all arguments
main "$@"
