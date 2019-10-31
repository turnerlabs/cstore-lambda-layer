# cStore Lambda Layer

Terraform scripts used to create a lambda layer for [cstore](https://github.com/turnerlabs/cstore).  Lambda functions can use the lambda layer to pull configuration into memory avoiding environment variables or configuration files.

### NodeJS ###


<details open>
    <summary>Example Usage</summary>

```javascript
const cstore = require('cstore');

exports.test = function (event, context) {
    let config = cstore.pull({
        tags: [process.env.ENV],
        format: "json-object",
        inject: false
    })

    Object.keys(config).forEach(function (key) {
        console.log(key + "=" + config[key]);
    });
}
```
</details>

<details>
    <summary>Infrastructure</summary>

```bash
$ export AWS_REGION=us-east-1
$ export AWS_PROFILE=aws-profile
```


#### 1. Create cStore Lambda Layer ####

```bash
$ cd nodejs/resources
$ terraform init
$ terraform apply
```

#### 3. Create Example Lambda ####

```bash
$ cd nodejs/example
$ touch terraform.tfvars
```

Add the cstore lambda layer arn from the previous step's output to `terraform.tfvars`.

```
cstore_lambda_layer_arn = "{ARN}"
```

```bash
$ terraform init
$ terraform apply
```

#### 2. Push Example Configuration to SSM Parameter Store ####

```bash
$ cd nodejs/example/lambda
$ cstore push ../.env
```

#### 4. Execute Example Lambda ####

```bash
$ export AWS_DEFAULT_REGION=us-east-1
$ aws lambda invoke --function-name cstore_lambda_example response.json
```

</details>