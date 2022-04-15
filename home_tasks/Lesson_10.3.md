# Lesson 10.3

## 1. Подключите поднятый вами `prometheus` как источник данных
[![data-source.jpg](https://i.postimg.cc/rwLVqs6R/data-source-png.jpg)](https://postimg.cc/crXymsLd)

## 2. Создайте `Dashboard`
* `Утилизация CPU для nodeexporter (в процентах, 100-idle)` / `CPULA 1/5/15`

P.S. Не совсем понял что означает метрика `CPULA 1/5/15`. Предпологая, что это утилизация CPU за конкретные отрезки времени, применил следющие формулы, соответственно:
```
100 - (avg by (instance) (rate(node_cpu_seconds_total{job="node_exporter",mode="idle"}[1m])) * 100)
100 - (avg by (instance) (rate(node_cpu_seconds_total{job="node_exporter",mode="idle"}[5m])) * 100)
100 - (avg by (instance) (rate(node_cpu_seconds_total{job="node_exporter",mode="idle"}[15m])) * 100)
```
* `Количество свободной оперативной памяти`
```
node_memory_MemFree_bytes{job="node_exporter"}
```
* `Количество места на файловой системе`
```
node_filesystem_free_bytes{job="node_exporter"}
```
[![dashboard.png](https://i.postimg.cc/bvxWwLfQ/dashboard.png)](https://postimg.cc/p9dq0fTT)

## 3. Создайте для каждой `Dashboard` подходящее правило `alert` 
[![dashboard.png](https://i.postimg.cc/bvxWwLfQ/dashboard.png)](https://postimg.cc/p9dq0fTT)

P.S. Поскольку `grafana` позволяет создавать `alert` только с панелями в виде графика, эстетический вид дашборда оставляет желать лучшего.

## 4. Сохраните ваш `Dashboard`.
```json
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "target": {
          "limit": 100,
          "matchAny": false,
          "tags": [],
          "type": "dashboard"
        },
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 1,
  "links": [],
  "liveNow": false,
  "panels": [
    {
      "alert": {
        "alertRuleTags": {},
        "conditions": [
          {
            "evaluator": {
              "params": [
                2147483648
              ],
              "type": "lt"
            },
            "operator": {
              "type": "and"
            },
            "query": {
              "params": [
                "A",
                "5m",
                "now"
              ]
            },
            "reducer": {
              "params": [],
              "type": "avg"
            },
            "type": "query"
          }
        ],
        "executionErrorState": "alerting",
        "for": "5m",
        "frequency": "1m",
        "handler": 1,
        "message": "Всё плохо: мало места на диске",
        "name": "Disk alert",
        "noDataState": "no_data",
        "notifications": []
      },
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "fieldConfig": {
        "defaults": {
          "unit": "bytes"
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "hiddenSeries": false,
      "id": 123131,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.4.5",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "-JHMvM8nk"
          },
          "exemplar": true,
          "expr": "node_filesystem_free_bytes{job=\"node_exporter\"}",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "thresholds": [
        {
          "colorMode": "critical",
          "fill": true,
          "line": true,
          "op": "lt",
          "value": 2147483648,
          "visible": true
        }
      ],
      "timeRegions": [],
      "title": "Available disk",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "bytes",
          "logBase": 1,
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "alert": {
        "alertRuleTags": {},
        "conditions": [
          {
            "evaluator": {
              "params": [
                1073741824
              ],
              "type": "lt"
            },
            "operator": {
              "type": "and"
            },
            "query": {
              "params": [
                "A",
                "5m",
                "now"
              ]
            },
            "reducer": {
              "params": [],
              "type": "avg"
            },
            "type": "query"
          }
        ],
        "executionErrorState": "alerting",
        "for": "5m",
        "frequency": "1m",
        "handler": 1,
        "message": "Всё плохо: мало памяти",
        "name": "Available RAM alert",
        "noDataState": "no_data",
        "notifications": []
      },
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "fieldConfig": {
        "defaults": {
          "unit": "bytes"
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 8
      },
      "hiddenSeries": false,
      "id": 123129,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.4.5",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "-JHMvM8nk"
          },
          "exemplar": true,
          "expr": "node_memory_MemFree_bytes{job=\"node_exporter\"}",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "thresholds": [
        {
          "colorMode": "critical",
          "fill": true,
          "line": true,
          "op": "lt",
          "value": 1073741824,
          "visible": true
        }
      ],
      "timeRegions": [],
      "title": "Available RAM",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "bytes",
          "logBase": 1,
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "alert": {
        "alertRuleTags": {},
        "conditions": [
          {
            "evaluator": {
              "params": [
                88
              ],
              "type": "gt"
            },
            "operator": {
              "type": "and"
            },
            "query": {
              "params": [
                "A",
                "5m",
                "now"
              ]
            },
            "reducer": {
              "params": [],
              "type": "avg"
            },
            "type": "query"
          }
        ],
        "executionErrorState": "alerting",
        "for": "5m",
        "frequency": "1m",
        "handler": 1,
        "message": "Всё плохо: CPU нагружен",
        "name": "CPULA 1/5/15 alert",
        "noDataState": "no_data",
        "notifications": []
      },
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 16
      },
      "hiddenSeries": false,
      "id": 123127,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.4.5",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "-JHMvM8nk"
          },
          "exemplar": true,
          "expr": "100 - (avg by (instance) (rate(node_cpu_seconds_total{job=\"node_exporter\",mode=\"idle\"}[1m])) * 100)",
          "interval": "",
          "legendFormat": "CPULA 1",
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "-JHMvM8nk"
          },
          "exemplar": true,
          "expr": "100 - (avg by (instance) (rate(node_cpu_seconds_total{job=\"node_exporter\",mode=\"idle\"}[5m])) * 100)",
          "hide": false,
          "interval": "",
          "legendFormat": "CPULA 5",
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "-JHMvM8nk"
          },
          "exemplar": true,
          "expr": "100 - (avg by (instance) (rate(node_cpu_seconds_total{job=\"node_exporter\",mode=\"idle\"}[15m])) * 100)",
          "hide": false,
          "interval": "",
          "legendFormat": "CPULA 15",
          "refId": "C"
        }
      ],
      "thresholds": [
        {
          "colorMode": "critical",
          "fill": true,
          "line": true,
          "op": "gt",
          "value": 88,
          "visible": true
        }
      ],
      "timeRegions": [],
      "title": "CPULA 1/5/15",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "percent",
          "logBase": 1,
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 24
      },
      "id": 123125,
      "panels": [],
      "title": "Row title",
      "type": "row"
    },
    {
      "gridPos": {
        "h": 3,
        "w": 24,
        "x": 0,
        "y": 25
      },
      "id": 1,
      "type": "welcome"
    },
    {
      "gridPos": {
        "h": 9,
        "w": 24,
        "x": 0,
        "y": 28
      },
      "id": 123123,
      "type": "gettingstarted"
    },
    {
      "gridPos": {
        "h": 15,
        "w": 12,
        "x": 0,
        "y": 37
      },
      "id": 3,
      "links": [],
      "options": {
        "folderId": 0,
        "maxItems": 30,
        "query": "",
        "showHeadings": true,
        "showRecentlyViewed": true,
        "showSearch": false,
        "showStarred": true,
        "tags": []
      },
      "pluginVersion": "8.4.5",
      "tags": [],
      "title": "Dashboards",
      "type": "dashlist"
    },
    {
      "gridPos": {
        "h": 15,
        "w": 12,
        "x": 12,
        "y": 37
      },
      "id": 4,
      "links": [],
      "options": {
        "feedUrl": "https://grafana.com/blog/news.xml",
        "showImage": true
      },
      "title": "Latest from the blog",
      "type": "news"
    }
  ],
  "refresh": false,
  "schemaVersion": 35,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "2022-04-06T19:27:46.555Z",
    "to": "2022-04-09T03:14:32.072Z"
  },
  "timepicker": {
    "hidden": true,
    "refresh_intervals": [
      "5s",
      "10s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ],
    "time_options": [
      "5m",
      "15m",
      "1h",
      "6h",
      "12h",
      "24h",
      "2d",
      "7d",
      "30d"
    ],
    "type": "timepicker"
  },
  "timezone": "browser",
  "title": "Netology",
  "uid": "ObD5sG87k",
  "version": 2,
  "weekStart": ""
}
```

P.S. * Для зупуска данного стека мониторинга пришлось написать три `ansible` роли, всё это счастье лежит [тут](https://github.com/cryptowebsite/ansible-prometheus)!
