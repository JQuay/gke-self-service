# Set project
PROJECT_ID=$(gcloud config get-value project)
echo "Project: $PROJECT_ID"

# Create service account (skip if already exists)
gcloud iam service-accounts create terraform-sa \
  --display-name="Terraform Service Account" 2>/dev/null || echo "SA already exists"

# Grant permissions
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:terraform-sa@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/container.admin" --quiet

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:terraform-sa@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.admin" --quiet

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:terraform-sa@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser" --quiet

# Create key file
gcloud iam service-accounts keys create ~/terraform-sa-key.json \
  --iam-account=terraform-sa@$PROJECT_ID.iam.gserviceaccount.com

echo "Key created at: ~/terraform-sa-key.json"