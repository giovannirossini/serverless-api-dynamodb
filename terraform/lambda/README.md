# Lambda Function

To create the Zip file for the Lambda function, run the following command:

```sh
cd terraform/lambda
mkdir -p package

pip install -r requirements.txt -t package

cd package
zip -r9 ../lambda.zip .

cd ..
zip -g lambda.zip lambda.py

aws s3 cp lambda.zip s3://<BUCKET_NAME>/lambda.zip
```
