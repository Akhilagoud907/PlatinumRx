def convert_minutes(minutes):
    # Handle invalid input
    if not isinstance(minutes, int) or minutes < 0:
        return "Invalid input"

    hours = minutes // 60
    remaining = minutes % 60

    # Case: only minutes
    if hours == 0:
        return f"{remaining} minute" if remaining == 1 else f"{remaining} minutes"

    # Case: only hours
    if remaining == 0:
        return f"{hours} hr" if hours == 1 else f"{hours} hrs"

    # Case: both hours and minutes
    hour_part = f"{hours} hr" if hours == 1 else f"{hours} hrs"
    minute_part = f"{remaining} minute" if remaining == 1 else f"{remaining} minutes"

    return f"{hour_part} {minute_part}"


# Test cases
print(convert_minutes(130))   # 2 hrs 10 minutes
print(convert_minutes(110))   # 1 hr 50 minutes
print(convert_minutes(60))    # 1 hr
print(convert_minutes(1))     # 1 minute
print(convert_minutes(0))     # 0 minutes
print(convert_minutes(-5))    # Invalid input
