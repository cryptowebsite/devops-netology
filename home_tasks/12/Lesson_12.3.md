# Lesson 12.3

## 1. Описать требования к кластеру

### Сервисы потребляют
Для запуска отказоустойчивого кластера нам потребуется:
1) Control Plan node - 1шт. с минимальной конфигурацией: CPU - 1 core, RAM - 2 GB, Disk - 50 GB
2) Work node - 7шт. с конфигурацией CPU - 4 cores, RAM - 8 GB, Disk - 100 GB (Всего: CPU - 28 cores, RAM 56 GB)

|                  	| CPU 	| RAM   	| PCS 	|
|------------------	|-----	|-------	|-----	|
| DB               	|  1  	|  4096 	|  3  	|
| Сache            	|  1  	|  4096 	|  3  	|
| Frontend         	| 0.2 	|   50  	|  5  	|
| Backend          	|  1  	|  600  	|  10 	|
| Total services   	| 17  	| 30826 	| 21  	|
| System resources 	| 7   	| 7168  	|     	|
| Total            	| 24  	| 38    	|     	|