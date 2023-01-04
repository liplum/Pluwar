from typing import Protocol, runtime_checkable

from user import AuthUser


@runtime_checkable
class PayloadConvertible(Protocol):
    def toPayload(self) -> dict:
        pass


@runtime_checkable
class Channel(Protocol):
    name: str

    async def onMessage(self, user: AuthUser, json: dict):
        pass


messageTemplate = {
    "channel": "channel's name",
    "token": "a unique authorized token with expiration time",
    "data": {
        "content": "The content of payload"
    }
}


@runtime_checkable
class AuthServiceProtocol(Protocol):
    async def authorize(self, token: str) -> AuthUser | None:
        pass

    async def onUnauthorized(self):
        pass


class ChannelDispatcher:
    def __init__(self):
        self.name2Channel: dict[str, Channel] = {}
        self.authService: AuthServiceProtocol | None = None

    def registerChannel(self, channel: Channel):
        self.name2Channel[channel.name] = channel

    async def onMessage(self, json: dict):
        if "token" in json:
            token = json["token"]
            authUser = await self.authService.authorize(token)
            if authUser is not None:
                channelName = json["channel"]
                if channelName in self.name2Channel:
                    channel = self.name2Channel[channelName]
                    data = json["data"]
                    await channel.onMessage(authUser, data)
        else:
            await self.authService.onUnauthorized()
