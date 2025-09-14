# Django To-Do App (Containerized & Cloud-Ready)

# Overview

This project is a **Django-based To-Do application** with:

- Task model: `title`, `completed` flag, `created` timestamp.
- Full CRUD functionality (Create, Read, Update, Delete tasks).
- Admin panel enabled.
- Minimal Bootstrap templates for frontend.
- Containerized using Docker and Docker Compose.
- Deployable to **Google Cloud Run**.

The project demonstrates **DevOps & Cloud concepts**, including containerization, environment management, and cloud deployment.

---

## Folder Structure

todo_app/
│
├─ tasks/ # Django app for tasks
│ ├─ migrations/
│ ├─ templates/tasks/
│ ├─ models.py
│ ├─ views.py
│ ├─ urls.py
│ └─ ...
│
├─ todo/ # Django project folder
│ ├─ settings.py
│ ├─ urls.py
│ └─ wsgi.py
│
├─ venv/ # Python virtual environment (ignored in Git)
├─ staticfiles/ # Collected static files (ignored in Git)
├─ Dockerfile # Docker image definition
├─ docker-compose.yml # Local multi-container setup
├─ entrypoint.sh # Container entrypoint for Django migrations/start
├─ requirements.txt # Python dependencies
├─ .gitignore # Ignored files (.env, db.sqlite3, logs, etc.)
└─ README.md


---

## Local Setup (Development)

1. **Clone the repo**:
```bash
git clone <repo-url>
cd todo_app

2. Create Python virtual environment:
python -m venv venv
# Linux/Mac
source venv/bin/activate
# Windows PowerShell
.\venv\Scripts\activate

3. Install dependencies:
pip install -r requirements.txt

4. Create Django project & app (if starting fresh):
django-admin startproject todo .
python manage.py startapp tasks

5. Add tasks to INSTALLED_APPS in settings.py.

6. Create Task model in tasks/models.py:
    from django.db import models

class Task(models.Model):
    title = models.CharField(max_length=200)
    completed = models.BooleanField(default=False)
    created = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title


7. Apply migrations
    python manage.py makemigrations
python manage.py migrate

8. Run locally:
        python manage.py runserver


Docker Setup

Dockerfile:

Defines Python base image.

Copies project files.

Installs dependencies.

Sets PORT=8080 (Cloud Run standard).

Runs app with proper host (0.0.0.0) and port.

Docker Compose:

Optional local multi-container setup with Postgres.

Defines web service and db service.

Maps ports and environment variables.

Enables persistent volumes locally.

Build and run containers:
docker compose build
docker compose up

Run single container locally (Cloud Run-style):

docker run -p 8080:8080 -e PORT=8080 <image-name>


---------------------
Cloud Run Deployment

Containerized Django app is deployed on Cloud Run.

Environment variables (e.g., DEBUG, DATABASE_URL) are passed via Cloud Run service settings or Terraform.

Port configuration:

Cloud Run expects the app to listen on PORT=8080.

Django app startup:

import os

port = int(os.environ.get("PORT", 8080))
app.run(host="0.0.0.0", port=port)


Static files:

Locally served by Django in DEBUG=True.

For production, need proper static handling (WhiteNoise or GCS).