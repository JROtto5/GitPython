#!/usr/bin/env bash
set -eu
git init -q --object-format="$1" --ref-format="$2" repo
cd repo
printf tracked > tracked
git add tracked
git commit -qm initial
track() {
    git branch "$1"
    git config "branch.$1.remote" "$2"
    git config "branch.$1.merge" "$3"
}
git config remote.origin.url ../upstream.git
git config remote.origin.fetch '+refs/heads/*:refs/remotes/mirror/*'
git update-ref refs/remotes/mirror/feature HEAD
track mapped origin refs/heads/feature
track unfetched origin refs/heads/unfetched
git config remote.1.10.url ../numbered.git
git config remote.1.10.fetch '+refs/heads/*:refs/remotes/1.10/*'
track numbered 1.10 refs/heads/main
git config remote.nofetch.url ../nofetch.git
track unmapped nofetch refs/heads/main
git branch local-upstream
track local . refs/heads/local-upstream
track by-url https://example.invalid/upstream.git refs/heads/main
cd ..
git init -q --object-format="$1" --ref-format="$2" empty
cd empty
git symbolic-ref HEAD refs/heads/main
git config remote.origin.url ../upstream.git
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git config branch.main.remote origin
git config branch.main.merge refs/heads/main
git config branch.solo.remote .
git config branch.solo.merge refs/heads/main
