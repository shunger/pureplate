#!/usr/bin/env bash
# Local test script for Cloud Functions via Firebase Emulator
# Usage: ./test-local.sh [chat|plan|both]
#
# Tests chatWithChef and/or generatePlan against a locally running emulator
# with real AWS Bedrock calls (using .secret.local credentials).

set -euo pipefail

PROJECT_ID="pure-pantry-ai"
REGION="us-central1"
EMULATOR_HOST="http://127.0.0.1:5001"
BASE_URL="${EMULATOR_HOST}/${PROJECT_ID}/${REGION}"
TEST_MODE="${1:-both}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log()  { echo -e "${CYAN}[test]${NC} $1"; }
pass() { echo -e "${GREEN}[PASS]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

EMULATOR_PID=""

cleanup() {
  if [ -n "$EMULATOR_PID" ]; then
    log "Stopping emulator (PID $EMULATOR_PID)..."
    kill "$EMULATOR_PID" 2>/dev/null || true
    wait "$EMULATOR_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT

# --- Build ---
log "Building functions..."
cd "$(dirname "$0")"
npm run build 2>&1 | tail -1
log "Build complete."

# --- Start emulator ---
log "Starting Firebase emulator..."
npx firebase-tools emulators:start --only functions --project "$PROJECT_ID" &>"emulator.log" &
EMULATOR_PID=$!

# Wait for emulator to be ready and functions to register
log "Waiting for emulator to start..."
FUNCTIONS_READY=false
for i in $(seq 1 60); do
  # Check if functions have registered by looking at emulator log
  if grep -q "function initialized" emulator.log 2>/dev/null; then
    FUNCTIONS_READY=true
    log "Emulator ready — functions registered."
    break
  fi
  # Also check for load errors
  if grep -q "Could not load" emulator.log 2>/dev/null; then
    fail "Functions failed to load:"
    grep "Could not load\|Error" emulator.log
    exit 1
  fi
  if [ "$i" -eq 60 ]; then
    fail "Emulator did not start within 60 seconds."
    echo "--- emulator.log ---"
    tail -30 emulator.log
    exit 1
  fi
  sleep 1
done

# Extra pause for stability
sleep 1

# --- Sample preference summary ---
read -r -d '' PREFS << 'PREFS_EOF' || true
{
  "family": {
    "adults": 2,
    "kids": 1,
    "kid_age_ranges": ["4-7"],
    "dietary_restrictions": ["gluten-free"],
    "preferred_cook_time": "under30",
    "budget_level": "moderate"
  },
  "pantry_items": [
    {"name": "chicken breast", "quantity": 2, "unit": "lbs", "category": "protein"},
    {"name": "rice", "quantity": 3, "unit": "cups", "category": "grains"},
    {"name": "broccoli", "quantity": 1, "unit": "head", "category": "produce"},
    {"name": "olive oil", "quantity": 500, "unit": "ml", "category": "oils"},
    {"name": "garlic", "quantity": 1, "unit": "bulb", "category": "produce"},
    {"name": "eggs", "quantity": 12, "unit": "count", "category": "dairy"},
    {"name": "tomatoes", "quantity": 4, "unit": "count", "category": "produce"},
    {"name": "onions", "quantity": 3, "unit": "count", "category": "produce"}
  ],
  "expiring_soon": [
    {"name": "chicken breast", "quantity": 2, "unit": "lbs", "expiry_date": "2026-08-10"}
  ],
  "staples_available": ["salt", "pepper", "olive oil", "garlic"],
  "cuisine_affinities": {"Italian": 0.8, "Asian": 0.7, "Mexican": 0.5},
  "loved_ingredients": ["chicken", "garlic"],
  "disliked_ingredients": ["mushrooms", "olives"],
  "favorite_recipes": ["Chicken Stir Fry"],
  "recent_meals_14d": ["Chicken Stir Fry", "Pasta Primavera"],
  "recent_suggestions": []
}
PREFS_EOF

# --- Test chatWithChef ---
test_chat() {
  local message="${1:-Suggest a quick snack for the kids}"
  log "Testing chatWithChef: \"$message\""

  local payload
  payload=$(cat <<EOF
{
  "data": {
    "userMessage": "$message",
    "chatHistory": "",
    "preferenceSummary": $PREFS
  }
}
EOF
)

  local response
  local http_code
  response=$(curl -s -w "\n%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -H "X-Firebase-AppCheck: emulator-debug-token" \
    -d "$payload" \
    "${BASE_URL}/chatWithChef" \
    --max-time 60)

  http_code=$(echo "$response" | tail -1)
  local body
  body=$(echo "$response" | sed '$d')

  if [ "$http_code" = "200" ]; then
    pass "chatWithChef returned 200"
    echo ""
    # Pretty-print if jq is available
    if command -v jq &>/dev/null; then
      echo "$body" | jq '.result.responseText' 2>/dev/null || echo "$body"
      echo ""
      local recipe_count
      recipe_count=$(echo "$body" | jq '.result.recipes | length' 2>/dev/null || echo "?")
      log "Recipes returned: $recipe_count"
      if [ "$recipe_count" != "0" ] && [ "$recipe_count" != "?" ]; then
        echo "$body" | jq '.result.recipes[] | {name, cuisine, description}' 2>/dev/null
      fi
    else
      echo "$body"
    fi
  else
    fail "chatWithChef returned HTTP $http_code"
    echo "$body"
  fi
  echo ""
}

# --- Test generatePlan ---
test_plan() {
  log "Testing generatePlan: 2 days of dinner"

  local payload
  payload=$(cat <<EOF
{
  "data": {
    "feature": "mealPlan",
    "days": 2,
    "dayLabels": ["Monday", "Tuesday"],
    "mealType": "dinner",
    "preferenceSummary": $PREFS
  }
}
EOF
)

  local response
  local http_code
  response=$(curl -s -w "\n%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -H "X-Firebase-AppCheck: emulator-debug-token" \
    -d "$payload" \
    "${BASE_URL}/generatePlan" \
    --max-time 90)

  http_code=$(echo "$response" | tail -1)
  local body
  body=$(echo "$response" | sed '$d')

  if [ "$http_code" = "200" ]; then
    pass "generatePlan returned 200"
    echo ""
    if command -v jq &>/dev/null; then
      local day_count
      day_count=$(echo "$body" | jq '.result.plan.days | length' 2>/dev/null || echo "?")
      log "Days returned: $day_count"
      echo "$body" | jq '.result.plan.days[] | {name: .meal.name, cuisine: .meal.cuisine, description: .meal.description}' 2>/dev/null
      echo ""
      local shopping_count
      shopping_count=$(echo "$body" | jq '.result.shopping_list | length' 2>/dev/null || echo "?")
      log "Shopping list items: $shopping_count"
      echo "$body" | jq '.result.shopping_list[] | .name' 2>/dev/null
    else
      echo "$body"
    fi
  else
    fail "generatePlan returned HTTP $http_code"
    echo "$body"
  fi
  echo ""
}

# --- Run tests ---
echo ""
echo "========================================"
echo "  Pure Pantry AI — Local Function Tests"
echo "========================================"
echo ""

case "$TEST_MODE" in
  chat)
    test_chat "${2:-Suggest a quick snack for the kids}"
    ;;
  plan)
    test_plan
    ;;
  both)
    test_chat "Suggest a quick snack for the kids"
    test_plan
    ;;
  *)
    warn "Unknown test mode: $TEST_MODE"
    echo "Usage: ./test-local.sh [chat|plan|both] [optional chat message]"
    exit 1
    ;;
esac

log "Done."
