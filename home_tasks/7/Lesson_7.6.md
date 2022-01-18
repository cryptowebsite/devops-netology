# Lesson 7.6

# 1 Потренируйтесь читать исходный код AWS провайдера.
## 1.1 Найдите, где перечислены все доступные `resource` и `data_source`
* `resource` - https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L735
* `data_source` - https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L343

## 1.2 Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`.
### 1.2.1 С каким другим параметром конфликтует `name`?
https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L88

### 1.2.2 Какая максимальная длина имени?
* `fifo очередь включена` - 81 (с учётом приставки `\.fifo`, или 75 без неё)
* `fifo очередь выключена` - 80

### 1.2.3 Какому регулярному выражению должно подчиняться имя?
* `fifo очередь включена` - https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L402
* `fifo очередь выключена` - https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L404

# 2 Создайте и скомпилируйте провайдер.
https://github.com/cryptowebsite/devops-netology/tree/main/go/provider/terraform-provider-hashicups

[![Screenshot-from-2022-01-18-16-32-47.png](https://i.postimg.cc/8CfS427M/Screenshot-from-2022-01-18-16-32-47.png)](https://postimg.cc/R3myVbQZ)