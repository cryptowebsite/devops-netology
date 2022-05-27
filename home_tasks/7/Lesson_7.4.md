# Lesson 7.4

# 1 Написать серверный конфиг для атлантиса.
```yaml
# server.yaml

repos:
- id: github.com/cryptowebsite
  branch: /.*/
  apply_requirements: [approved, mergeable]
  workflow: custom
  allowed_overrides: [apply_requirements, workflow, delete_source_branch_on_merge]
  allow_custom_workflows: true
  delete_source_branch_on_merge: true
  pre_workflow_hooks: 
    - run: my-pre-workflow-hook-command arg1

workflows:
  custom:
    plan:
      steps:
      - run: my-custom-command arg1 arg2
      - init
      - plan:
          extra_args: ["-lock", "false"]
      - run: my-custom-command arg1 arg2
    apply:
      steps:
      - run: echo hi
      - apply
```
```yaml
# atlantis.yaml

version: 3
automerge: true
delete_source_branch_on_merge: true
projects:
- name: netology-prod
  dir: .
  workspace: prod
  terraform_version: v0.11.0
  delete_source_branch_on_merge: true
  autoplan:
    when_modified: ["*.tf", "../modules/**.tf"]
    enabled: true
  apply_requirements: [mergeable, approved]
  workflow: myworkflow
- name: netology-stage
  dir: .
  workspace: stage
  terraform_version: v0.11.0
  delete_source_branch_on_merge: true
  autoplan:
    when_modified: ["*.tf", "../modules/**.tf"]
    enabled: true
  apply_requirements: [mergeable, approved]
  workflow: myworkflow  
  
workflows:
  myworkflow:
    plan:
      steps:
      - run: my-custom-command arg1 arg2
      - init
      - plan:
          extra_args: ["-lock", "false"]
      - run: my-custom-command arg1 arg2
    apply:
      steps:
      - run: echo hi
      - apply
allowed_regexp_prefixes:
- stage/
- prod/
```

# 2 Создайте аналогичный инстанс при помощи найденного модуля.
https://github.com/cryptowebsite/devops-netology/blob/main/aws-terraform/main.tf

В своих проектах предпочту использовать ресурс `aws_instance` и использовать его как модуль, заточенный под конкретную задачу.
