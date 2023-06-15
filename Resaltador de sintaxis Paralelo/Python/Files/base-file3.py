def is_leap(year):
    return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)


def month_days(month, year):
    if month == 4 or month == 6 or month == 9 or month == 11:
        return 30
    elif month == 2:
        if is_leap(year):
            return 29
        else:
            return 28
    else:
        return 31


def next_day(day, month, year):
    if day == month_days(month, year):
        if month == 12:
            return [1, 1, year + 1]
        else:
            return [1, month + 1, year]
    else:
        return [day + 1, month, year]