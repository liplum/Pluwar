from typing import Protocol, runtime_checkable


@runtime_checkable
class PayloadConvertible(Protocol):
    def toPayload(self) -> dict:
        pass
