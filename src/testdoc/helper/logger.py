import click

class Logger():
    def LogKeyValue(self, key, value, color = "green"):
        click.echo(key, nl=False)
        click.echo(click.style(f"'{value}'", fg=color))
        
    def Log(self, msg, color = "white"):
        click.echo(click.style(msg, fg=color))