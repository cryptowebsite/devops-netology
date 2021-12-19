# Lesson 7.2

# 1 Регистрация в `aws` и `YC`. Знакомство с основами
## 1. AWS
[![aws-web.png](https://i.postimg.cc/K8HNpdYb/aws-web.png)](https://postimg.cc/cvfwrkYk)
## 2. YC
```shell
export YC_TOKEN=<MY_TOKEN>
```
```terraform
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}

provider "yandex" {
  cloud_id  = "b1gsvg57220fl1f4agtc"
  folder_id = "b1g8n8d6tmplil5u4286"
  zone      = "ru-central1-a"
}
```

# 2 Создать ВМ
## 2.1 AWS
```shell
export AWS_ACCESS_KEY_ID=<MY_AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<MY_AWS_SECRET_ACCESS_KEY>
export AWS_DEFAULT_REGION=<MY_AWS_REGION>
```
https://github.com/cryptowebsite/devops-netology/tree/main/aws-terraform
## 2.2 YC
```shell
export YC_TOKEN=<MY_YC_TOKEN>
```
https://github.com/cryptowebsite/devops-netology/tree/main/yandex-cloud-terraform

Образ `ami` можно создать с помощью `packer`.