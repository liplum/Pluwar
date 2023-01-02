from typing import Any

from foundation import ChannelDispatcher


class GlobalContext:
    def __init__(self):
        self.config: dict[str, Any] = {}
        self.channelDispatcher = ChannelDispatcher()

    async def onJsonMessage(self, json: dict):
        await self.channelDispatcher.onMessage(json)


ctx = GlobalContext()
