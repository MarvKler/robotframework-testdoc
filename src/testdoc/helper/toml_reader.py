from .cliargs import CommandLineArguments

import tomli
import os

class TOMLReader():

    ###
    ### Generic function to read toml files
    ###
    def _read_toml(self, file_path:str):
        try:
            with open(file_path, "rb") as f:
                config = tomli.load(f)
                return config
        except Exception as e:
            raise ImportError(f"Cannot read toml file in: {file_path} with error: \n{e}")
        
    
    ###
    ### Functions to handle TOML files with configuration for testdoc tool
    ###
    def load_from_config_file(self, file_path: str):
        config = TOMLReader()._read_toml(file_path)
        is_pyproject = self._is_pyproject_config(file_path)

        if is_pyproject:
            self._handle_pyproject_config(config)
        else:
            self._handle_custom_config(config)

    def _handle_pyproject_config(self, config: dict):
        testdoc_config = config.get("tool", {}).get("testdoc", {})
        self._apply_config_to_cliargs(testdoc_config)

    def _handle_custom_config(self, config: dict):
        self._apply_config_to_cliargs(config)

    def _apply_config_to_cliargs(self, config: dict):
        args_to_set = {}

        for key, value in config.items():
            if isinstance(value, tuple):
                value = list(value)
            args_to_set[key] = value

        CommandLineArguments().update_args_if_not_set(**args_to_set)

    def _is_pyproject_config(self, file_path) -> bool:
        return os.path.basename(file_path) == "pyproject.toml"