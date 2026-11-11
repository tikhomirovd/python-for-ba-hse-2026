#!/usr/bin/env bash
# Поднять окружение пилота (HypEx 1.0.7) для тем 07–08 и ДЗ-3.
# macOS / Linux. На Windows запускайте setup-pilot.ps1.
#
# Положите папку pilot/ в корень своего prime-monitor и из любой папки:
#
#     bash pilot/setup-pilot.sh
#
# Скрипт ставит пакеты по uv.lock и проверяет, что ноутбуки семинара
# смогут работать: найден src/prime вашего репозитория и есть доступ к базе.
set -euo pipefail

PILOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$PILOT_DIR")"

if ! command -v uv >/dev/null 2>&1; then
    echo "Не найден uv. Сначала поставьте его:"
    echo "  curl -LsSf https://astral.sh/uv/install.sh | sh"
    echo "и откройте новое окно терминала."
    exit 1
fi

echo "== uv $(uv --version | awk '{print $2}') · ставлю окружение из $PILOT_DIR"
uv sync --project "$PILOT_DIR"

echo "== Проверяю версии пакетов"
uv run --project "$PILOT_DIR" python - <<'PY'
import hypex, pandas, numpy, scipy
assert hypex.__version__ == "1.0.7", f"HypEx {hypex.__version__}, а нужен 1.0.7"
assert pandas.__version__ == "2.2.3", f"pandas {pandas.__version__}, а нужен 2.2.3"
print(f"OK: HypEx {hypex.__version__} · pandas {pandas.__version__} · numpy {numpy.__version__} · scipy {scipy.__version__}")
PY

echo "== Проверяю репозиторий и базу (как первая ячейка ноутбука)"
cd "$ROOT"
uv run --project "$PILOT_DIR" python - <<'PY'
import os, sys
from pathlib import Path

root = Path.cwd()

# Ноутбуки ищут src/prime вверх от папки запуска — повторяем их проверку.
if not (root / "src" / "prime").is_dir():
    sys.exit("НЕТ src/prime рядом с pilot/. Положите папку pilot/ в корень prime-monitor.")
sys.path.insert(0, str(root / "src"))

# prime.config.get_engine появился в репозитории на теме 03.
try:
    from prime.config import get_engine
except Exception as e:
    sys.exit(f"src/prime/config.py с get_engine не импортируется: {e}\n"
             "Восстановите файл по семинару С3, раздел про подключение.")

# src/prime/pilot.py создаётся на самом семинаре 7 — заранее его не ждём.
if not (root / "src" / "prime" / "pilot.py").is_file():
    print("примечание: src/prime/pilot.py появится на семинаре 7 — это нормально")

if not (root / ".env").is_file() and "PRIME_DSN" not in os.environ:
    sys.exit("Нет .env с PRIME_DSN в корне prime-monitor. Строку выдаёт бот курса по команде /db.")

try:
    with get_engine().connect() as conn:
        who = conn.exec_driver_sql("select current_user").scalar()
    print(f"OK: база отвечает, подключились как {who}")
except Exception as e:
    print(f"ВНИМАНИЕ: база не отвечает ({type(e).__name__}). На семинаре будет режим SERVER_IS_DOWN,")
    print("но лучше проверить сеть/VPN и строку PRIME_DSN в .env заранее.")
PY

echo
echo "Готово. Запуск JupyterLab — из корня prime-monitor:"
echo "  uv run --project pilot jupyter lab"
