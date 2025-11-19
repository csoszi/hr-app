HR App – Cloud-Based HR Management System
FastAPIPythonTerraformAWS

The HR App is a modern, cloud-native Human Resources management system built with FastAPI, SQLModel, and PostgreSQL. It provides a scalable backend API for managing employees, departments, meeting rooms, and bookings, with automated deployment on AWS infrastructure using Terraform.

Features
Employee Management – Create and manage employee records
Meeting Room Management – Manage meeting rooms and their availability
Booking System – Schedule and manage meeting room bookings with conflict detection
RESTful API – Built with FastAPI for high performance and automatic API documentation
Cloud-Native – Designed for deployment on AWS with Infrastructure as Code
Containerized – Docker support for consistent development and deployment
Technology Stack
Backend
Python 3.12+ – Modern Python with type hints
FastAPI – High-performance async API framework with automatic OpenAPI documentation
SQLModel – ORM built on SQLAlchemy and Pydantic for type-safe database operations
SQLite/PostgreSQL – SQLite for local development, PostgreSQL for production
Alembic – Database migration management
Uvicorn – Lightning-fast ASGI server
Infrastructure
Terraform – Infrastructure as Code (IaC) for reproducible deployments
AWS EC2 – Virtual machines running Docker containers
AWS VPC – Custom Virtual Private Cloud with public and private subnets
Application Load Balancer – For traffic distribution and high availability
Bastion Host – Secure SSH access to private instances
S3 – Object storage for application data
Security Groups – Network-level security controls
Docker – Containerization for consistent environments
Prerequisites
For Local Development
Python 3.12 or higher
pip (Python package manager)
Git
For AWS Deployment
AWS CLI configured with appropriate credentials
Terraform >= 1.6.0
Docker Hub account (for hosting Docker images)
SSH key pair for bastion host access
Local Development Setup
1. Clone the Repository
git clone https://github.com/csoszi/hr-app.git
cd hr-app
2. Create a Virtual Environment
# On Windows (Git Bash or WSL)
python -m venv venv
source venv/Scripts/activate

# On macOS/Linux
python3 -m venv venv
source venv/bin/activate
3. Install Dependencies
pip install -r requirements.txt
4. Run the Application
uvicorn app.main:app --reload
The application will start on http://127.0.0.1:8000


# Generate SSH key if you don't have one
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
Docker Image on Docker Hub

Build and push your Docker image to Docker Hub (see Docker Setup section)
Configuration
Navigate to Terraform Directory

cd terraform
Create terraform.tfvars File

# AWS Configuration
aws_region  = "eu-central-1"
aws_profile = "default"

# Network Configuration
vpc_cidr = "10.0.0.0/16"

# Bastion Host Configuration
allowed_ip = "YOUR_PUBLIC_IP/32"  # Replace with your IP address
public_key = "ssh-rsa AAAAB3NzaC1yc2E..."  # Your SSH public key

# S3 Configuration
s3_bucket_name = "hr-app-data-unique-name"  # Must be globally unique

# Docker Configuration
dockerhub_user = "your-dockerhub-username"
docker_image_name = "hr-app:latest"
Deployment Steps
Initialize Terraform

terraform init
Review the Deployment Plan

terraform plan -var="allowed_ip=$(curl -s ifconfig.me)/32" -var="public_key=$(cat ~/.ssh/id_rsa.pub)"
Deploy the Infrastructure

terraform apply -var="allowed_ip=$(curl -s ifconfig.me)/32" -var="public_key=$(cat ~/.ssh/id_rsa.pub)"
Type yes when prompted to confirm.

Get the Application URL

terraform output app_ec2_public_ip
Access the Application

Navigate to http://<ec2-public-ip> in your browser
API Documentation: http://<ec2-public-ip>/docs
Accessing the Bastion Host
# Get bastion host IP
terraform output bastion_ip

# SSH into bastion host
ssh -i ~/.ssh/id_rsa ubuntu@<bastion-ip>

# From bastion, access the app server
ssh ubuntu@<app-ec2-private-ip>
Cleanup
To destroy all AWS resources:

terraform destroy -var="allowed_ip=$(curl -s ifconfig.me)/32" -var="public_key=$(cat ~/.ssh/id_rsa.pub)"
Type yes when prompted to confirm.

API Endpoints
Employees
POST /employees – Create a new employee
{
  "name": "John Doe",
  "email": "john@example.com",
  "department": "Engineering"
}
Meeting Rooms
POST /rooms – Create a new meeting room
{
  "name": "Conference Room A",
  "capacity": 10
}
Bookings
POST /bookings – Create a new booking
{
  "room_id": 1,
  "employee_id": 1,
  "start_time": "2024-01-15T10:00:00",
  "end_time": "2024-01-15T11:00:00"
}
GET /bookings – List all bookings
Documentation
GET /docs – Interactive Swagger UI
GET /redoc – Alternative ReDoc documentation
🧪 Testing the API
Using curl
# Health check
curl http://127.0.0.1:8000/docs

# Create an employee
curl -X POST "http://127.0.0.1:8000/employees" \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com", "department": "Engineering"}'

# Create a meeting room
curl -X POST "http://127.0.0.1:8000/rooms" \
  -H "Content-Type: application/json" \
  -d '{"name": "Conference Room A", "capacity": 10}'

# List all bookings
curl http://127.0.0.1:8000/bookings
Using the Interactive API Docs
Navigate to http://127.0.0.1:8000/docs and use the “Try it out” feature for each endpoint.

Screenshots
Terraform Infrastructure Created
Terraform infrastructure created
Login to Bastion Host
Login to bastion host
The Running Application
The running app
📁 Project Structure
hr-app/
├── app/
│   ├── __init__.py
│   ├── main.py           # FastAPI application entry point
│   ├── models.py         # SQLModel database models
│   ├── schemas.py        # Pydantic schemas for API
│   ├── crud.py           # Database operations
│   ├── database.py       # Database configuration
│   ├── deps.py           # Dependencies
│   └── images/           # Screenshots
├── terraform/
│   ├── main.tf           # Main Terraform configuration
│   ├── variables.tf      # Input variables
│   ├── outputs.tf        # Output values
│   ├── provider.tf       # Provider configuration
│   ├── cloudinit/
│   │   └── docker_run.yml # Cloud-init script for EC2
│   └── modules/
│       ├── network/      # VPC and networking
│       ├── bastion_host/ # Bastion host configuration
│       ├── load_balancer/# Load balancer setup
│       └── s3_bucket/    # S3 storage
├── Dockerfile            # Container image definition
├── requirements.txt      # Python dependencies
├── hr_app.db            # SQLite database (local dev)
└── README.md            # This file
🔧 Configuration
Environment Variables
Create a .env file in the root directory for local development:

DATABASE_URL=sqlite:///./hr_app.db
# For PostgreSQL:
# DATABASE_URL=postgresql://user:password@localhost:5432/hr_app
Terraform Variables
The following variables can be configured in terraform/terraform.tfvars:

Variable	Description	Default
aws_region	AWS region for deployment	eu-central-1
aws_profile	AWS CLI profile to use	default
vpc_cidr	VPC CIDR block	10.0.0.0/16
allowed_ip	IP address allowed to SSH into bastion	Required
public_key	SSH public key for bastion host	Required
s3_bucket_name	S3 bucket name (must be globally unique)	hr-app-data-kd
dockerhub_user	Docker Hub username	Required
docker_image_name	Docker image name with tag	hr-app:latest
Security Best Practices
Never commit sensitive data – Use .env files and add them to .gitignore
Use IAM roles – Avoid hardcoding AWS credentials
Restrict SSH access – Use bastion host and limit IP ranges with allowed_ip
Keep dependencies updated – Regularly update Python packages
Use HTTPS in production – Configure SSL/TLS certificates
Secure your S3 bucket – Enable encryption and proper access policies
Review security groups – Follow the principle of least privilege
Cost Considerations
Estimated monthly AWS costs (eu-central-1 region):

EC2 Instance (t3.micro): ~$8-10/month
Application Load Balancer: ~$20/month
Bastion Host (t3.micro): ~$8-10/month
Data Transfer: Variable (typically $5-10/month)
S3 Storage: Minimal (first 50 TB is $0.023/GB)
Total Estimated Cost: ~$40-50/month

Note: Costs may vary based on usage, region, and AWS pricing changes.


Push to the branch (git push origin feature/AmazingFeature)
Open a Pull Request
