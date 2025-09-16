#!/bin/bash
# 
# 

# --- Load .env file if it exists ---
if [ -f .env ]; then
  echo "Sourcing .env file..."
  export $(grep -v '^#' .env | xargs)
else
  echo "Warning: .env file not found. Relying on environment variables set externally."
fi

cp requirements.txt agent/requirements.txt

# --- Check for required environment variables and assign them ---
REQUIRED_VARS=(
  "GOOGLE_CLOUD_PROJECT"
  "GOOGLE_CLOUD_LOCATION"
  "APP_NAME"
  "SOURCE_DIRECTORY"
  "SERVICE_NAME"
)

for VAR_NAME in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR_NAME}" ]; then # Check if the variable is unset or empty
    echo "Error: Environment variable ${VAR_NAME} is not set. Please define it in your .env file or shell environment." >&2
    exit 1
  fi
done

# WITH_UI_FLAG is optional in its effect, but we'll check if the variable itself is set.
# If it should sometimes be omitted, its value in .env can be an empty string.
if [ -z "${WITH_UI_FLAG+x}" ]; then # Check if WITH_UI_FLAG is set at all
    echo "Warning: WITH_UI_FLAG is not set. Assuming no UI flag. If UI is needed, set WITH_UI_FLAG=\"--with_ui\" in .env or your environment." >&2
    # If WITH_UI_FLAG being completely unset means no flag, that's fine.
    # If it must always be explicitly set (e.g. to "" or "--with_ui"), then this check could also be an error.
    # For now, we'll just use its value, which will be empty if not set.
fi


# Assign variables from environment (already checked for existence for required ones)
PROJECT_ID="${GOOGLE_CLOUD_PROJECT}"
REGION="${GOOGLE_CLOUD_LOCATION}"
# APP_NAME, SOURCE_DIRECTORY, SERVICE_NAME are already available as they were checked.
# WITH_UI_FLAG is also available.

# The GOOGLE_GENAI_USE_VERTEXAI is loaded from .env if present but not directly used in this adk command.
# You can use it in other parts of your scripts if needed:
if [ ! -z "${GOOGLE_GENAI_USE_VERTEXAI}" ]; then
 echo "GOOGLE_GENAI_USE_VERTEXAI is set to: ${GOOGLE_GENAI_USE_VERTEXAI}"
fi


# --- Deployment Command ---
echo "🚀 Starting deployment of '${APP_NAME}' to project '${PROJECT_ID}' in region '${REGION}'..."

adk deploy cloud_run \
  --project="${PROJECT_ID}" \
  --region="${REGION}" \
  ${WITH_UI_FLAG} \
  --app_name "${APP_NAME}" \
  "${SOURCE_DIRECTORY}" \
  --service_name="${SERVICE_NAME}"

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ Deployment command executed successfully."
else
  echo "❌ Deployment command failed with exit code ${EXIT_CODE}." >&2
fi

exit $EXIT_CODE