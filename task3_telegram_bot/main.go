package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"sort"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/google/go-github/v35/github"
	tb "gopkg.in/tucnak/telebot.v2"
)

const GITHUB_ACCOUNT = "mariohs22"
const GITHUB_REPOSITORY = "andersen-devops-course"
const TASK_LABEL = "task"

func main() {
	b, err := tb.NewBot(tb.Settings{
		Token:       os.Getenv("BOT_TOKEN"),
		Synchronous: true,
	})
	if err != nil {
		panic(err)
	}

	b.Handle(tb.OnText, func(m *tb.Message) {
		startTemplate := regexp.MustCompile(`(?i)^/start$`)
		gitTemplate := regexp.MustCompile(`(?i)^/git$`)
		helpTemplate := regexp.MustCompile(`(?i)^/help$`)
		tasksTemplate := regexp.MustCompile(`(?i)^/tasks$`)
		taskNTemplate := regexp.MustCompile(`(?i)^/task(\d+)$`)
		linkNTemplate := regexp.MustCompile(`(?i)^/link(\d+)$`)

		client := github.NewClient(nil)
		ctx := context.Background()

		if startTemplate.MatchString(m.Text) {
			b.Send(m.Chat, "Welcome to telegram bot of my Andersen DevOps Courses repository. Type /help for help")

		} else if helpTemplate.MatchString(m.Text) {
			b.Send(m.Chat, `To communicate with bot, use these commands please:
/help  - display this message
/git   - show link to my course repository
/tasks - show list of completed tasks
/task# - show link to specified completed task, where # is a task number
/link# - show link to specified task, where # is a task number`)

		} else if gitTemplate.MatchString(m.Text) {
			url := fmt.Sprintf("https://github.com/%v/%v", GITHUB_ACCOUNT, GITHUB_REPOSITORY)
			b.Send(m.Chat, url)

		} else if tasksTemplate.MatchString(m.Text) {
			opt := &github.IssueListByRepoOptions{State: "closed", Labels: []string{TASK_LABEL}}
			listIssues, _, _ := client.Issues.ListByRepo(ctx, GITHUB_ACCOUNT, GITHUB_REPOSITORY, opt)
			sort.Slice(listIssues, func(i, j int) bool {
				return github.Stringify(listIssues[i].Title) < github.Stringify(listIssues[j].Title)
			})
			listTasks := []string{}
			for i, task := range listIssues {
				message := fmt.Sprintf("%v. %v\n", i+1, github.Stringify(task.Title))
				listTasks = append(listTasks, message)
			}
			if len(listTasks) > 0 {
				b.Send(m.Chat, "List of completed tasks:\n"+fmt.Sprint(strings.Trim(fmt.Sprint(listTasks), "[]")))
			} else {
				b.Send(m.Chat, "Unfortunately, completed tasks is not found")
			}

		} else if taskNTemplate.MatchString(m.Text) {
			taskNumber := taskNTemplate.FindStringSubmatch(m.Text)[1]
			opt := &github.IssueListByRepoOptions{State: "all", Labels: []string{TASK_LABEL}}
			listTasks, _, _ := client.Issues.ListByRepo(ctx, GITHUB_ACCOUNT, GITHUB_REPOSITORY, opt)
			captionTemplate := regexp.MustCompile(`"Task (\d?): (.*?)"`)
			found := false
			for _, task := range listTasks {
				title := github.Stringify(task.Title)
				titleParsed := captionTemplate.FindStringSubmatch(title)
				if titleParsed[1] == taskNumber {
					found = true
					if github.Stringify(task.State) == `"closed"` {
						caption := strings.ToLower(strings.Replace(titleParsed[2], " ", "_", -1))
						url := fmt.Sprintf("https://github.com/%v/%v/tree/main/task%v_%v", GITHUB_ACCOUNT, GITHUB_REPOSITORY, titleParsed[1], caption)
						b.Send(m.Chat, fmt.Sprintf("%v %v\n", title, url))
					} else {
						b.Send(m.Chat, fmt.Sprintf("Task #%v is not completed at the moment, you may use /link%v command to display url of this task", taskNumber, taskNumber))
					}
				}
			}
			if !found {
				b.Send(m.Chat, fmt.Sprintf("Task #%v is not found", taskNumber))
			}

		} else if linkNTemplate.MatchString(m.Text) {
			taskNumber := linkNTemplate.FindStringSubmatch(m.Text)[1]
			opt := &github.IssueListByRepoOptions{State: "all", Labels: []string{TASK_LABEL}}
			listTasks, _, _ := client.Issues.ListByRepo(ctx, GITHUB_ACCOUNT, GITHUB_REPOSITORY, opt)
			captionTemplate := regexp.MustCompile(`"Task (\d?): (.*?)"`)
			found := false
			for _, task := range listTasks {
				title := github.Stringify(task.Title)
				titleParsed := captionTemplate.FindStringSubmatch(title)
				if titleParsed[1] == taskNumber {
					found = true
					caption := strings.ToLower(strings.Replace(titleParsed[2], " ", "_", -1))
					url := fmt.Sprintf("https://github.com/%v/%v/tree/main/task%v_%v", GITHUB_ACCOUNT, GITHUB_REPOSITORY, titleParsed[1], caption)
					b.Send(m.Chat, fmt.Sprintf("%v %v\n", title, url))
				}
			}
			if !found {
				b.Send(m.Chat, fmt.Sprintf("Task #%v is not found", taskNumber))
			}

		} else {
			b.Send(m.Chat, "Unknown command, use /help for help")
		}
	})

	lambda.Start(func(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
		var u tb.Update
		if err = json.Unmarshal([]byte(req.Body), &u); err == nil {
			b.ProcessUpdate(u)
		}
		return events.APIGatewayProxyResponse{Body: "ok", StatusCode: 200}, nil
	})
}
