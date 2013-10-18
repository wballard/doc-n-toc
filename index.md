# Get Started
Here is a quick start to make a nice github page.

```
#tool up
npm install -g doc-n-toc
#go to your git repository, set up for github pages
git checkout --orphan gh-pages
#... write a manual in a markdown file ... :)
doc-n-toc manual.md --title MyProject > index.html
git add manual.md index.html
git commit -m 'yep, simple gh pages'
git push --set-upstream origin gh-pages
```

And done. Fire up your browser at `http://[username].github.io/[repo]`
