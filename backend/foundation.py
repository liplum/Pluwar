from typing import Protocol, runtime_checkable

from user import AuthUser
from websockets.legacy.server import WebSocketServerProtocol


@runtime_checkable
class PayloadConvertible(Protocol):
    def toPayload(self) -> dict:
        pass


class ChannelContext:
    def __init__(self, websocket: WebSocketServerProtocol, user: AuthUser):
        self.websocket = websocket
        self.user = user


@runtime_checkable
class Channel(Protocol):
    name: str

    async def onMessage(self, ctx: ChannelContext, json: dict):
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

    async def onUnauthorized(self, websocket: WebSocketServerProtocol, token: str | None):
        pass


class ChannelDispatcher:
    def __init__(self):
        self.name2Channel: dict[str, Channel] = {}
        self.authService: AuthServiceProtocol | None = None

    def registerChannel(self, channel: Channel):
        self.name2Channel[channel.name] = channel

    async def onMessage(self, websocket: WebSocketServerProtocol, json: dict):
        if "token" in json:
            token = json["token"]
            authUser = await self.authService.authorize(token)
            if authUser is None:
                await self.authService.onUnauthorized(websocket, token)
            else:
                channelName = json["channel"]
                if channelName in self.name2Channel:
                    channel = self.name2Channel[channelName]
                    data = json["data"]
                    await channel.onMessage(ChannelContext(websocket, authUser), data)
        else:
            await self.authService.onUnauthorized(websocket, token=None)
