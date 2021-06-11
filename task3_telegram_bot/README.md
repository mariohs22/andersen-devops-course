# Telegram bot

**Current status: done**

## Task description

Write Telegram bot in Go language that understand at least these 3 commands:

- `/git` - displays url of this repository,
- `/tasks` - displays ordered list of done tasks,
- `/task#` - displays url of task folder, where # is the task number.

## Bot usage

Connect to [@andersendevops2021bot](https://t.me/andersendevops2021bot)

To communicate with bot use these commands:

- `/help` - display help message
- `/git` - show link this (my course) repository
- `/tasks` - show list of completed tasks
- `/task#` - show link to specifeed task, where # is a task number

## Bot description

This bot is written in [Go](https://golang.org/) language and uses [Serverless](https://www.serverless.com/) framework to deploy to [AWS Lambda](https://aws.amazon.com/lambda/).

The bot logic of getting tasks is based on retrieving the repository issues (filtered by issue status). The main rule is to create one issue according to one task:

```
Issue name:             Task 1: Task name
Task directory name:    task1_task_name
```

When the task is done, you must close the issue, so the bot reads that task as completed.

## Build requirements:

- Clone this repository

- You need to be registered AWS user. Get security credentials in [AWS Console](https://console.aws.amazon.com/iam/home?#/security_credentials) and write it in `./aws/credentials` file in home root directory:

```
[default]
aws_access_key_id=xxxxxxxxxxx
aws_secret_access_key=yyyyyyyyyyyyyyyyyyyyyyy
```

- Register new telergam bot with [BotFather](https://t.me/botfather), get bot token and write it to `.env` file at this task directory:

```
BOT_TOKEN=xxxxxxxxxxxxxxxxxxx
```

- Install serverless framework:

```
npm install -g serverless
```

- Install necessary Go packages:

```
go get -u gopkg.in/tucnak/telebot.v2
go get github.com/aws/aws-lambda-go
go get github.com/google/go-github/v35
go get
```

May be you need to install other Go packages, depending on your local environment.

- Build binary file:

```
env GOOS=linux go build -o bin/webhook main.go
```

- Deploy it to AWS:

```
serverless deploy -v
```

You need to copy endpoint link from console.

- Integrate bot with Telegram:

```
curl https://api.telegram.org/bot{YOUR_BOT_TOKEN}/setWebhook?url={YOUR_ENDPOINT_AWS_URL}
```

## Useful links

- [Go basic syntax](https://medium.com/@manus.can/learn-golang-basic-syntax-in-10-minutes-48608a315896)
- [Go packages documentation](https://pkg.go.dev/)
- [Пишем телеграм бота на Go и AWS Lambda](https://habr.com/ru/post/555518/)
