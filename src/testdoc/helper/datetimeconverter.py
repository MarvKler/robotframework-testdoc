from datetime import datetime, timezone


class DateTimeConverter:
    def get_generated_datetime(self, dt_format: str = "%Y-%m-%d %H:%M:%S") -> str:
        return datetime.now(timezone.utc).strftime(dt_format)
