# GCP MLE Tutor Agent

This agent is a tutor designed to help users study for the Google Cloud Professional Machine Learning Engineer (MLE) exam. It uses a "Quiz, Check, Explain" (Q.C.E.) method to test your knowledge, provide immediate feedback, and teach you the concepts you don't know.

The agent leverages a Retrieval-Augmented Generation (RAG) model to pull information from the official GCP MLE study guides, ensuring the information is accurate and relevant.

## How it Works

The agent follows a three-step process for each topic:

1.  **Quiz:** The agent starts by asking you a challenging, scenario-based question, similar to what you might see on the actual exam.
2.  **Check:** The agent evaluates your answer and provides feedback. If you're correct, it will ask a follow-up question to deepen your understanding. If you're incorrect, it will provide a hint and ask you to try again.
3.  **Explain:** The agent provides a clear and concise explanation of the core concept, using the study guides as a source of truth.

## Deployment

To deploy the agent, you will need to have the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and configured.

1.  **Create a `.env` file:** Create a file named `.env` in the root of the project and add the following environment variables:

    ```
    GOOGLE_CLOUD_PROJECT="your-gcp-project-id"
    GOOGLE_CLOUD_LOCATION="your-gcp-region"
    APP_NAME="mle-tutor-agent"
    SOURCE_DIRECTORY="agent"
    SERVICE_NAME="mle-tutor-agent-service"
    WITH_UI_FLAG="--with_ui" # or "" if you don't want a UI
    ```

2.  **Run the deployment script:**

    ```bash
    ./deploy.sh
    ```

## Usage

Once deployed, you can interact with the agent through the provided UI or by sending requests to the Cloud Run service endpoint.
