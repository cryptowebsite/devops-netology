# Description ```.gitignore```


Игнорировать все файлы в скрытой директории ```terraform```
```
**.terraform/*
```
Игнорировать все файлы с расширением ```.tfstate``` и слюбым расширением после```.tfstate```
```
*.tfstate
*.tfstate.*
```
Игнорировать файл ```crash.log```
```
crash.log
```

Игнорировать все файлы с расширением ```.tfvars```
```
*.tfvars
```

Игнорировать файлы ```override.tf``` и ```override.tf.json```
```
override.tf
override.tf.json
```

Игнорировать все файлы оканчивающиеся на ```_override.tf``` и ```_override.tf.json```
```
*_override.tf
*_override.tf.json
```

Игнорировать файлы ```.terraformrc``` и ```terraform.rc```
```
.terraformrc
terraform.rc
```
