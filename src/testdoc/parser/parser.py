from robot.model.metadata import Metadata
import re

class Parser:

    def get_formatted_docs(
            self,
            doc_string: str | None,
        ):
        if doc_string and doc_string != "":
            return re.split(r'(?:\\n|\r?\n)', doc_string.strip())
        return None
    
    def get_formatted_metadata(self, metadata_object: Metadata):
        if metadata_object:
            return [f"{k}" for k, v in metadata_object.items()]
        return None
