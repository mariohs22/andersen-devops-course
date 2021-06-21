# Github

**Current status: done**

## Task description

### Unleash your creativity with GitHub

- write a script that checks if there are open pull requests for a repository. An url like "https://github.com/$user/$repo" will be passed to the script
- print the list of the most productive contributors (authors of more than 1 open PR)
- print the number of PRs each contributor has created with the labels
- implement your own feature that you find the most attractive: anything from sorting to comment count or even fancy output format
- ask your chat mate to review your code and create a meaningful pull request
- do the same for her xD
- merge your fellow PR! We will see the repo history

## Task execution

Run `git_contrib.sh` script with github reposirory link as attribute:

```
git_contrib.sh https://github.com/curl/curl
```

The script shows ordered list of most productive contributors (is any) of defined repository, list of all pull request authors (with PRs count) and head labels of each pull request by author.

## Task explanation

Script uses [GitHub REST API](https://docs.github.com/en/rest) to retrieve data with [Curl](https://github.com/curl/curl) and uses [jq](https://github.com/stedolan/jq) to process JSON data:

1. Parse attribute to retrieve github <user-name> and <repository>.
2. Use `https://api.github.com/repos/<user-name>/<repository>/pulls?state=open` to get all open PRs, use `jq` to get all user logins of each open PRs, count up PRs of repeating users, sort it in descending order by open PRs count and finally use `awk` prepare table view of the resulting data.
3. Use `https://api.github.com/repos/<user-name>/<repository>/pulls` to get all PRs, get and display authors (user logins) of each PR like in previous step. Additionally display head labels of each PR by getting `.head.label` section of API response with `jq`.

### Hints

- [Have a look here](https://github.com/trending)
- read about GitHub API
- make use of curl and jq
