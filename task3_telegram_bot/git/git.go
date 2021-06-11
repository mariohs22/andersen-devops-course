package main

import (
	"context"
	"fmt"
	"regexp"
	"strings"

	"github.com/google/go-github/v35/github"
)

const GITHUB_ACCOUNT = "mariohs22"
const GITHUB_REPOSITORY = "andersen-devops-course"

func main() {
	req := "2"

	client := github.NewClient(nil)
	ctx := context.Background()
	opt := &github.IssueListByRepoOptions{State: "all", Labels: []string{"task"}}
	listIssues, _, _ := client.Issues.ListByRepo(ctx, GITHUB_ACCOUNT, GITHUB_REPOSITORY, opt)

	rg := fmt.Sprintf("Task %v:", req)
	fmt.Println(rg)
	captionTemplate := regexp.MustCompile(`"Task (\d?): (.*?)"`)
	for i, task := range listIssues {
		title := github.Stringify(task.Title)
		titleParsed := captionTemplate.FindStringSubmatch(title)
		if titleParsed[1] == req {
			caption := strings.ToLower(strings.Replace(titleParsed[2], " ", "_", -1))
			url := fmt.Sprintf("https://github.com/%v/%v/tree/main/task%v_%v", GITHUB_ACCOUNT, GITHUB_REPOSITORY, titleParsed[1], caption)
			fmt.Printf("%v. %v %v\n", i+1, title, url)
		}
	}
}
