import datetime

class DateTimeConverter():
    def get_generated_datetime(self) -> str:
        return(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
