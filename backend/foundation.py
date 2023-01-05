from enum import Enum, auto
from typing import Protocol, runtime_checkable, Callable, Awaitable

import logger
from encode import jsonEncode
from user import AuthUser
from websockets.legacy.server import WebSocketServerProtocol

requestTemplate = {
    "channel": "channel's name",
    "token": "a unique authorized token with expiration time",
    "data": {
        "content": "The content of payload"
    }
}


class ChannelStatus(Enum):
    ok = auto()
    failed = auto()


replyTemplate = {
    "channel": "channel's name",
    "status": ChannelStatus.ok,
    "data": {
        "content": "The content of payload"
    }
}


class ChannelContext:
    def __init__(self, websocket: WebSocketServerProtocol, user: AuthUser, channel: str):
        self.websocket = websocket
        self.user = user
        self.channel = channel

    async def send(self, json: dict, channel: str | None = None, status=ChannelStatus.ok):
        if channel is None:
            channel = self.channel
        reply = {
            "channel": channel,
            "status": status.name,
            "data": json
        }
        payload = jsonEncode(reply)
        await self.websocket.send(payload)


Channel = Callable[[ChannelContext, dict], Awaitable[None]]


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

    def registerChannel(self, name: str, channel: Channel):
        self.name2Channel[name] = channel

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
                    await channel(ChannelContext(websocket, authUser, channelName), data)
                else:
                    logger.i(f'Unknown channel "{channelName}"')
        else:
            await self.authService.onUnauthorized(websocket, token=None)
