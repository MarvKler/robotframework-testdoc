from datetime import datetime, timezone


class DateTimeConverter:
    def get_generated_datetime(self, format: str = "%Y-%m-%d %H:%M:%S") -> str:
        return datetime.now(timezone.utc).strftime(format)
