# Окружение для тем 07–08 и ДЗ-3: установка и проверка

Отдельное окружение, потому что HypEx 1.0.7 работает только с pandas 2.2 и numpy 1.26,
а в `prime-monitor` — pandas 3. Ставится один раз, до первого семинара.

## Установка

**1.** Положите папку `pilot/` в **корень** своего `prime-monitor`, рядом с `src/` и `notebooks/`.

**2.** Из любой папки запустите скрипт — он поставит пакеты и проверит всё сам:

```bash
bash pilot/setup-pilot.sh                                        # macOS / Linux / WSL
powershell -ExecutionPolicy Bypass -File pilot\setup-pilot.ps1   # Windows
```

Без скрипта, вручную, из корня `prime-monitor`:

```bash
uv sync --project pilot
uv run --project pilot python -c "import hypex, pandas; print(hypex.__version__, pandas.__version__)"
```

**3.** Ожидаемый итог — все четыре строки зелёные:

```
OK: HypEx 1.0.7 · pandas 2.2.3 · numpy 1.26.4 · scipy 1.13.1
примечание: src/prime/pilot.py появится на семинаре 7 — это нормально
OK: база отвечает, подключились как <ваш логин>
```

Строки `примечание` может не быть, если `pilot.py` уже есть. Остальное обязано быть.

## Запуск на семинарах

Только из корня `prime-monitor`:

```bash
uv run --project pilot jupyter lab
```

В VS Code: Select Kernel → `pilot/.venv`.

## Если не завелось

| Что видите | Что делать |
|---|---|
| `НЕТ src/prime рядом с pilot/` | папка `pilot/` не в корне `prime-monitor` — переложите |
| `Project directory pilot does not exist` | вы не в корне `prime-monitor` — сначала `cd` туда |
| `Нет .env с PRIME_DSN` / `KeyError: 'PRIME_DSN'` | строку выдаёт бот курса (`/db`); положите её в `.env` в корне `prime-monitor` |
| `src/prime/config.py с get_engine не импортируется` | файл утерян — восстановите по семинару С3 |
| `No solution found when resolving dependencies` | `uv self update` и повторить |
| `ВНИМАНИЕ: база не отвечает` | проверьте сеть/VPN; если адрес менялся — см. ниже |
| JupyterLab пишет кучу ошибок про `xdg-open` (WSL) | безвредно: откройте в браузере Windows ссылку `http://localhost:8888/lab?token=…` из вывода, или запускайте `jupyter lab --no-browser` |

## Если у сервера сменился адрес

Строка подключения живёт только в вашем `.env` — окружение пересоздавать **не нужно**.

**1.** Откройте `.env` в корне `prime-monitor`, найдите строку `PRIME_DSN=…` и замените старый адрес на новый. Меняется только хост (и порт, если сказано):

```
# было
PRIME_DSN=postgresql+psycopg://ЛОГИН:ПАРОЛЬ@2.56.240.205:5432/prime?sslmode=require
# стало
PRIME_DSN=postgresql+psycopg://ЛОГИН:ПАРОЛЬ@62.83.95.62:5432/prime?sslmode=require
```

**2.** Проверьте — из корня `prime-monitor`:

```bash
uv run --project pilot python -c "import sys; sys.path.insert(0, 'src'); from prime.config import get_engine; print(get_engine().connect().exec_driver_sql('select current_user').scalar())"
```

Напечатало ваш логин — адрес обновлён. Нет — попробуйте порт `443` вместо `5432`: это второй вход того же сервера.

То же самое в основном окружении — `uv run python -c …`, `.env` общий.
