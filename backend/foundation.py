from typing import Protocol, runtime_checkable


@runtime_checkable
class PayloadConvertible(Protocol):
    def toPayload(self) -> dict:
        pass


@runtime_checkable
class Channel(Protocol):
    name: str

    async def onMessage(self, json):
        pass


class ChannelDispatcher:
    def __init__(self):
        self.name2Channel = {}

    def registerChannel(self, channel: Channel):
        self.name2Channel[channel.name] = channel

    async def onMessage(self, json):
        channelName = json["channel"]
        if channelName in self.name2Channel:
            channel = self.name2Channel[channelName]
            data = json["data"]
            channel.onMessage(data)
