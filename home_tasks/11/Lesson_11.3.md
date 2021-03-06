# Lesson 11.3

## 1. Обеспечить разработку
| Требования                                                               |      Jenkins       |    Team city     |   Gitlub   |
|--------------------------------------------------------------------------|:------------------:|:----------------:|:----------:|
| Облачная система	                                                        |         -          |        +         |     +      |
| Система контроля версий Git   	                                        |         +          |  +           	|     +      |
| Репозиторий на каждый сервис                                             |       +   	     |        +         |     +      |
| Запуск сборки по событию из системы контроля версий                      | +                	 | +              	|     +      |
| Запуск сборки по кнопке с указанием параметров                           | +                	 | +              	|     +      |
| Возможность привязать настройки к каждой сборке                          | +                	 | +              	|     +      |
| Возможность создания шаблонов для различных конфигураций сборок          | -               	 | +              	|     -      |
| Возможность безопасного хранения секретных данных: пароли, ключи доступа | +                	 | +              	| +        	 |
| Несколько конфигураций для сборки из одного репозитория                  |   +           	 |       + 	        |     +      |
| Кастомные шаги при сборке                                                | +                	 | +              	|     +      |
| Собственные докер образы для сборки проектов                             | +                	 | +              	| +        	 |
| Возможность развернуть агентов сборки на собственных серверах            | +                	 | +              	|     +      |
| Возможность параллельного запуска нескольких сборок                      | +                	 | +              	| +        	 |
| Возможность параллельного запуска тестов                                 | +                	 | +              	|     +      |

Из рассмотренных вариантов всем требованиям удовлетворяет `Team city`. Один продукт управляет всем жизненным циклом ПО. Ближайшей аналог `Gitlub`, имеет во многом более расширенный функционал, но придется пожертвовать созданием шаблонов для конфигураций сборок.

## 2. Логи
* `Filebeat` - Собираем логи с хостов и передаём на центральный сервер (`Logstash`) для обработки.
* `Logstash` - Получаем логи с `Filebeat`ов, при необходимости как-то изменяем их и отправляем на хранение в `Elasticsearch`.
* `Elasticsearch` - БД для хранения логов.
* `Kibana` - Делаем поиск, фильтрацию и группировку по логам, с возможностью получения прямой ссылки на лог.

## 3. Мониторинг
* `Node Exporter` - Собираем метрики с хостов и передаём их на центральный сервер мониторинга `Prometheus`.
* `Prometheus` - Получаем логи с `Node Exporter`ов и храним из в БД.
* `Grafana` - Графически отображаем полученные метрики с `Prometheus`, а так же может настроить оповещения.
