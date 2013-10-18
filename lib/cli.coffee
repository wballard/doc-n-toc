{docopt} = require 'docopt'
path= require 'path'
pkg = require(path.join(__dirname, "../package.json"))
os = require 'os'
fs = require 'fs'
wrench = require 'wrench'
harp = require 'harp'
Inliner = require 'inliner'

doc = """
#{pkg.description}

Usage:
  doc-n-toc <markdown_file>... --title=<title>
  doc-n-toc -h | --help | --version

Description:
  This will take one or more markdown files, stitch them together end-to-end,
  and generate you a self contained, single page documentation 'site' complete
  with a table of contents.
"""

options = docopt doc, version: pkg.version

work_dir = path.join os.tmpdir(), "#{process.pid}"
wrench.mkdirSyncRecursive work_dir, 0o0777
process.on 'exit', ->
  wrench.rmdirSyncRecursive work_dir

template = path.join __dirname, '../templates/default'

wrench.copyDirSyncRecursive template, work_dir, forceDelete: true

for file in options['<markdown_file>']
  fs.appendFileSync path.join(work_dir, 'public', 'index.md'), fs.readFileSync(file)

fs.writeFileSync path.join(work_dir, 'harp.json'), JSON.stringify
  globals:
    title: options['--title'] or 'Documentation'
    copyright: new Date().getYear() + 1900

harp.compile work_dir, path.join(work_dir, 'build'), (err) ->
  if err
    console.error err
    process.exit 1
  else
    new Inliner 'file://' + path.join(work_dir, 'build', 'index.html'), (html) ->
      console.log html
