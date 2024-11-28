# Django Docker Environment

This repository sets up a Docker environment for an existing Django project. It allows you to continue coding and developing your Django application within a containerized setup.

## Getting Started

Follow the steps below to set up and run your Django project in a Docker environment.

## Prerequisites

- Docker installed on your machine
- Docker Compose installed on your machine

## Setup Instructions

1. **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd django-docker/docker-environment
    ```
2. **Copy the content of the django project folder to the directory or vice versa**
   ````bash
   cp ./<django-project>/* ./
   ````
3. **Copy  `.env_sample` to `.env` and adjust the variables**
   ```bash
   cp .env_sample .env
   nano .env
   ````

4. **Build the Docker images:**
    ```bash
    docker compose build
    ```

5. **Run the Docker containers:**
    ```bash
    docker compose up
    ```

6. **Access the application:**
    Open your browser and navigate to `http://localhost:8000`
