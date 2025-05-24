# Deployment Guide

## Overview

This guide explains how to deploy the Visitor Book application to production. The deployment process involves setting up the infrastructure using Terraform and deploying the application components using Docker and GitHub Actions.

## Prerequisites

1. **AWS Account**

   - AWS CLI configured
   - Appropriate IAM permissions
   - Access keys and secret keys

2. **GitHub Account**

   - Repository access
   - GitHub Actions enabled
   - Repository secrets configured

3. **Required Tools**
   - Terraform
   - Docker
   - AWS CLI
   - kubectl (if using Kubernetes)

## Infrastructure Setup

### 1. Configure AWS Credentials

```bash
aws configure
AWS Access Key ID: your_access_key
AWS Secret Access Key: your_secret_key
Default region name: us-east-1
Default output format: json
```

### 2. Initialize Terraform

```bash
cd terraform
terraform init
```

### 3. Configure Variables

Create a `terraform.tfvars` file:

```hcl
aws_region = "us-east-1"
environment = "prod"
vpc_cidr = "10.0.0.0/16"
db_username = "admin"
db_password = "your_secure_password"
```

### 4. Deploy Infrastructure

```bash
terraform plan
terraform apply
```

## Application Deployment

### 1. Frontend Deployment

#### Build Docker Image

```bash
cd visitor-book-frontend
docker build -t visitor-book-frontend:latest .
```

#### Push to Container Registry

```bash
aws ecr create-repository --repository-name visitor-book-frontend
aws ecr get-login-password | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
docker tag visitor-book-frontend:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/visitor-book-frontend:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/visitor-book-frontend:latest
```

### 2. Backend Deployment

#### Build Docker Image

```bash
cd visitor-book-backend
docker build -t visitor-book-backend:latest .
```

#### Push to Container Registry

```bash
aws ecr create-repository --repository-name visitor-book-backend
aws ecr get-login-password | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
docker tag visitor-book-backend:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/visitor-book-backend:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/visitor-book-backend:latest
```

## CI/CD Pipeline

### GitHub Actions Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1

      - name: Build and push Frontend
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: visitor-book-frontend
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG ./visitor-book-frontend
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

      - name: Build and push Backend
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: visitor-book-backend
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG ./visitor-book-backend
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

      - name: Deploy to ECS
        run: |
          aws ecs update-service --cluster visitor-book --service frontend --force-new-deployment
          aws ecs update-service --cluster visitor-book --service backend --force-new-deployment
```

## Environment Variables

### Frontend Environment Variables

Create `.env.production`:

```env
NEXT_PUBLIC_API_URL=https://api.visitorbook.com
NEXT_PUBLIC_GA_TRACKING_ID=UA-XXXXXXXXX-X
```

### Backend Environment Variables

Create `.env.production`:

```env
DATABASE_URL=postgresql://user:password@rds-endpoint:5432/visitorbook
JWT_SECRET=your_jwt_secret
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
```

## Monitoring Setup

### 1. CloudWatch Alarms

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name visitor-book-api-errors \
  --alarm-description "Alarm when API errors exceed threshold" \
  --metric-name 5XXError \
  --namespace AWS/ApiGateway \
  --statistic Sum \
  --period 300 \
  --threshold 10 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  --alarm-actions arn:aws:sns:us-east-1:123456789012:visitor-book-alerts
```

### 2. Logging Configuration

```bash
aws logs create-log-group --log-group-name /visitor-book/application
aws logs put-retention-policy --log-group-name /visitor-book/application --retention-in-days 30
```

## Backup Configuration

### 1. Database Backups

```bash
aws rds create-db-snapshot \
  --db-instance-identifier visitor-book-db \
  --db-snapshot-identifier visitor-book-db-backup-$(date +%Y%m%d)
```

### 2. Automated Backup Schedule

```bash
aws events put-rule \
  --name visitor-book-daily-backup \
  --schedule-expression "cron(0 0 * * ? *)" \
  --state ENABLED
```

## Security Considerations

1. **SSL/TLS Configuration**

   - Use AWS Certificate Manager for SSL certificates
   - Configure HTTPS for all endpoints

2. **Security Groups**

   - Restrict access to necessary ports only
   - Use private subnets for sensitive resources

3. **IAM Roles**
   - Use least privilege principle
   - Rotate access keys regularly

## Troubleshooting

### Common Issues

1. **Deployment Failures**

   - Check GitHub Actions logs
   - Verify AWS credentials
   - Check ECS service events

2. **Database Connection Issues**

   - Verify security group rules
   - Check database credentials
   - Ensure VPC endpoints are configured

3. **Application Errors**
   - Check CloudWatch logs
   - Verify environment variables
   - Check application logs

## Rollback Procedures

### 1. Infrastructure Rollback

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

### 2. Application Rollback

```bash
aws ecs update-service \
  --cluster visitor-book \
  --service frontend \
  --task-definition visitor-book-frontend:previous-version
```

## Maintenance

### 1. Regular Updates

- Update dependencies weekly
- Apply security patches immediately
- Review and rotate secrets monthly

### 2. Performance Monitoring

- Monitor CPU and memory usage
- Check database performance
- Review API response times

## Support

For deployment support:

- Email: devops@visitorbook.com
- Slack: #deployment-support
- Documentation: https://docs.visitorbook.com/deployment
