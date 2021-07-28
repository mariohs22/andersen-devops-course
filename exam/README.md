## Task

Build a working infrastructure with automatic building and deploying of a new version of the applications using dockerization. As an applications, develop 2 web applications that output `Hello World 1` & `Hello World 2`.

<details>
    <summary>Detailed exam description</summary>

## DevOps Exam

Экзамен представлен в виде самостоятельно выполняемой лабораторной работы с последующей её защитой. На каждую защиту отводится 20 минут времени.

### Задача:

Построить рабочую инфраструктуру с автоматической сборкой и деплоем новой версии приложения с использованием докеризации.
В качестве приложения разработайте 2 **web** приложения, которые выводят “Hello World 1” & “Hello World 2” на языках из списка:

- Python
- .NET Core
- PHP
- Java
- Go (gin framework)

### Дано:

- Ci/CD - выбираете сами.
- SCM/ControlVersion - выбираете сами (git based).
- Registry - выбираете сами.
- Инфраструктура - выбираете сами.

### Результат:

Готовая лаба, которую вы можете продемонстрировать.
Презентация для защиты решения.
Презентация должна содержать в себе 2 диаграммы:

- как устроен процесс Ci/CD в вашем решении,
- как бы вы его строили в идеальном мире и без ограничений по времени исполнения задачи.
  Презентация должна содержать в себе схему инфраструктуры.

#### Дополнительные плюсы при решении задачи:

- Проверка кода анализатором, таким как snyk, sonarqube, linter, etc.
- Нотификация по результатам
- Автоматических запуск pipeline на commit/merge request
- Secret management
- Pipeline as code
- Политика контейнеров в докер реджистри (плановые удаление и тд)
- Использование сервисов по сбору логов
- Проверка автоматических тестов приложения (если реализуете)
- Написать README.md

</details>

## My solution

| Applicarion                                   | Language | Status                                                                                               |
| --------------------------------------------- | -------- | ---------------------------------------------------------------------------------------------------- |
| [App1](https://github.com/mariohs22/app1_php) | PHP      | ![CI/CD](https://github.com/mariohs22/app1_php/actions/workflows/workflow.yml/badge.svg?branch=main) |
| [App2](https://github.com/mariohs22/app2_go)  | GO       | -                                                                                                    |
