# 🔗 Serverless AWS URL Shortener

A fully serverless and scalable URL shortening service built using AWS Lambda, API Gateway, DynamoDB, and Terraform. This project allows users to generate short links for long URLs, similar to Bitly or TinyURL.

---

## ⚙️ Tech Stack

- **AWS Lambda** – Backend logic for shortening and redirecting
- **API Gateway** – Exposes HTTP endpoints
- **DynamoDB** – Stores short ↔ long URL mappings
- **Terraform** – Infrastructure as Code for deployment
- **Node.js** – Lambda runtime and logic

---

## 🚀 Features

✅ Generate short URLs for long links  
✅ Redirect short URLs to original destinations  
✅ Fully serverless, auto-scaling, and cost-effective  
✅ Deployable via Terraform in minutes  
✅ Clean separation of infrastructure and business logic  

---

## 📦 Project Structure

```bash
.
├── lambda/
│   ├── shorten-url/        # Lambda to create short URLs
│   └── redirect-url/       # Lambda to redirect based on shortId
├── terraform/              # Infrastructure as code
├── .gitignore
├── README.md
└── REDEPLOY.md             # Step-by-step redeployment instructions


🛠️ Deployment Instructions

1️⃣ Clone the Repository
git clone https://github.com/KumarAnuragg/serverless-aws-url-shortner.git
cd serverless-aws-url-shortner


2️⃣ Prepare Lambda Functions
cd lambda/shorten-url
npm install
zip -r shorten-url.zip .

cd ../redirect-url
npm install
zip -r redirect-url.zip .


3️⃣ Deploy with Terraform
cd ../../terraform
terraform init
terraform apply


🔍 API Usage

🔹 Generate Short URL
POST /shorten
Content-Type: application/json

{
  "url": "https://example.com"
}

Response:
{
  "shortId": "abc123",
  "shortUrl": "https://your-api-id.execute-api.region.amazonaws.com/prod/abc123"
}


🔹 Redirect
Visiting the short URL will automatically redirect to the original link.


🧹 Cleanup (Optional)

To avoid incurring charges:
cd terraform
terraform destroy


📄 Redeployment
If you’ve destroyed the infrastructure and want to redeploy, follow the steps in REDEPLOY.md.


👨‍💻 Author
Anurag Kumar
GitHub Profile

