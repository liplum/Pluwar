from typing import Protocol, runtime_checkable


@runtime_checkable
class PayloadConvertible(Protocol):
    def toPayload(self) -> dict:
        pass


@runtime_checkable
class Channel(Protocol):
    name: str

    async def onMessage(self, json: dict):
        pass

@runtime_checkable
class DispatcherMiddleware(Protocol):
    def onPreMessage(self, json: dict) -> bool:
        """
        :return: whether to keep the message
        """
        pass

    def onPostMessage(self, json: dict):
        pass


messageTemplate = {
    "channel": "channel's name",
    "token": "a unique authorized token with expiration time",
    "data": {
        "content": "The content of payload"
    }
}


class ChannelDispatcher:
    def __init__(self):
        self.name2Channel = {}
        self.middlewares: list[DispatcherMiddleware] = []

    def registerChannel(self, channel: Channel):
        self.name2Channel[channel.name] = channel

    def addMiddleware(self, middleware: DispatcherMiddleware):
        self.middlewares.append(middleware)

    async def onMessage(self, json: dict):
        for middleware in self.middlewares:
            kept = middleware.onPreMessage(json)
            if not kept:
                return
        channelName = json["channel"]
        if channelName in self.name2Channel:
            channel = self.name2Channel[channelName]
            data = json["data"]
            channel.onMessage(data)
        for middleware in self.middlewares:
            middleware.onPostMessage(json)
