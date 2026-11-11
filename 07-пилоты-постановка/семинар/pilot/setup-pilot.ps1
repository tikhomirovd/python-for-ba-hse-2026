# Поднять окружение пилота (HypEx 1.0.7) для тем 07–08 и ДЗ-3.
# Windows. На macOS / Linux запускайте setup-pilot.sh.
#
# Положите папку pilot\ в корень своего prime-monitor, затем в PowerShell:
#
#     powershell -ExecutionPolicy Bypass -File pilot\setup-pilot.ps1
#
# Скрипт ставит пакеты по uv.lock и проверяет, что ноутбуки семинара
# смогут работать: найден src\prime вашего репозитория и есть доступ к базе.
$ErrorActionPreference = "Stop"
$PilotDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root = Split-Path -Parent $PilotDir

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "Не найден uv. Сначала поставьте его:"
    Write-Host '  powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"'
    Write-Host "и откройте новое окно PowerShell."
    exit 1
}

Write-Host "== ставлю окружение из $PilotDir"
uv sync --project $PilotDir
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "== Проверяю версии пакетов"
uv run --project $PilotDir python -c "import hypex, pandas, numpy, scipy; assert hypex.__version__ == '1.0.7', f'HypEx {hypex.__version__}, а нужен 1.0.7'; assert pandas.__version__ == '2.2.3', f'pandas {pandas.__version__}, а нужен 2.2.3'; print(f'OK: HypEx {hypex.__version__} · pandas {pandas.__version__} · numpy {numpy.__version__} · scipy {scipy.__version__}')"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "== Проверяю репозиторий и базу (как первая ячейка ноутбука)"
$Check = @'
import os, sys
from pathlib import Path

root = Path.cwd()

if not (root / "src" / "prime").is_dir():
    sys.exit("НЕТ src/prime рядом с pilot/. Положите папку pilot/ в корень prime-monitor.")
sys.path.insert(0, str(root / "src"))

try:
    from prime.config import get_engine
except Exception as e:
    sys.exit(f"src/prime/config.py с get_engine не импортируется: {e}\n"
             "Восстановите файл по семинару С3, раздел про подключение.")

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
'@
$CheckFile = Join-Path $env:TEMP "pilot_check.py"
Set-Content -Path $CheckFile -Value $Check -Encoding UTF8
Push-Location $Root
try {
    uv run --project $PilotDir python $CheckFile
} finally {
    Pop-Location
    Remove-Item $CheckFile -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Готово. Запуск JupyterLab — из корня prime-monitor:"
Write-Host "  uv run --project pilot jupyter lab"
Write-Host "В VS Code: Select Kernel -> pilot\.venv"
