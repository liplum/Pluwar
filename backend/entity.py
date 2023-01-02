from enum import Enum, auto

from foundation import PayloadConvertible


class Player:
    def __init__(self):
        self.id = ""


class RoomState(Enum):
    waiting = auto()
    battle = auto()
    end = auto()


class Room(PayloadConvertible):
    """
    Before battle starts, room state is [Waiting] until both players are ready to start.
    """

    def __init__(self):
        self.state = RoomState.waiting
        self.battleId = ""
        self.playerA: Player | None = None
        self.playerB: Player | None = None
        self.isPlayerAReady = False
        self.isPlayerBReady = False

    def toPayload(self) -> dict:
        return {
            "state": self.state.name,
            "battleId": self.battleId,
            "playerAId": self.playerA.id,
            "playerBId": self.playerB.id,
            "isPlayerAReady": self.isPlayerAReady,
            "isPlayerBReady": self.isPlayerBReady
        }
