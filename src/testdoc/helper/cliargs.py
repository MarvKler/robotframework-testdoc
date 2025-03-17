class CommandLineArguments:
    _instance = None  # Singleton-Instanz

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(CommandLineArguments, cls).__new__(cls)
            cls._instance.suite_file = None
            cls._instance.output_file = None
            cls._instance.config_file = None
            cls._instance.verbose_mode = None
        return cls._instance

    def set_suite_file(self, path: str):
        self.suite_file = path
    
    def get_suite_file(self) -> str:
        return self.suite_file
    
    def set_output_file(self, path: str):
        self.output_file = path

    def get_output_file(self) -> str:
        return self.output_file
    
    def set_config_file(self, path: str):
        self.config_file = path

    def get_config_file(self) -> str:
        return self.config_file
    
    def set_verbose_mode(self, state: bool):
        self.verbose_mode = state

    def get_verbose_mode(self) -> bool:
        return self.verbose_mode
