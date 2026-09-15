# Ветка, коммит, pull request

Памятка по ежедневной работе в вашем репозитории `prime-monitor`: ветка под задачу, коммиты по ходу, push, pull request и сдача ссылкой в бота. Пример везде — [ДЗ-1](../задания/дз-1-окружение-и-репозиторий/README.md). Следующие задания сдаются так же; как называть их ветки, скажет текст задания. Декларация ИИ у каждой работы своя: у ДЗ-1 — `ДЕКЛАРАЦИЯ-ИИ.md`, дальше — её копия с названием работы, например `ДЕКЛАРАЦИЯ-ИИ-ДЗ-2.md`.

Что должно быть готово:

- SSH-ключ добавлен в GitHub — памятка [«Git и GitHub»](git-и-github.md), разделы 1–4;
- ваш репозиторий `prime-monitor` создан из шаблона кнопкой **Use this template** (не Fork) и склонирован к себе — [Git-практикум](../02-среда-git-python/семинар/С2-git-практикум.md), разделы 1–3;
- выполнены команды из шага 2 ДЗ-1: `uv sync`, `uv run nbstripout --install` и две настройки `git config`.

Все команды ниже набираются **в папке `prime-monitor`** и одинаково работают в Терминале macOS и в PowerShell.

---

## Зачем ветка и pull request

`main` — чистовик. Работа над задачей идёт в отдельной **ветке**, и пока она не закончена, `main` не меняется. **Pull request** — страница на GitHub с просьбой влить ветку в `main`: на ней видна каждая изменённая строка, и к любой строке можно оставить комментарий. Так устроена проверка кода в большинстве команд, и так же я проверяю домашние задания: вы присылаете ссылку на pull request, я читаю вкладку **Files changed** и пишу комментарии прямо там. Сливаете ветку в `main` вы сами — когда в боте появилась оценка.

Вся последовательность одним блоком — когда стартовый ноутбук уже скачан в `notebooks/hw1.ipynb` (шаг 4 ДЗ-1):

```
git switch main
git pull
git add notebooks/hw1.ipynb
git commit -m "Добавить стартовый ноутбук ДЗ-1"
git push
git switch -c feature/hw1
```

Дальше, после каждого законченного куска работы:

```
git add notebooks/hw1.ipynb
git commit -m "Решить задачи 1–3 и ответить на вопросы"
```

И в конце — `git push -u origin feature/hw1`, pull request кнопкой на GitHub и ссылка в `/submit`. Ниже то же самое по шагам, с тем, что должно получиться после каждого.

---

## 1. Начать с чистого `main`

```
git switch main
git pull
git status
```

Должно получиться:

```
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

Если стартовый ноутбук уже скачан, `git status` покажет его в разделе `Untracked files` — это нормально, следующий шаг как раз про него. Что-то другое — смотрите таблицу [в конце](#если-что-то-пошло-не-так).

## 2. Стартовый ноутбук — в `main`, до ветки

Как скачать стартер — шаг 4 ДЗ-1. Файл должен лежать в `notebooks/hw1.ipynb` и ещё не открываться.

```
git add notebooks/hw1.ipynb
git commit -m "Добавить стартовый ноутбук ДЗ-1"
git push
```

Проверка:

```
git log --oneline -3
```

```
4d8fec4 (HEAD -> main, origin/main, origin/HEAD) Добавить стартовый ноутбук ДЗ-1
8afb65c Initial commit
```

Номера коммитов у вас другие, а ниже могут идти коммиты из Git-практикума. Важно, что в верхней строке стартер и рядом с ним стоят и `main`, и `origin/main`: коммит есть и у вас, и на GitHub.

Почему именно в таком порядке: стартер лежит в `main`, работа — в ветке, поэтому во вкладке **Files changed** видно ровно то, что написали вы. Если завести ветку раньше, чем стартер попал в `main`, весь ноутбук окажется в pull request новым файлом, и ваши правки в нём не отличить от готового кода.

## 3. Ветка

```
git switch -c feature/hw1
```

```
Switched to a new branch 'feature/hw1'
```

`-c` создаёт ветку и сразу переключает на неё. Создаётся ветка один раз; если потом переключались в `main`, возвращайтесь без `-c`: `git switch feature/hw1`. Имена веток — только латиницей.

Проверка — `git status`, первая строка должна быть `On branch feature/hw1`.

## 4. Работа и коммиты по ходу

**Сначала сохраните ноутбук** — `Ctrl+S` (macOS: `⌘S`). Git видит только то, что записано на диск.

Посмотрите, что изменилось:

```
git status
```

```
On branch feature/hw1
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   notebooks/hw1.ipynb
```

Закоммитьте:

```
git add notebooks/hw1.ipynb
git commit -m "Решить задачи 1–3 и ответить на вопросы"
```

```
[feature/hw1 2aeaaa0] Решить задачи 1–3 и ответить на вопросы
 1 file changed, 1 insertion(+)
```

**В квадратных скобках — ветка, в которую лёг коммит.** Там должно быть `feature/hw1`. Если там `main` — смотрите строку «коммит ушёл в `main`» в таблице ниже.

Коммитьте после каждого законченного куска, а не одним коммитом в конце. В сообщении — что сделано, а не `update` или `fix`.

README и декларация — в ту же ветку:

```
git add -u
git commit -m "Заполнить README и декларацию"
```

`git add -u` берёт изменения во всех файлах, которые git уже отслеживает. Новых файлов он не добавляет, поэтому `.env` не тронет.

## 5. Push

Первый раз для этой ветки:

```
git push -u origin feature/hw1
```

Ответ GitHub (у вас вместо `ВАШ_ЛОГИН` будет ваш логин):

```
remote:
remote: Create a pull request for 'feature/hw1' on GitHub by visiting:
remote:      https://github.com/ВАШ_ЛОГИН/prime-monitor/pull/new/feature/hw1
remote:
To github.com:ВАШ_ЛОГИН/prime-monitor.git
 * [new branch]      feature/hw1 -> feature/hw1
branch 'feature/hw1' set up to track 'origin/feature/hw1'.
```

`-u` связывает вашу ветку с веткой на GitHub — об этом последняя строка. Поэтому все следующие разы достаточно просто `git push`.

Проверка — `git status`:

```
On branch feature/hw1
Your branch is up to date with 'origin/feature/hw1'.

nothing to commit, working tree clean
```

Если вместо этого `Your branch is ahead of 'origin/feature/hw1' by 1 commit.` — коммит есть у вас, но не на GitHub, и в pull request его не видно. Сделайте `git push`.

## 6. Pull request

Откройте ссылку `…/pull/new/feature/hw1` из ответа на push. **Это ещё не pull request, а форма для его создания.** Ссылку потеряли — наберите тот же адрес руками или откройте свой репозиторий на GitHub: вскоре после push над списком файлов появляется жёлтая плашка с кнопкой **Compare & pull request**, она ведёт на ту же форму.

На форме проверьте:

| Что | Как должно быть |
|---|---|
| ветки | сверху `main` ← `feature/hw1`: вливаем `feature/hw1` в `main` |
| репозиторий | ваш: адрес страницы начинается с `https://github.com/ВАШ_ЛОГИН/prime-monitor/`, а не с `tikhomirovd/prime-monitor-template` |
| изменения | ниже на той же странице — ваши коммиты и изменённые файлы |

Заголовок напишите понятный, например «ДЗ-1», описание — по желанию. Нажмите **Create pull request**.

Откроется страница с адресом вида

```
https://github.com/ВАШ_ЛОГИН/prime-monitor/pull/N
```

Это и есть pull request, а `N` — его номер. Если вы проходили Git-практикум, там уже был pull request № 1, и у ДЗ-1 номер будет 2 или больше.

**Merge не нажимайте.** Pull request остаётся открытым, пока в боте не появится оценка.

## 7. Доступ, если репозиторий приватный

Приватный репозиторий видят только те, кого вы добавили в коллабораторы. **Если меня там нет, ссылка откроется у меня как 404, и работа считается несданной.**

В своём репозитории: **Settings** → **Collaborators** → **Add people** → `tikhomirovd` → подтвердить добавление.

Приглашение принимаю я. Пока оно в статусе Pending, доступа у меня ещё нет. Висит дольше двух дней — напишите. Непринятое приглашение через семь дней сгорает — тогда пригласите заново.

Публичный репозиторий открывается у всех, для него этот шаг не нужен. Проверить можно в окне инкогнито: ссылка на pull request должна открыться без входа в GitHub. У приватного там будет 404, и это нормально — для него проверка одна: `tikhomirovd` в списке Collaborators.

## 8. Сдача

Боту курса — команда `/submit` и ссылка на pull request.

| Ссылка | Годится? |
|---|---|
| `https://github.com/ВАШ_ЛОГИН/prime-monitor/pull/2` | да |
| `https://github.com/ВАШ_ЛОГИН/prime-monitor/pull/new/feature/hw1` | нет: это форма, pull request ещё не создан |
| `https://github.com/ВАШ_ЛОГИН/prime-monitor` или `…/tree/feature/hw1` | нет: это репозиторий или ветка, а не pull request |

---

## Исправить после сдачи

Пока открыт приём, работу можно поправить: коммит в ту же ветку, `git push` и **снова** `/submit`. Новый pull request не нужен — новые коммиты появятся в открытом сами.

- **Проверяется версия на момент последней отправки в `/submit`.** Push без повторной отправки не учитывается.
- Если первая сдача была в срок, а новая пришла после дедлайна, штраф за просрочку посчитается по новой — бот предупредит перед тем, как принять.
- Мои комментарии — прямо в pull request, во вкладке **Files changed**.

## После оценки

1. На странице pull request — **Merge pull request**, затем **Confirm merge**.
2. У себя:

```
git switch main
git pull
```

`git switch main` может ответить `Your branch is up to date with 'origin/main'.` — он сравнивает с тем, что знал о GitHub при прошлой синхронизации, и про слияние ещё не знает. `git pull` нужен всё равно. Он ответит примерно так:

```
Updating 4d8fec4..302813a
Fast-forward
 README.md           | 1 +
 notebooks/hw1.ipynb | 1 +
 ДЕКЛАРАЦИЯ-ИИ.md    | 1 +
 3 files changed, 3 insertions(+)
```

Проверка — `git log --oneline -1`, в строке должно быть `Merge pull request #N from ВАШ_ЛОГИН/feature/hw1`.

Как вести ветку ДЗ-2, которое выдаётся раньше, чем придёт оценка за ДЗ-1, — будет сказано в тексте ДЗ-2.

---

## Проверьте себя за минуту

Четыре команды на ветке `feature/hw1` после push. Если всё как ниже — на GitHub лежит ровно то, что у вас.

**`git status`**

```
On branch feature/hw1
Your branch is up to date with 'origin/feature/hw1'.

nothing to commit, working tree clean
```

Три строки — три проверки: вы на нужной ветке; всё закоммиченное есть на GitHub; незакоммиченного нет.

**`git branch -vv`**

```
* feature/hw1 a7985da [origin/feature/hw1] Заполнить README и декларацию
  main        4d8fec4 [origin/main] Добавить стартовый ноутбук ДЗ-1
```

Звёздочка — текущая ветка. В квадратных скобках — ветка на GitHub, с которой связана ваша. `[origin/feature/hw1: ahead 1]` — один коммит не отправлен, нужен `git push`. Скобок у `feature/hw1` нет вовсе — ветку ни разу не отправляли с `-u`, вернитесь к шагу 5.

**`git log --oneline --graph --all -10`**

```
* a7985da (HEAD -> feature/hw1, origin/feature/hw1) Заполнить README и декларацию
* 2aeaaa0 Решить задачи 1–3 и ответить на вопросы
* 4d8fec4 (origin/main, origin/HEAD, main) Добавить стартовый ноутбук ДЗ-1
* 8afb65c Initial commit
```

Читается снизу вверх: коммит шаблона, стартер с метками `main` и `origin/main`, над ним ваши коммиты. `HEAD -> feature/hw1` и `origin/feature/hw1` должны стоять в одной строке; если `origin/feature/hw1` ниже — верхние коммиты не отправлены. Если проходили Git-практикум, ниже стартера будет развилка его веток — это нормально.

**`git remote -v`**

```
origin	git@github.com:ВАШ_ЛОГИН/prime-monitor.git (fetch)
origin	git@github.com:ВАШ_ЛОГИН/prime-monitor.git (push)
```

Адрес начинается с `git@github.com:`, в нём ваш логин и `prime-monitor`.

---

## Если что-то пошло не так

### В терминале

| Что написано | Что случилось | Что делать |
|---|---|---|
| `fatal: not a git repository` | вы не в папке проекта | перейдите в папку `prime-monitor` командой `cd` |
| `fatal: a branch named 'feature/hw1' already exists` | ветка уже есть | `git switch feature/hw1` |
| `fatal: The current branch feature/hw1 has no upstream branch.` | ветку ещё ни разу не отправляли, и git не знает, куда | `git push -u origin feature/hw1` |
| `nothing to commit, working tree clean`, хотя вы работали | ноутбук не сохранён на диск или всё уже закоммичено | сохраните ноутбук (`Ctrl+S`, macOS: `⌘S`) и повторите `git status`; что уже закоммичено — `git log --oneline -3` |
| `git status` показывал `modified: notebooks/hw1.ipynb`, а после `git add` — `nothing to commit` | в ноутбуке поменялись только выводы ячеек, а их срезает nbstripout | всё в порядке: выводы в git не попадают, коммитить нечего |
| `error: Your local changes to the following files would be overwritten by checkout` | вы переключаете ветку, а в файлах есть незакоммиченные правки | сначала закоммитьте их в текущую ветку (`git add`, `git commit`), потом `git switch` |
| в ответе на `git commit` стоит `[main …]` — коммит ушёл в `main` | забыли `git switch -c feature/hw1` | если стартер вы отправили на шаге 2, а после этого `git push` из `main` не делали: `git switch -c feature/hw1`, затем `git branch -f main origin/main`. Ветка заберёт ваши коммиты, `main` вернётся туда, где он на GitHub, файлы на диске не изменятся. Дальше — с шага 5. Если работа уже ушла в `main` на GitHub — не чините сами, напишите в чат курса |
| `Updates were rejected because the remote contains work…` | на GitHub есть коммиты, которых нет у вас, — обычно после правки файла в браузере | `git pull`, затем снова `git push`. README и декларацию дальше правьте у себя, а не на GitHub |
| после `git pull` открылся текст `Merge branch …` и строки `# Please enter a commit message to explain why this merge is necessary` | git слил изменения с GitHub и просит подтвердить сообщение коммита слияния в редакторе | менять ничего не нужно, закройте редактор с сохранением. Vim: `Esc`, затем `:wq` и `Enter`. nano: `Ctrl+X` |
| `Need to specify how to reconcile divergent branches` | не сделана настройка `pull.rebase false` из шага 2 ДЗ-1 | `git pull --no-rebase`, затем снова `git push` |
| `unresolved conflict` или `cannot switch branch while merging` | остался недоделанный конфликт из Git-практикума | `git merge --abort` |
| после `git log` не возвращается приглашение, внизу `:` или `(END)` | git открыл просмотрщик длинного вывода | нажмите `q` |
| `clean filter 'nbstripout' failed` при `git add` | папку проекта перенесли в другое место | `uv run nbstripout --install` |
| `pathspec 'notebooks/hw1.ipynb' did not match any files` | файл лёг не туда или называется иначе (`hw1 (1).ipynb`, `hw1.ipynb.txt`) | посмотрите `ls notebooks` (в PowerShell — `dir notebooks`) и переименуйте |
| `Username for 'https://github.com'` | репозиторий подключён по HTTPS, а не по SSH | `git remote set-url origin git@github.com:ВАШ_ЛОГИН/prime-monitor.git` — подробнее в [памятке по git](git-и-github.md#если-что-то-пошло-не-так) |
| `git@github.com: Permission denied (publickey)` | GitHub вас не узнал | [памятка по git](git-и-github.md#если-что-то-пошло-не-так), раздел «Если что-то пошло не так» |
| `ssh: connect to host github.com port 22: Operation timed out` | сеть режет 22-й порт | [памятка по git, раздел 5](git-и-github.md#5-если-не-пускает-порт-443) |
| `git remote -v` показывает `tikhomirovd/prime-monitor-template` | склонирован шаблон курса, а не ваш репозиторий; push в него не пройдёт | склонируйте свой `prime-monitor` в другую папку ([Git-практикум](../02-среда-git-python/семинар/С2-git-практикум.md), разделы 1–3 — если своего репозитория ещё нет, он там же и создаётся), повторите там шаг 2 ДЗ-1 и перенесите обычным копированием `.env` и файлы, которые правили |

### На GitHub и в боте

| Что видите | Что случилось | Что делать |
|---|---|---|
| отправили в `/submit` ссылку вида `…/pull/new/feature/hw1` | это ещё не pull request | откройте её, нажмите **Create pull request** и отправьте в `/submit` адрес открывшейся страницы |
| на форме pull request нет ваших изменений | на GitHub ветки `feature/hw1` и `main` одинаковые: коммиты не отправлены или ушли в `main` | [проверьте себя](#проверьте-себя-за-минуту) и найдите нужную строку в таблице выше |
| репозиторий приватный, а `tikhomirovd` нет в Collaborators | по вашей ссылке у меня 404 — работа считается несданной | [шаг 7](#7-доступ-если-репозиторий-приватный) |
| приглашение висит в статусе Pending дольше двух дней | я его ещё не принял | напишите мне; через семь дней оно сгорает — тогда пригласите заново |
| репозиторий сделан кнопкой **Fork**, а не **Use this template** | fork нельзя сделать приватным, и pull request уйдёт в шаблон курса | создайте на GitHub пустой репозиторий `prime-monitor` (без README и .gitignore), в папке проекта выполните `git remote set-url origin git@github.com:ВАШ_ЛОГИН/prime-monitor.git` и `git push -u origin main`; fork после этого удалите |
| нажали **Merge** по ошибке | pull request слит до оценки | если работа уже готова — пришлите в `/submit` ссылку на этот pull request. Если продолжаете работу — пушьте в ту же ветку, откройте новый pull request `feature/hw1` → `main` и пришлите его ссылку |

Остальные ошибки ДЗ-1 — не про git, а про ноутбук и базу — в [тексте задания](../задания/дз-1-окружение-и-репозиторий/README.md#если-что-то-не-работает).

---

## То же в VS Code

Правило курса то же, что в [памятке по VS Code](vscode.md): **делать — командами во встроенном терминале, смотреть — в панели Source Control.**

- Панель открывается `Ctrl+Shift+G` (macOS: `⌃⇧G`). Список **Changes** — то же, что `git status`; клик по файлу показывает, что изменилось, двумя колонками.
- Имя текущей ветки — внизу слева. Удобно глянуть перед коммитом, не на `main` ли вы.
- Историю веток картинкой, как `git log --graph`, рисует расширение Git Graph.

Подробнее — [VS Code, раздел 8](vscode.md#8-панель-git-что-вы-там-увидите).

---

Не получается дольше получаса — напишите в чат курса до дедлайна и приложите **полный текст ошибки** и вывод `git status`, а не скриншот. В начале семинара по теме 03 будет добор по git.
