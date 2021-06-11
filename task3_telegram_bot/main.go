package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/google/go-github/v35/github"
	tb "gopkg.in/tucnak/telebot.v2"
)

const GITHUB_ACCOUNT = "mariohs22"
const GITHUB_REPOSITORY = "andersen-devops-course"

func main() {
	b, err := tb.NewBot(tb.Settings{
		Token:       os.Getenv("BOT_TOKEN"),
		Synchronous: true,
	})
	if err != nil {
		panic(err)
	}

	b.Handle(tb.OnText, func(m *tb.Message) {
		// git := regexp.MustCompile("/^/git$/i")
		// if git.MatchString(m.Text) {

		if strings.EqualFold(m.Text, "/git") {

			b.Send(m.Chat, "https://github.com/"+GITHUB_ACCOUNT+"/"+GITHUB_REPOSITORY)

		} else if strings.EqualFold(m.Text, "/tasks") {

			b.Send(m.Chat, "List of completed tasks:\n")
			client := github.NewClient(nil)
			ctx := context.Background()
			opt := &github.IssueListByRepoOptions{State: "closed", Labels: []string{"task"}}
			listIssues, _, _ := client.Issues.ListByRepo(ctx, GITHUB_ACCOUNT, GITHUB_REPOSITORY, opt)
			for i, task := range listIssues {
				message := fmt.Sprintf("%v. %v\n", i+1, github.Stringify(task.Title))
				b.Send(m.Chat, message)
			}

		} else {
			b.Send(m.Chat, m.Text)
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
