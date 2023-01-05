import datetime
import enum
import json
from typing import Protocol, runtime_checkable, Any


@runtime_checkable
class PayloadConvertible(Protocol):
    def toPayload(self) -> dict:
        pass


class PluwarJsonEncoder(json.JSONEncoder):
    def __init__(self):
        super().__init__(ensure_ascii=False)

    def default(self, o: Any) -> Any:
        if isinstance(o, datetime.datetime):
            return o.isoformat()
        if isinstance(o, enum.Enum):
            return o.name
        if isinstance(o, PayloadConvertible):
            return o.toPayload()
        return super().default(o)


_codec = PluwarJsonEncoder()


def jsonEncode(obj: dict) -> str:
    return _codec.encode(obj)
