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


class AuthService(AuthServiceProtocol):
    def __init__(self, userManager: UserManager):
        self.userManager = userManager

    async def authorize(self, token: str) -> AuthUser | None:
        user = self.userManager.trtGetAuthUserByToken(token)
        now = datetime.now()
        if now > user.expired:
            self.userManager.unauthorize(user)
            return None
        else:
            return user

    async def onUnauthorized(self, websocket: WebSocketServerProtocol, token: str | None):
        return
