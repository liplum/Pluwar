from enum import Enum, auto


class Player:
    def __init__(self):
        pass


class RoomState(Enum):
    Waiting = auto()
    Battle = auto()
    End = auto()


class Room:
    """
    Before battle starts, room state is [Waiting] until both players are ready to start.
    """

    def __init__(self):
        self.state = RoomState.Waiting
        self.playerA: Player | None = None
        self.playerB: Player | None = None

