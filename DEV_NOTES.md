# DAN SHUMAKER - Dev Notes

## Dot File Management

This repo is under rcm management <https://github.com/thoughtbot/rcm>

## Vim Updates

```bash
pip3 install neovim
npm install -g neovim
nvm install --latest-npm
```

### Update everything

```bash
brew update
brew upgrade
brew bundle dump --force --describe
npm run build
cd .composer
composer update
pip3 install --upgrade pynvim
```

### Update

- `brew bundle dump --force --describe` (to update brewfile)

### Install

- `brew bundle` (installs everything)
- `brew bundle --help`

### Clean

`brew bundle cleanup -f` (to cleanup unused dependencies)

## Composer Files

### Dependency

- This gets phpcbf and drupal coder and drush, and phpcs fixer.
- `cd .composer`

### Update

- `composer update`

### Install

- `composer install`

## Node Files

### Install

- `npm run preinstall`

### Update

- `npm run build`

### Clean

- `npm remove -g XXXX` && `npm run build`

#### Example Usage

```
mkrc .vimrc
```

- adds a file to the .dotfiles directory management system
- It moves it into the .dotfiles and makes a simlink in the parent directory to it.

## GIT Notes

[Make Markdown Tables](https://www.tablesgenerator.com/markdown_tables)

| Command                                                       |                                        Meaning |
| :------------------------------------------------------------ | ---------------------------------------------: |
| `git diff --name-status`                                      |                    print only file differences |
| `git diff --cached`                                           |         show diff of changes already committed |
| `git log --grep`                                              |                                 search the log |
| `git checkout -- .`                                           |                           forget local changes |
| `git checkout branchname file/to/restore`                     | checkout version of a file from another branch |
| `git tag -n1`                                                 |                show git tags with descriptions |
| `git log --full-history -- modules/custom/doi_gov_medai/file` |                         full history of a file |
| `git log --follow -p --stat -- composer.json`                 |                       show git diffs over time |

## Diff file in different branch

| Command                                                                    | Meaning                                                     |
| -------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `git difftool branch1:config/environment.rb branch2:config/environment.rb` | Diff files in different branches                            |
| `git diff mybranch master -- path/to/file/myfile.cs`                       | Diff files in different branches                            |
| `git diff --name-status branch1..branch2`                                  | diff branches                                               |
| `git reset --hard XXXXX`                                                   | reset current branch to a sha1                              |
| `git diff sha1 sha2`                                                       | diff between commits                                        |
| `git reset --soft SHA1 , git commit , git push -f`                         | How to squash commits on a branch back your starting commit |
| `git branch -m old new`                                                    | (rename a branch -- move)                                   |

## Git PATCHES

```bash
git diff sha2 sha2 > save.patch; patch -p1 < save.patch :  creating patch from diff and applying with p1
git format-patch -1 sha , git apply --stat file.patch ; git apply --check file.patch; git am < file.patch
```

`fshow` (find commits before changes for proper range to undo

### Generate the patches

`git format-patch 757c275f..73575cb8`

- Then Revert them

```bash
git apply -R 0001-WB-420-Meta-tag-patch-customizations-for-all-node-ty.patch
git apply -R 0002-WB-420-composer-update.patch
```

## Git commit and push

| Command                                          |                                                                                              Meaning |
| :----------------------------------------------- | ---------------------------------------------------------------------------------------------------: |
| `git stash "bla bla message"`                    |                                                                                        Creates stash |
| `git stash list`                                 |                                                                                        lists stashes |
| `git checkout stash@{0} -- file/path/file.name`  |                                                                Checkout a specific file from a stash |
| `git reset filepath ; git checkout -- file/path` |                                                                              reset changes to a file |
| `gsearch`                                        |                                   search git log ( more for searching comments and showing branches) |
| `fshow`                                          |                  search git log (better for searching sha1s) can hit enter and browse the commit log |
| `fcs`                                            | search git log - print out the sha - don't do anything else. - more for scripting - some interaction |
| `gitv`                                           |                                                                                       git vim plugin |

# Composer

| Command                            |                                                                                                                                            Meaning |
| :--------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------: |
| `fin composer update nothing`      |                                                                             which will update no modules but will update the hash so it validates. |
| `fin composer validate`            |                                                                                will just validate the composer file as apposed to the whole stack. |
| `composer-lock-diff`               |                                                                                         then to see what was updated after a `fin composer update` |
| `composer depends symfony/console` | shows what packages depend on symfony/console this is often more useful than `composer show --tree` when trying to untangle dependency tree issues |
| `composer diagnose`                |                                                                                                                               To diagnose slowness |
| `composer selfupdate`              |                                                                                                                                 To update composer |
| `sudo composer self-update --1`    |                                                                                                                       to downgrade composer 2 to 1 |
| `composer -vvv --profile`          |                                                                                                                         Suggests debugging options |

# VIM

## [Neovim](https://kushellig.de/neovim-php-ide/)

| Command                                 |                                                                      Meaning |
| :-------------------------------------- | ---------------------------------------------------------------------------: |
| `set tw=80`                             |                                                set textwidth (word wrapping) |
| `gg=G`                                  |                                                 Apply indentation formatting |
| `gggqG`                                 |                                 Apply textwidth formatting to whole document |
| `gq`                                    |                     format the {visual} lines with line formatting (help gq) |
| `80l`                                   |                                                               Goto column 80 |
| `\sh`                                   |                                                                    vim shell |
| `\note`                                 |                                                          Open this note file |
| `\csh`                                  |                                                       load .bashrc in editor |
| `.!sh`                                  |   Execute in a shell what is under the cursor and put its output in the file |
| `r !/users/dan/bin/bash/status -nc -as` |                                execute command and put it's output in buffer |
| `CTR-W gf`                              |                                       Open file that cursor is on in new tab |
| `gf`                                    |                                     open file under cursor in current window |
| `gx`                                    |                                                          open url in browser |
| `<space>mx`                             |                                                        Maximize window width |
| `zi`                                    |                                                              disable folding |
| `vim "+set nofen" filename`             |                                             open vim with folding turned off |
| XXX                                     |                                                            fold php comments |
| `:g/re/p`                               | or `:g/XXX` to show search results or `:vimgrep /XXX/j % ;` or `:lvim XXX %` |
| `/blas\C`                               |                                     The \C signals case insensitive searches |
| ✅ i + Crtl v + u2705                   |                                             will insert a green ✅ checkmark |
| ✓ i + Ctrl v + u2713                    |                                                will insert a small checkmark |
| ❌ i + Ctrl v + u274c                   |                                                                 Insert red x |

| ⚠
| :SearchUnicode check mark | shows all check mark codes |
| ✔ i + Ctrl v + u2714 | insert heavy check mark |
| `,cs` | copy current filename to clipboard |
| • | Option 8 inserts a bullet / dot |

## _drupal-api_ _drupal-\da_

- **These don't work (except the hook_menu<TAB> one) because I think danshumaker/vim-snippets commented out.**
- `\da` Look up the API docs for a drupal function under cursor and open it in
  a web browser.
- `\dh` Look up the API docs for a hook implemented by the drupal function
  under the cursor and open it in a web browser.
- `\dc` Same as \da but use <http://drupalcontrib.org/>.
- `\dda`Look up the API docs for a drush function under cursor and open it in
  a web browser.
- `\dv` Get the value of the drupal variable under cursor. (Requires drush.)
- hook_menu<TAB> Activates/inserts snippets

## Tabs

- gt next tab
- gT goto previous tab
- `{count}gt` Go to tab page {count}. The first tab page
  has number one.

## Registers

- "ay8l Yank 8 characters to the right to register a
- "ap Paste register a
- :reg show named registers and what's in them
- "5p paste what's in register "5
- qk records edits into register k (q again to stop recording)
- @k execute recorded edits (macro)
- @@ repeat last one
- 5@@ repeat 5 times
- "kp print macro k (e.g., to edit or add to .vimrc)
- "kd replace register k with what cursor is on
- di ab Display registers a and b
- v Visual marking mode
- {Visual}"ay store visual block in register a
- "%p Paste the current file name
- ,cs Copy the current file name to the clipboard

## Vim Windows

- CTRL-W = Make all windows (almost) equally high and wide, but use
- CTRL-W - Decrease current window height by N (default 1).
- CTRL-W + Increase current window height by N (default 1).
- CTRL-W \_ Set current window height to N (default: highest possible).
- CTRL-W < Decrease current window width by N (default 1).
- CTRL-W > Increase current window width by N (default 1).
- CTRL-W r Rotate windows downwards/rightwards. The first window becomes
- CTRL-W R Rotate windows upwards/leftwards. The second window becomes
- CTRL-W x Exchange current window with next one. If there
- CTRL-W K Move the current window to be at the very top, using the full
- **CTRL-W J Convert Current Vertical Split to be horizontal Split**
- CTRL-W H Move the current window to be at the far left, using the
- CTRL-W L Move the current window to be at the far right, using the full
- CTRL-W T Convert the current window to a new tab page. This fails if
- Ctrl-j Buffer Next
- Ctrl-h Jump to split on left
- Ctrl-l Jump to split on right
- 4 C-h JUMP to tab split 4 to left
- 4 C-l JUMP to tab split 4 to right

## VIM The Silver Searcher (Ag) - Ripgrep is better & faster

- Ag Search all files for strings
- AgFile Search for file names
- // Search $PD for occurances of highlighted text
- /bla y//e :Ag <Ctrl-R>+ Perform Ag on highlighted text (three steps 1. hightlight 2. yank to register 3. Paste into Ag command
- :Ag Ctrl-Ra supply register "a" to the Ag command
- <Ctrl-w>L Make copen (quickfix window) a vertical split - NOTE Capital L not lowercase
- v Opens file in vertical split

## Ripgrep + FZF

- Ctrl-g l Search the current buffer in fzf buffer
- <space>/ Search files on disk for a string in background (then eventually load quicklist)
- <space>rg Search files on disk for string interactively
- <space><space> Search for file names in fzf buffer

## VIM Git - FUGITIVE

- gitv (like fshow but in vim)
- BCommits (show commits of a file)
- Gstatus
- :copen Open quickfix list
- ]q Next through quickfix list
- [q Previous through quickfix list
- :Gblame Git blame on file
- :Ggrep
- :Glog with no arguements just opens the file with commits in cw to browse through
- :Glog Show git log for file
- ++good :Glog with no arguements just opens the file with commits in cw to browse through
- :Glog -Sfindme --
- :Glog --grep=findme search commit messages for findme <http://vimcasts.org/episodes/fugitive-vim-exploring-the-history-of-a-git-repository/>
- :Glog -- % Load commit objects into quicklist for a file
- :Glog -10 -- % Load last 10 commit objects into quicklist for a file, then do :copen
- :Gedit branchname:path/to/file Edit file in another branch
- :Gsplit branchname:% Edit file from another branch in split window
- :Gdiff branchname:% Gdiff file from another branch
- :Gvsplit branch:file_name.c (file in different branch)
- :Gvsplit branch (diff current in different branch)
- :Gstatus Load interactive git status
- :Gvdiff master (diff in vertical split of current file in master branch)
- <space>gv (browse commits just like :gitv)

## [Fugitive](http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/)

- dv Split vertical with git diff of file under cursor
- <C-N> next file
- <C-P> previous file
- <CR> :Gedit
- :Git add
- :Git reset (staged files)
- cA :Gcommit --amend --reuse-message=HEAD
- ca :Gcommit --amend
- cc :Gcommit
- cva :Gcommit --amend --verbose
- cvc :Gcommit --verbose
- D :Gdiff
- ds :Gsdiff
- dp :Git! diff (p for patch; use :Gw to apply)
- dp :Git add --intent-to-add (untracked files)
- dv :Gvdiff
- O :Gtabedit
- o :Gsplit
- p :Git add --patch
- p :Git reset --patch (staged files)
- q close status
- r reload status
- S :Gvsplit
- U :Git checkout
- U :Git checkout HEAD (staged files)
- U :Git clean (untracked files)
- U :Git rm (unmerged files)

## NVIM FZF

- <C-g>g :Ag<CR> THIS ONLY WORKS FOR ALREADY SELECTED TEXT IN THE BUFFER
- <C-g>c :Commands<CR>
- <C-f>l :BLines<CR>
- <C-p> :Files<CR>
- git branch fzf-tmux -d 15 (open browser for git branches)
- <C-p> enter (open file in current window)
- <C-p> CTRL-T (open file in tab)
- <C-p> CTRL-X (open file horz split)
- <C-p> CTRL-V (vertical splits respectively)
- <C-j> move down choice
- <C-h> move up choice
- `Files [PATH]` Files (similar to `:FZF` )
- `GFiles [OPTS]` Git files (git ls-files)
- `GFiles?` Git files (git status)
- `Buffers` Open buffers (Control-v for vertical split on selection)
- `Colors` Color schemes
- `Ag [PATTERN]` {ag}{5} search result (ALT-A to select all, ALT-D to deselect all)
- `Lines [QUERY]` Lines in loaded buffers
- `BLines [QUERY]` Lines in the current buffer
- `Tags [QUERY]` Tags in the project ( `ctags -R` )
- `BTags [QUERY]` Tags in the current buffer
- `Marks` Marks
- `Windows` Windows
- `Locate PATTERN` `locate` command output
- `History` `v:oldfiles` and open buffers
- `History:` Command history
- `History/` Search history
- `Snippets` Snippets ({UltiSnips}{6})
- `Commits` Git commits (requires {fugitive.vim}{7})
- `BCommits` Git commits for the current buffer
- `Commands` Commands
- `Maps` Normal mode mappings
- `Helptags` Help tags [1]
- `Filetypes` File types

## NVIM Searching

- Find Files <space><space>
- Search within Commands <c-c>
- Search for word under cursor <c-j>
- Search Current Buffer <c-k>
- Global dir string search <c-l>
- Tag Search <c-t>
- Edit Keymap file <space>k
- Search Git Commits <space>c
- See list file of buffers '<space>b'

## [Diff progression through time](https://github.com/mattboehm/vim-accordion)

The easiest way to open versions of a file is to run fugitive's :Glog --reverse,
highlight the desired changes in the quickfix list, and hit the unstack shortcut.

```vim
:Glog --reverse
:cw
highlight lines.
<space>s
:AccordionDiff
```

## Vim Gvimdiff

- do diff obtain
- dp diff put

## Vim VDebug

- \<F5> start/run (to next breakpoint/end of script)
- \<F2> step over
- \<F3> step into
- \<F4> step out
- \<F6> stop debugging (kills script)
- \<F7> detach script from debugger
- \<F9> run to cursor
- \<F10> toggle line breakpoint
- \<F11> show context variables (e.g. after "eval")
- \<F12> evaluate variable under cursor
- :Breakpoint <type> <args> set a breakpoint of any type (see :help VdebugBreakpoints)
- :VdebugEval \<code\> evaluate some code and display the result
- \<Leader>e evaluate the expression under visual highlight and display the result

## Vim Vimium Chrome Plugin

- ? to bring up help
- j scroll down
- k scroll up
- H go back in history
- t create new tab
- J go tab left
- K go tab right

### Tmux Windows

- Show Command Mapping
- c create window
- w list windows
- n name Session window
- p previous window
- f find window
- , name Pane
- & kill window
- % vertical split
- " horizontal split
- o swap panes
- q show pane numbers
- x kill pane
- - break pane into window (e.g. to select text by mouse to copy)
- . move window (give the destination session as argument)
- ⍽ space - toggle between layouts
- q (Show pane numbers, when the numbers show up type the key to goto that pane)
- { (Move the current pane left)
- } (Move the current pane right)
- z toggle pane zoom
- ! Turn pane into window
- equal size windows: select-layout even-vertical
- > Goto window to the right
- < Goto window to the left

#### Sessions

- $ Name session
- tmux rename-session [-t current-name] [new-name]
- tmux list-sessions
- tmux ls (list sessions)
- mux kill-session -a (kills all but current session)
- ( previous session connect
- ) next session connect
- Ctrl-S Shift-S (choose client/session from list and switch to it)

# CSS

## FLOATS

Floated elements are not recognized by their parent containers.
Unless: 1. parent is also floated. -- do NOT do this.
or 2. You add a clear :(both,left, right) to the last element within the parent.
-- Clunky but commonly used. 3. clear the :after psuedo element to the parent. 4. Add overflow:hidden, width:100%, or overflow:auto to the parent.
--best solution

Floated elements can't be centered without a width.

Use INLINE-BLOCK however:

1. set vertical-align:top
2. white space carriage returns are displayed.
   a. Solve by taking out carriage returns.
   or
   b. Set parent font size to zero and li elements to normal size.

# Drupal / DRUPAL

## Drupal Debug Output

| Command                                                                             | Description                       |
| ----------------------------------------------------------------------------------- | --------------------------------- |
| dpm                                                                                 | drupal print message              |
| dd                                                                                  | output to drupal_debug.txt in tmp |
| `drush eval "print_r(array_keys(\Drupal::entityTypeManager()->getDefinitions()));"` | Print Entity Types                |

## Print out settings on cli

```drush
drush ev "var_dump(Drupal\Core\Database\Database::getAllConnectionInfo());"
drush cget memcache
drush cget memcache.servers
drush ev "var_dump(\Drupal\Core\Site\Settings::getAll())"
drush ev "var_dump(\Drupal\Core\Site\Settings::get('memcache'))"
drush ev "var_dump(\Drupal\Core\Site\Settings::get('cache'))"
```

## Adding admin menu item Drupal 8/9

- file: fjc_countdown.routing.yml

```yml
fjc_countdown.admin_index:
  path: "/admin/config/count_down"
  defaults:
    _controller: '\Drupal\system\Controller\SystemController::systemAdminMenuBlockPage'
    _title: "Count Down"
  requirements:
    _permission: "access administration pages"
```

- Programatically render a twig template.

```php
    $active_theme = \Drupal::service('theme.manager')->getActiveTheme();
    $template_file = $active_theme->getPath() . '/templates/fjc_countdown_inject.html.twig';

    // Check if template in the active theme exist.
    if (!file_exists($template_file)) {
      $module_path = drupal_get_path('module', 'fjc_countdown');
      $template_file = $module_path . '/templates/fjc_countdown_inject.html.twig';
    }
    $is_admin = \Drupal::service('router.admin_context')->isAdminRoute();
    if (!$is_admin) {
      // Render twig template.
      $twig_service = \Drupal::service('twig');
      $html = $twig_service->loadTemplate($template_file)->render($vars);
      $page_top['fjc_countdown_inject'] = [
        '#type' => 'inline_template',
        '#children' => $html,
      ];
    }
```

# [MAC OSX File PERMISSIONS](http://www.thexlab.com/faqs/immutableflags.html)

## To see attributes

```
ls -lOd X
ls -l@d X
```

## To get rid of ACL's do

```
chflags nohidden X
chflags noarch X
```

## Example: -rw-r--r--

The first character in the output indicates the file mode, e.g. a file (-) or a directory (d).
The remaining characters specify the access modes or permissions assigned to that object. If this strings ends in an at sign (@), the object has extended attributes. If this string ends in a plus sign (+), the object has extended security information, such as an Access Control List (ACL).

## To get rid of extended attributes use xattr -c

```
xattr -rc X
```

## To see what they are

```
ls -le X
```

- - <http://osxadmin.blogspot.com/2008/01/chmod-acl-removal.html>

```
sudo echo  sudo chmod -R -E ./*
```

or

```
sudo chmod -R -N ./*
```

## Mac Screens

- Zoom In : Command Option =
- Zoom Out : Command Option -
- Zoom Reset : Command Option 8
- Screen Measure : Command Shift 4

### GREAT WEB DESIGNS

- <http://join.me>
- <http://www.stumbleupon.com/>
- <http://strava.com>
- <http://www.letstravelsomewhere.com/travel/america/>

## LINUX

- <https://quizlet.com/44970397/linux-and-hacking-common-commands-and-memorize-mes-flash-cards/>
- <https://vimeo.com/54505525>

- TOP config
  top 1 l mmm ttt z W
  1 multi-proc
  mmm graphed memory
  ttt graphed procs
  l load
  z for color
  W allows saving a config file ~/.top

## REGEX

- <https://regex101.com/r/opuu2n/1> AWESOME REFERENCE!
- <https://lzone.de/cheat-sheet/Bash%20Regex>

## Lotto - Stuff to buy if get money

- Larger 10 stage water filter.
- Exhaust fan system for whole house.
- Turf lawn

## Internet Speed Average at Home

- 28 - 37 Mega Bits Per Second Mbps - Download
- 5 mbps - upload.

## SALARY / HOURLY

| Dollars/Hour | Yearly Salary |
| ------------ | ------------- |
| 43           | 90,000        |
| 44           | 91,520        |
| 45           | 93,600        |
| 46           | 95,680        |
| 47           | 97,760        |
| 48           | 99,840        |
| 49           | 101,920       |
| 50           | 104,000       |
| 55           | 114,400       |
| 60           | 125,000       |
| 65           | 135,200       |

| test | this                                      | table                                                                                                                                                                         | header |     |
| ---- | ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | --- |
| bla  |                                           |                                                                                                                                                                               |        |     |
|      | bla what will this do on multi line input | Unfortunately if your position does not have these attributes then I am not interested. If it does have these attributes then I'd be glad to talk to you as soon as possible. |        |     |
|      |                                           | bla                                                                                                                                                                           |        |     |

## Lando Quick Start

- quickstart -builder lando -host pantheon -d 7

## Docksal Quick Start

- quickstart -builder docksal -host pantheon -d 8

  If Xdebug version 2 then use port 9000 for debugging.
  If Xdebug version 3 then use port 9003 for debugging
  fin exec php -v | grep -i xdebug

## Lua Notes

/.dotfiles/config/nvim
init.lua
lua/plugins/paq-nvim.lua
lua/settings.lua
backup/luavimrc backup/vimrc

/.dotfiles/local/share/nvim/

# ChadTree Keybinds

Keybinds can be customized under `chadtree_settings.keymap.<key>` with a set of keys.
["q"] Close CHADTree window, quit if it is the last window.
["+", "="] Resize CHADTree window bigger.
["-", "_"] Resize CHADTree window smaller.
["<c-r>"] Refresh CHADTree.
["b"] Change vim's working directory.
["c"] Set CHADTree's root to folder at cursor. Does not change working directory.
["C"] Set CHADTree's root one level up.
["<enter>"] Open file at cursor.
["<tab>", "<2-leftmouse>"] Open file at cursor, keep cursor in CHADTree's window.
["<c-t>", "<middlemouse>"] Open file at cursor in a new tab.
["w"] Open file at cursor in vertical split.
["e"] Open file at cursor in new tab.
["W"] Open file at cursor in horizontal split.
["o"] Open file with GUI tools using `open` or `xdg open`. This will open third party tools such as `Finder` or `KDE Dolphin` or `GNOME nautilus`, etc. Depends on platform and user setup.
["<s-tab>", "`"] Collapse all subdirectories for directory at cursor.
["~"] Put cursor at the root of CHADTree
["J"] Position cursor in CHADTree at currently open buffer, if the buffer points to a location visible under CHADTree. ["K"] Print`ls --long` stat for file under cursor.
["y"] Copy paths of files under cursor or visual block.
["Y"] Copy names of files under cursor or visual block.
["f"] Set a glob pattern to narrow down visible files.
["F"] Clear filter.
["s"] Select files under cursor or visual block.
["S"] Clear selection.
["a"] Create new file at location under cursor. Files ending with platform specifc path seperator will be folders.
["r"] Rename file under cursor.
["p"] Copy the selected files to location under cursor.
["x"] Move the selected files to location under cursor.
["d"] Delete the selected files. Items deleted cannot be recovered.
["t"] Trash the selected files using platform specific `trash`command, if they are available. Items trashed may be recovered. You need [`brew install trash`](https://formulae.brew.sh/formula/trash) for MacOS
["."] Toggle`show_hidden` on and off. See `chadtree_settings.options.show_hidden` for details.
["u"] Toggle `follow` on and off. See `chadtree_settings.options.follow` for details.
[] Toggle version control integration on and off

## Git Forgit Aliases helper

- <https://github.com/wfxr/forgit>
- **Interactive `git log` viewer** (`glo`)
- **Interactive `git diff` viewer** (`gd`)
- **Interactive `git checkout <branch>` selector** (`gcb`)
- **Interactive `git stash` viewer** (`gss`)

- **Interactive `git add` selector** (`ga`)
- **Interactive `.gitignore` generator** (`gi`)
- **Interactive `git reset HEAD <file>` selector** (`grh`)
- **Interactive `git checkout <file>` selector** (`gcf`)
- **Interactive `git checkout <commit>` selector** (`gco`)
- **Interactive `git clean` selector** (`gclean`)
- **Interactive `git cherry-pick` selector** (`gcp`)
- **Interactive `git rebase -i` selector** (`grb`)
- **Interactive `git commit --fixup && git rebase -i --autosquash` selector** (`gfu`)

### ⌨ Keybinds

|                      Key                      | Action                    |
| :-------------------------------------------: | ------------------------- |
|               <kbd>Enter</kbd>                | Confirm                   |
|                <kbd>Tab</kbd>                 | Toggle mark and move up   |
|       <kbd>Shift</kbd> - <kbd>Tab</kbd>       | Toggle mark and move down |
|                 <kbd>?</kbd>                  | Toggle preview window     |
|         <kbd>Alt</kbd> - <kbd>W</kbd>         | Toggle preview wrap       |
|        <kbd>Ctrl</kbd> - <kbd>S</kbd>         | Toggle sort               |
|        <kbd>Ctrl</kbd> - <kbd>R</kbd>         | Toggle selection          |
|        <kbd>Ctrl</kbd> - <kbd>Y</kbd>         | Copy commit hash\*        |
| <kbd>Ctrl</kbd> - <kbd>K</kbd> / <kbd>P</kbd> | Selection move up         |
| <kbd>Ctrl</kbd> - <kbd>J</kbd> / <kbd>N</kbd> | Selection move down       |
| <kbd>Alt</kbd> - <kbd>K</kbd> / <kbd>P</kbd>  | Preview move up           |
| <kbd>Alt</kbd> - <kbd>J</kbd> / <kbd>N</kbd>  | Preview move down         |

# PHP Extensions

`php -r 'print_r((get_loaded_extensions());'`
