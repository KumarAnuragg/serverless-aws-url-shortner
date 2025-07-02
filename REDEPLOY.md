# 🔁 REDEPLOY: Serverless AWS URL Shortener

This document provides a step-by-step guide to redeploy the serverless URL shortener project on AWS using Terraform. Follow this process if the infrastructure was previously destroyed using `terraform destroy` or if you're setting up on a new environment.


## 📦 Prerequisites

Ensure the following tools are installed and configured:

- **AWS CLI** (`aws configure`)
- **Terraform** (v1.3+ recommended)
- **Node.js** (v14+)
- **Git**
- AWS IAM user with appropriate permissions

---

## 🚀 Step-by-Step Redeployment

### 1️⃣ Clone the Repository

If you don't already have the code locally:

```bash
git clone https://github.com/KumarAnuragg/serverless-aws-url-shortner.git
cd serverless-aws-url-shortner


2️⃣ Prepare the Lambda Functions

🔹 Shorten URL Lambda

cd lambda/shorten-url
npm install
zip -r shorten-url.zip .


🔹 Redirect URL Lambda

cd ../redirect-url
npm install
zip -r redirect-url.zip .


4️⃣ Apply Terraform Configuration

terraform apply


5️⃣ Upload Lambda Zip Files (if required manually)
If Terraform doesn’t upload the .zip files automatically:

Go to AWS Lambda Console

Locate each function (shorten-url and redirect-url)

Click Upload from → .zip file and choose the correct .zip


6️⃣ Test the Shortener API
Use curl to generate a short URL:


curl -X POST https://<api-id>.execute-api.<region>.amazonaws.com/prod/shorten \
  -H "Content-Type: application/json" \
  -d '{"url":"https://example.com"}'


🧼 Cleanup (Optional)

To remove all AWS resources and avoid charges:

cd terraform
terraform destroy



🛠 Troubleshooting Tips

".terraform/" is excluded via .gitignore to prevent large file issues

If ".terraform" causes Git repo bloat, run:-

git rm -r --cached .terraform/

(If permissions error in Lambda, ensure the IAM roles were correctly created and attached)


Conclusion

This serverless URL shortener provides an efficient way to shorten and manage URLs using AWS services. By following the setup instructions and troubleshooting common errors, you can successfully deploy and run this project.

If you encounter any additional issues, feel free to raise an issue or contribute to improvements!


Maintained by Anurag Kumar
Created with 💡 using AWS, Lambda, API Gateway, DynamoDB, and Terraform



