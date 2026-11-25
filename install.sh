#!/usr/bin/env bash
# Kimi Code + OpenCode — установка в одну команду
# Использование: curl -fsSL <raw-url-этого-файла> | bash
# или локально: bash install.sh
set -euo pipefail

say()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }

command -v curl >/dev/null || die "нужен curl"

# --- 1. Kimi Code CLI -------------------------------------------------------
if command -v kimi >/dev/null 2>&1; then
  say "Kimi Code CLI уже установлен: $(kimi --version 2>/dev/null || echo '?')"
else
  say "Ставлю Kimi Code CLI (официальный скрипт)..."
  curl -fsSL https://code.kimi.com/kimi-code/install.sh | bash
fi

# --- 2. OpenCode ------------------------------------------------------------
if command -v opencode >/dev/null 2>&1; then
  say "OpenCode уже установлен"
else
  say "Ставлю OpenCode (официальный скрипт)..."
  curl -fsSL https://opencode.ai/install | bash
  # скрипт кладёт бинарь в ~/.opencode/bin — подхватим на текущую сессию
  export PATH="$HOME/.opencode/bin:$PATH"
fi

# --- 3. Конфиг OpenCode под Kimi API ---------------------------------------
CONF_DIR="$HOME/.config/opencode"
CONF="$CONF_DIR/opencode.json"
mkdir -p "$CONF_DIR"
if [ -f "$CONF" ]; then
  cp "$CONF" "$CONF.bak.$(date +%Y%m%d%H%M%S)"
  warn "Существующий opencode.json сохранён рядом как .bak"
fi
say "Пишу конфиг OpenCode: $CONF"
cat > "$CONF" <<'JSON'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "kimi": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Kimi Code",
      "options": {
        "baseURL": "https://api.kimi.ai/coding/v1",
        "apiKey": "{env:KIMI_API_KEY}"
      },
      "models": {
        "k3-256k":    { "name": "Kimi K3 256K (экономичный, на каждый день)" },
        "k3":         { "name": "Kimi K3 1M (большие проекты)" },
        "k3.1-pro":   { "name": "Kimi K3.1 Pro" },
        "kimi-for-coding": { "name": "Kimi K2.8 Coding" }
      }
    }
  },
  "model": "kimi/k3-256k"
}
JSON

# --- 4. API-ключ ------------------------------------------------------------
if [ -z "${KIMI_API_KEY:-}" ]; then
  echo
  warn "Нужен API-ключ Kimi (свой, личный):"
  echo "    1) Оформи подписку Kimi (Plus и выше): https://www.kimi.com"
  echo "    2) Создай ключ в консоли Kimi Code:    https://www.kimi.com/code/console"
  echo "    Ключ показывается один раз — скопируй."
  echo
  if [ -t 0 ]; then
    read -r -p "Вставь ключ сейчас (или Enter — пропустить): " KEY
    if [ -n "${KEY:-}" ]; then
      RC="$HOME/.zshrc"; [ -n "${BASH_VERSION:-}" ] && [ -f "$HOME/.bashrc" ] && RC="$HOME/.bashrc"
      printf '\nexport KIMI_API_KEY="%s"\n' "$KEY" >> "$RC"
      export KIMI_API_KEY="$KEY"
      say "Ключ дописан в $RC"
    else
      warn "Пропустил. Потом добавь в ~/.zshrc:  export KIMI_API_KEY=\"твой_ключ\""
    fi
  else
    warn "Добавь в ~/.zshrc:  export KIMI_API_KEY=\"твой_ключ\""
  fi
fi

# --- 5. Финал ---------------------------------------------------------------
echo
say "Готово! Дальше:"
echo "  • Kimi Code CLI:  kimi        (первый запуск → команда /login → вход через браузер)"
echo "  • OpenCode:       opencode    (модель уже настроена: kimi/k3-256k)"
echo "  • Квота и лимиты: в Kimi CLI команда /usage"
echo "  • Совет: включи Extra Usage на странице подписки — тогда при исчерпании"
echo "    квоты списание бесшовно уйдёт на предоплаченный баланс без остановки."
echo
warn "Перезапусти терминал, чтобы подхватились PATH и KIMI_API_KEY."
