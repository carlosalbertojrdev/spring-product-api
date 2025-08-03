#!/bin/bash

# Configuration
TOTAL_PRODUCTS=100000
BATCH_SIZE=100
DELAY_BETWEEN_BATCHES=1  # seconds

echo "Starting creation of $TOTAL_PRODUCTS products..."
echo "Batch size: $BATCH_SIZE"
echo "Delay between batches: ${DELAY_BETWEEN_BATCHES}s"
echo ""

# Initialize counters
SUCCESS_COUNT=0
FAILURE_COUNT=0
START_TIME=$(date +%s)

# Function to create a single product
create_product() {
    local product_number=$1
    
    # Generate random product data
    PRODUCT_NAME="Product $product_number"
    PRODUCT_DESCRIPTION="Description for product $product_number"
    PRODUCT_PRICE=$(echo "scale=2; $((RANDOM % 2000 + 100)).$((RANDOM % 100))" | bc)

    # Create JSON payload
    JSON_PAYLOAD=$(cat <<EOF
{
  "name": "$PRODUCT_NAME",
  "description": "$PRODUCT_DESCRIPTION",
  "price": $PRODUCT_PRICE
}
EOF
)

    # Make the API call
    response=$(curl -s -w "%{http_code}" -X 'POST' \
      'http://localhost:8080/api/v1/products' \
      -H 'accept: */*' \
      -H 'Content-Type: application/json' \
      -d "$JSON_PAYLOAD" 2>/dev/null)
    
    
    # Extract HTTP status code (last line)
    http_code=$(echo "$response" | tail -n1)
    # Extract response body (all lines except last)
    response_body=$(echo "$response" | head -n -1)
    
    if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
        echo "✓ Product $product_number created successfully"
        ((SUCCESS_COUNT++))
    else
        echo "✗ Product $product_number failed (HTTP $http_code): $response_body"
        ((FAILURE_COUNT++))
    fi
}

# Main loop to create products
for ((i=1; i<=TOTAL_PRODUCTS; i++)); do
    create_product $i
    
    # Show progress every 1000 products
    if [ $((i % 1000)) -eq 0 ]; then
        current_time=$(date +%s)
        elapsed=$((current_time - START_TIME))
        rate=$(echo "scale=2; $i / $elapsed" | bc)
        echo ""
        echo "Progress: $i/$TOTAL_PRODUCTS products processed"
        echo "Success: $SUCCESS_COUNT, Failures: $FAILURE_COUNT"
        echo "Rate: ${rate} products/second"
        echo "Elapsed time: ${elapsed}s"
        echo ""
    fi
    
    # Add small delay every batch to avoid overwhelming the server
    if [ $((i % BATCH_SIZE)) -eq 0 ]; then
        sleep $DELAY_BETWEEN_BATCHES
    fi
done

# Final summary
END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))
AVERAGE_RATE=$(echo "scale=2; $TOTAL_PRODUCTS / $TOTAL_TIME" | bc)

echo ""
echo "=== FINAL SUMMARY ==="
echo "Total products requested: $TOTAL_PRODUCTS"
echo "Successfully created: $SUCCESS_COUNT"
echo "Failed: $FAILURE_COUNT"
echo "Total time: ${TOTAL_TIME}s"
echo "Average rate: ${AVERAGE_RATE} products/second"
echo "Success rate: $(echo "scale=2; $SUCCESS_COUNT * 100 / $TOTAL_PRODUCTS" | bc)%"
echo "====================" 