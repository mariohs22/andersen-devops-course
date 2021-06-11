package main

// Template package for debug:
// Use: cd git
//      go run .
//
// Deploy: env GOOS=linux go build -o bin/webhook main.go
//         serverless deploy -v

import (
	"context"
	"fmt"
	"regexp"
	"strings"

	"github.com/google/go-github/v35/github"
)

const GITHUB_ACCOUNT = "mariohs22"
const GITHUB_REPOSITORY = "andersen-devops-course"
const TASK_LABEL = "task"

func main() {
	req := "/task3"

	gitTemplate := regexp.MustCompile(`(?i)^/git$`)
	helpTemplate := regexp.MustCompile(`(?i)^/help$`)
	tasksTemplate := regexp.MustCompile(`(?i)^/tasks$`)
	taskNTemplate := regexp.MustCompile(`(?i)^/task(\d+)$`)

	if helpTemplate.MatchString(req) {
		fmt.Println(`Use this commands: ...`)
	} else if gitTemplate.MatchString(req) {
		url := fmt.Sprintf("https://github.com/%v/%v", GITHUB_ACCOUNT, GITHUB_REPOSITORY)
		fmt.Println(url)
	} else if tasksTemplate.MatchString(req) {
		client := github.NewClient(nil)
		ctx := context.Background()
		opt := &github.IssueListByRepoOptions{State: "closed", Labels: []string{TASK_LABEL}}
		listTasks, _, _ := client.Issues.ListByRepo(ctx, GITHUB_ACCOUNT, GITHUB_REPOSITORY, opt)
		found := false
		for i, task := range listTasks {
			found = true
			message := fmt.Sprintf("%v. %v\n", i+1, github.Stringify(task.Title))
			fmt.Println(message)
		}
		if !found {
			fmt.Println("Done tasks not found")
		}

	} else if taskNTemplate.MatchString(req) {
		taskNumber := taskNTemplate.FindStringSubmatch(req)[1]
		client := github.NewClient(nil)
		ctx := context.Background()
		opt := &github.IssueListByRepoOptions{State: "all", Labels: []string{TASK_LABEL}}
		listTasks, _, _ := client.Issues.ListByRepo(ctx, GITHUB_ACCOUNT, GITHUB_REPOSITORY, opt)
		captionTemplate := regexp.MustCompile(`"Task (\d?): (.*?)"`)
		found := false
		for i, task := range listTasks {
			title := github.Stringify(task.Title)
			titleParsed := captionTemplate.FindStringSubmatch(title)
			if titleParsed[1] == taskNumber {
				found = true
				caption := strings.ToLower(strings.Replace(titleParsed[2], " ", "_", -1))
				url := fmt.Sprintf("https://github.com/%v/%v/tree/main/task%v_%v", GITHUB_ACCOUNT, GITHUB_REPOSITORY, titleParsed[1], caption)
				fmt.Printf("%v. %v %v\n", i+1, title, url)
			}
		}
		if !found {
			fmt.Printf("Task #%v is not found", taskNumber)
		}

	} else {
		fmt.Println("Wrong command, use /help for help")
	}

}
