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

Таблиц ДЗ-3 (`hw3_*`) здесь нет: они есть только на сервере.
