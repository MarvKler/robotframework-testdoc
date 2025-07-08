class CommandLineArguments:
    _instance = None
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._args = {}
        return cls._instance

    def update_args_if_not_set(self, **kwargs):
        for key, value in kwargs.items():
            if key not in self._args:
                self._args[key] = value
    
    def set_args(self, **kwargs):
        self._args = kwargs

    def __getattr__(self, name):
        if name in self._args:
            return self._args[name]
        raise AttributeError(f"'CommandLineArguments' object has no attribute '{name}'")
    
    @property
    def title(self):
        return self._args.get("title", "Robot Framework - Test Documentation")
    
    @property
    def name(self):
        return self._args.get("name", None)
    
    @property
    def doc(self):
        return self._args.get("doc", None)
    
    @property
    def metadata(self):
        return self._args.get("metadata", None)
    
    @property
    def sourceprefix(self):
        return self._args.get("sourceprefix", None)
    
    @property
    def include(self):
        return self._args.get("include", [])
    
    @property
    def exclude(self):
        return self._args.get("exclude", [])
    
    @property
    def hide_tags(self):
        return self._args.get("hide_tags", False)
    
    @property
    def hide_test_doc(self):
        return self._args.get("hide_test_doc", False)
    
    @property
    def hide_suite_doc(self):
        return self._args.get("hide_suite_doc", False)
    
    @property
    def hide_source(self):
        return self._args.get("hide_source", False)
    
    @property
    def hide_keywords(self):
        return self._args.get("hide_keywords", False)
    
    @property
    def config_file(self):
        return self._args.get("config_file", None)
    
    @property
    def verbose_mode(self):
        return self._args.get("verbose_mode", False)
    
    @property
    def suite_file(self):
        return self._args.get("suite_file", None)
    
    @property
    def style(self):
        return self._args.get("style", None)
    
    @property
    def html_template(self):
        return self._args.get("html_template", "v2")
    
    @property
    def output_file(self):
        return self._args.get("output_file", None)
    
    @property
    def colors(self):
        return self._args.get("colors", None)
    
    @property
    def all_as_dict(self):
        return self._args