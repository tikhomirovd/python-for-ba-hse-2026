"""Выручка ПРАЙМ за день. Суммы после пересчёта в рубли даны до округления."""

from decimal import Decimal


def revenue(payments: list[tuple[str, Decimal]]) -> Decimal:
    """Рассчитать выручку по парам (статус платежа, сумма в рублях)."""
    return round(sum((amount for status, amount in payments if status == "success"), Decimal(0)),2)



if __name__ == "__main__":
    daily_payments = [
        ("success", Decimal("10.004")),
        ("success", Decimal("20.004")),
        ("failed", Decimal("50.000")),
    ]
    print(revenue(daily_payments))
