from typing import Any

from foundation import ChannelDispatcher, AuthServiceProtocol
from user import UserManager, AuthUser

config: dict[str, Any] = {}
channelDispatcher = ChannelDispatcher()


# noinspection PyTypeChecker

async def onJsonMessage(json: dict):
    await channelDispatcher.onMessage(json)


def setupAuth(userManager: UserManager):
    channelDispatcher.authService = AuthService(userManager)


class AuthService(AuthServiceProtocol):
    def __init__(self, userManager):
        self.userManager = userManager

    async def authorize(self, token: str) -> AuthUser | None:
        return await super().authorize(token)

    async def onUnauthorized(self):
        return await super().onUnauthorized()
