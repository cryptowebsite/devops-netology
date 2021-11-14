# Lesson 4.1

### 1. Какие значения переменным c,d,e будут присвоены? Почему?
```shell
a=1
b=2
c=a+b # переменная 'c' равняется строке 'a+b', т.к. именно эту строку мы присвоили переменной 'c'
d=$a+$b # переменная 'd' равняется строке '1+2' т.к. для выполнения арифметических операций используется оператор "$(( expression ))"
e=$(($a+$b)) # переменная 'e' равняется числу 3 т.к. мы сложили значение переменных 'a' и 'b'. 
```

### 2. Что необходимо сделать, чтобы исправить скрипт:
```shell
#!/usr/bin/env bash

while ((1==1))
do
  curl --connect-timeout 10 https://localhost:4757
  if (($? != 0))
  then
    date >> curl.log
    break
  fi
done  
```

### 3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.
```shell
#!/usr/bin/env bash

ADDRESSES=(192.168.0.1 173.194.222.113 87.250.250.242)

for address in "${ADDRESSES[@]}"; do
  url=http://$address:80
  attempts=5
  for ((i=1; i < 5; i++))
  do
    curl --connect-timeout 10 $url
    if (($? != 0))
    then
      $attempts--
    fi
  done
  echo "$address Passed tests: $attempts/5" >> mylog.log
done

```

### 4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается
```shell
#!/usr/bin/env bash

ADDRESSES=(192.168.0.1 173.194.222.113 87.250.250.242)

while ((1==1))
do
  for address in "${ADDRESSES[@]}"; do
    url=http://$address:80
    for ((i=1; i < 5; i++))
    do
      curl --connect-timeout 10 $url
      if (($? != 0))
      then
        echo "Address $address not available" >> error.txt
        exit 0
      fi
    done
  done
done
```

### 5. Нужно написать локальный хук для git.
```shell
nano my_project/.git/hooks/commit-msg

#!/usr/bin/env bash

commit=$(cat "$1")
regex="\[[0-9]{1,7}-([a-z]|[A-Z]|[0-9])([a-z]|[A-Z]|[0-9]|\-)+\]"

if [ ${#commit} -gt 30 ]
then
  echo >&2 The message is longer than 30 characters.
  exit 1
else
 if [[ $commit =~ $regex ]]
  then
    echo ALL right
  else
    echo >&2 The message does not contain the job code in the required format.
    exit 1
  fi
fi
```