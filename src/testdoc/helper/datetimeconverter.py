from datetime import datetime, timezone


class DateTimeConverter:
    def get_generated_datetime(self) -> str:
        return datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
