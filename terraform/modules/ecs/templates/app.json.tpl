[
  {
    "essential": true,
    "memory": 256,
    "name": "${app}",
    "cpu": 256,
    "image": "${repo_url}",
    "workingDirectory": "/",
    "command": ["python", "api.py"],
    "portMappings": [
        {
            "containerPort": 5000,
            "hostPort": 5000
        }
    ]
  }
]

