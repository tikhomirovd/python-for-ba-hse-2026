# Данные пилота (темы 07–08)

Синтетические таблицы для семинаров С7 и С8. Основная копия лежит в схеме `prime` учебного сервера. Здесь лежат те же таблицы в виде `csv.gz`, их снимок сделан 11.11.2026.

Если сервер не отвечает, в ячейке ноутбука поставьте `SERVER_IS_DOWN = True`, и таблицы скачаются отсюда.

| Файл | Строк | Колонки |
|---|---|---|
| `pilot_candidates.csv.gz` | 12 000 | `client_id`, `time_zone`, `acquisition_channel`, `kyc_level`, `age`, `tenure_days`, `members`, `purchases_prev2`, `spend_prev2`, `purchases_prev`, `spend_prev`, `sessions_prev2`, `sessions_prev` |
| `pilot_assignment.csv.gz` | 12 055 | `client_id`, `grp`, `assigned_at` |
| `pilot_outcomes.csv.gz` | 12 000 | `client_id`, `spend`, `purchases`, `churned`, `tickets`, `tariff_end`, `saw_offer` |
| `rollout_telecom.csv.gz` | 9 000 | колонки `pilot_candidates`, а также `treated`, `purchases`, `spend` |

В CSV даты приходят строками. Если нужны даты, преобразуйте их через `pd.to_datetime`.

## ДЗ-3

Снимок таблиц ДЗ-3 сделан 16.11.2026. В ноутбуке ДЗ-3 поставьте `SERVER_IS_DOWN = True` и впишите номер своего варианта в ячейку 1.2: свой вариант ноутбук выберет сам.

| Файл | Строк | Колонки |
|---|---|---|
| `hw3_offers.csv.gz` | 60 | `variant`, `offer`, `primary_metric` |
| `hw3_pilot.csv.gz` | 360 000 | `variant`, `client_id`, `grp`, `time_zone`, `acquisition_channel`, `kyc_level`, `age`, `tenure_days`, `members`, `purchases_prev2`, `spend_prev2`, `purchases_prev`, `spend_prev`, `sessions_prev2`, `sessions_prev`, `purchases`, `spend`, `churned`, `tickets` |

Файл `hw3_pilot.csv.gz` весит 17 МБ: скачивается заметно дольше, чем приходит выгрузка с сервера.
