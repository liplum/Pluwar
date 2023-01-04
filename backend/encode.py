import datetime
import enum
import json
from typing import Any


class PluwarJsonEncoder(json.JSONEncoder):
    def __init__(self):
        super().__init__(ensure_ascii=False)

    def default(self, o: Any) -> Any:
        if isinstance(o, datetime.datetime):
            return o.isoformat()
        if isinstance(o, enum.Enum):
            return o.name
        return super().default(o)


_codec = PluwarJsonEncoder()


def jsonEncode(obj: dict) -> str:
    return _codec.encode(obj)
