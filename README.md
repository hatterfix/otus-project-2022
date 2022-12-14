## Итоговый проект курса "DevOps практики и инструменты"

### Исходники проекта:

Микросервисное приложение предоставленное OTUS

- [crawler](https://github.com/express42/search_engine_crawler)
- [ui](https://github.com/express42/search_engine_ui)


Что использовалось по состоянию на 09/11/2022


- Docker для сборки образов компонент приложения
- Minikube для локальных тестов компонент приложения в K8s
- Yandex Cloud как платформа для запуска приложения 
- Managed Service for Kubernetes + terraform для быстрого запуска кластера
- helm v3 для создания чартов компонент приложения и полного деплоя проекта

Изначально  из исходников были собраны docker images (положил в дирректории исходников)
Подготовлены манифесты для ручного запуска приложения ( kubectl apply -f ...)
Сборка приложения была протестирована в Minikube
Далее был развернут кластер kubernetes с помощью terraform - запуск приложения протестирован в активной среде.

Однако работать с файлами манифестов в рамках проекта -  долго и неудобно
Были собраны helm-чарты как для отдельных компонент приложения , 
crawler
rabbitmq
ui

так и для полного деплоя приложения
project

Чарты протестированы и работают 
Структура файлов в репозитории немного прибрана, а то был кошмар

Выбор в сторону helm-чартов обусловлен тем, что их можно подружить с ansible с помощью модуля kubernetes.core.helm 

К тому же при дальнейшей работе с проектом из чартов будет удобнее ставить сопутствующие компоненты приложения - мониторинг и логи 

В прокет добавлен namespace mon и  мониторинг prometheus+grafana с использованием публичного чарта [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
Пока что снимаются метрики кластера, без компонент приложения.

Из-за ограничений на количество LoadBalancer на кластер в YandexCloud элементы мониторинга доступны извне по NodePort

Узнать пароль для входа в Grafana

```sh
kubectl get secret -n [namespace] [projectname]-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

```


Подключил сбор метрик приложения в kube-prometheus-stack через поиск сервиса компонент приложения по локальным dns.



Ingress Controller для github 

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml

Продолжаю работу над проектом....
