from enum import Enum, auto

from core import RoomManager
from foundation import ChannelContext, ChannelStatus

roomManager = RoomManager()

joinRoomRequestTemplate = {
    "roomId": "str | None"
}

joinRoomOKReplyTemplate = {
    "roomId": "RoomID",
    "roomStatus": "waiting",
    "playerAId": "PlayerA",
    "playerBId": "PlayerB",
    "isPlayerAReady": False,
    "isPlayerBReady": False,
}


class JoinRoomFailedReason(Enum):
    noSuchRoom = auto()


joinRoomFailedReplyTemplate = {
    "reason": JoinRoomFailedReason.noSuchRoom,
}


async def onJoinRoom(ctx: ChannelContext, json: dict):
    if "roomId" in json:
        # Specify the room ID
        room = roomManager.tryGetRoom(json["roomId"])
        if room is None:
            await ctx.send({
                "reason": JoinRoomFailedReason.noSuchRoom
            }, status=ChannelStatus.failed)
        account = ctx.user.account
    else:
        pass


matchQueryRequestTemplate = {
    "roomId": "RoomID"
}
matchQueryReplyTemplate = {
    "roomId": "RoomID",
    "playerAId": "PlayerA",
    "playerBId": "PlayerB",
    "isPlayerAReady": False,
    "isPlayerBReady": False,
}


async def onQueryRoom(ctx: ChannelContext, json: dict):
    pass
