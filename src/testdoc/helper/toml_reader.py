import tomli

class TOMLReader():

    def _read_toml(self, file_path:str):
        try:
            with open(file_path, "rb") as f:
                config = tomli.load(f)
                return config
        except Exception as e:
            raise ImportError(f"Cannot read toml file in: {file_path} with error: \n{e}")