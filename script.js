// Simple Interest Calculator
// Formula: SI = (P × R × T) / 100
// Where:
// P = Principal amount
// R = Rate of interest per year
// T = Time in years

document.getElementById('interestForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    // Get input values
    const principal = parseFloat(document.getElementById('principal').value);
    const rate = parseFloat(document.getElementById('rate').value);
    const time = parseFloat(document.getElementById('time').value);
    
    // Validation
    if (isNaN(principal) || principal <= 0) {
        showError('Please enter a valid principal amount (greater than 0)');
        return;
    }
    
    if (isNaN(rate) || rate < 0) {
        showError('Please enter a valid interest rate (0 or greater)');
        return;
    }
    
    if (isNaN(time) || time <= 0) {
        showError('Please enter a valid time period (greater than 0)');
        return;
    }
    
    // Calculate simple interest
    const simpleInterest = (principal * rate * time) / 100;
    const totalAmount = principal + simpleInterest;
    
    // Display results
    document.getElementById('displayPrincipal').textContent = principal.toFixed(2);
    document.getElementById('displayRate').textContent = rate;
    document.getElementById('displayTime').textContent = time;
    document.getElementById('simpleInterest').textContent = simpleInterest.toFixed(2);
    document.getElementById('totalAmount').textContent = totalAmount.toFixed(2);
    
    // Show result section
    document.getElementById('result').classList.remove('hidden');
    
    // Scroll to results
    document.getElementById('result').scrollIntoView({ behavior: 'smooth', block: 'nearest' });
});

function showError(message) {
    // Create error message element if it doesn't exist
    let errorDiv = document.querySelector('.error-message');
    
    if (!errorDiv) {
        errorDiv = document.createElement('div');
        errorDiv.className = 'error-message';
        errorDiv.style.cssText = `
            background: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: center;
            animation: slideIn 0.3s ease;
        `;
        document.querySelector('.calculator-card').appendChild(errorDiv);
    }
    
    errorDiv.textContent = message;
    
    // Remove error after 3 seconds
    setTimeout(() => {
        if (errorDiv) {
            errorDiv.remove();
        }
    }, 3000);
}

function resetForm() {
    // Clear all input fields
    document.getElementById('principal').value = '';
    document.getElementById('rate').value = '';
    document.getElementById('time').value = '';
    
    // Hide result section
    document.getElementById('result').classList.add('hidden');
    
    // Clear any error messages
    const errorDiv = document.querySelector('.error-message');
    if (errorDiv) {
        errorDiv.remove();
    }
}

// Optional: Add input formatting to prevent negative values
document.getElementById('principal').addEventListener('input', function() {
    if (this.value < 0) this.value = 0;
});

document.getElementById('rate').addEventListener('input', function() {
    if (this.value < 0) this.value = 0;
});

document.getElementById('time').addEventListener('input', function() {
    if (this.value < 0) this.value = 0;
});

// Add keyboard shortcut (Enter key to calculate)
document.querySelectorAll('input').forEach(input => {
    input.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            document.getElementById('interestForm').dispatchEvent(new Event('submit'));
        }
    });
});