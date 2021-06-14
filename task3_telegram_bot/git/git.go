package main

// Template package for local debug:
// Use: /go run .

import (
	"context"
	"fmt"
	"regexp"
	"sort"
	"strings"

	"github.com/google/go-github/v35/github"
)

const GITHUB_ACCOUNT = "mariohs22"
const GITHUB_REPOSITORY = "andersen-devops-course"
const TASK_LABEL = "task"

func main() {
	req := "/task1"

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
			fmt.Println("List of completed tasks:\n" + fmt.Sprint(strings.Trim(fmt.Sprint(listTasks), "[]")))
		} else {
			fmt.Println("Done tasks not found")
		}

	} else if taskNTemplate.MatchString(req) {
		client := github.NewClient(nil)
		ctx := context.Background()
		taskNumber := taskNTemplate.FindStringSubmatch(req)[1]
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
					fmt.Printf("%v %v\n", title, url)
				} else {
					fmt.Printf("Task #%v is not completed at the moment, you may use /link%v command to display url of this task", taskNumber, taskNumber)
				}
			}
		}
		if !found {
			fmt.Printf("Task #%v is not found", taskNumber)
		}

	} else {
		fmt.Println("Wrong command, use /help for help")
	}

}
