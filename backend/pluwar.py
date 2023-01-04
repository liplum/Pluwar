from datetime import datetime
from typing import Any

from foundation import ChannelDispatcher, AuthServiceProtocol
from user import UserManager, AuthUser
from websockets.legacy.server import WebSocketServerProtocol

config: dict[str, Any] = {}
channelDispatcher = ChannelDispatcher()


async def onJsonMessage(websocket: WebSocketServerProtocol, json: dict):
    await channelDispatcher.onMessage(websocket, json)


def setupAuth(userManager: UserManager):
    channelDispatcher.authService = AuthService(userManager)


def setupGame():
    import game
    channelDispatcher.registerChannel("joinRoom", game.onJoinRoom)
    channelDispatcher.registerChannel("queryRoom", game.onQueryRoom)


class AuthService(AuthServiceProtocol):
    def __init__(self, userManager: UserManager):
        self.userManager = userManager

    async def authorize(self, token: str) -> AuthUser | None:
        user = self.userManager.trtGetAuthUserByToken(token)
        if user is not None:
            now = datetime.utcnow()
            if now > user.expired:
                self.userManager.unauthorize(user)
                return None
            else:
                return user
        else:
            return None

    async def onUnauthorized(self, websocket: WebSocketServerProtocol, token: str | None):
        await websocket.close()
