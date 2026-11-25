# Kimi Code + OpenCode — установка в одну команду

Связка из двух терминальных AI-агентов на моделях Kimi (Moonshot AI):
**Kimi Code CLI** (официальный агент) и **OpenCode** (open-source агент),
оба работают через одну подписку Kimi. Лимиты — общая квота подписки,
при её исчерпании можно включить Extra Usage (предоплата, не сгорает)
и работать без остановок.

## Установка

```bash
curl -fsSL https://raw.githubusercontent.com/artkuri/kimi-opencode-setup/main/install.sh | bash
```

Скрипт сделает всё сам:

1. Поставит Kimi Code CLI (официальный установщик)
2. Поставит OpenCode (официальный установщик)
3. Напишет конфиг OpenCode с провайдером Kimi (`~/.config/opencode/opencode.json`)
4. Спросит API-ключ и пропишет его в `~/.zshrc`

macOS и Linux. На Windows — ручная установка по [докам Kimi Code](https://www.kimi.com/code/docs/en/).

## Что нужно до/после

1. **Подписка Kimi** — тариф Plus или выше: https://www.kimi.com
2. **API-ключ** — создать в консоли: https://www.kimi.com/code/console
   (показывается один раз, ключ личный, никому не передавать)
3. Перезапустить терминал

## Запуск

```bash
cd твой-проект
kimi        # первый раз: команда /login → вход через браузер
opencode    # модель уже настроена: kimi/k3-256k
```

## Экономия квоты

- На каждый день — `k3-256k` (стоит по умолчанию). Модель `k3` (1M контекст)
  жрёт квоту вдвое быстрее, highspeed-версии — тоже ~x2.
- Проверка остатка: команда `/usage` в Kimi CLI.
- Включи **Extra Usage** на странице подписки: когда квота кончится,
  списание бесшовно перейдёт на баланс, задачи не остановятся.
  Баланс не сгорает. Поставь месячный лимит трат.

## Полезное

- Обновление Kimi CLI: `kimi upgrade`
- Обновление OpenCode: `opencode upgrade`
- Доки Kimi Code: https://www.kimi.com/code/docs/en/
- Доки OpenCode: https://opencode.ai/docs/
