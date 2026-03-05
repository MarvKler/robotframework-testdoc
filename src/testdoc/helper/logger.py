import click


class Logger:
    def log_key_value(self, key, value, color="green"):
        click.echo(key, nl=False)
        click.echo(click.style(f"'{value}'", fg=color))

    def log(self, msg, color="white"):
        click.echo(click.style(msg, fg=color))
