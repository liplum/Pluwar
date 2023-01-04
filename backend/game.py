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
    "playerAAccount": "PlayerA",
    "playerBAccount": "PlayerB",
    "isPlayerAReady": False,
    "isPlayerBReady": False,
}


class JoinRoomFailedReason(Enum):
    noSuchRoom = auto()
    roomIsFull = auto()


joinRoomFailedReplyTemplate = {
    "reason": JoinRoomFailedReason.noSuchRoom
}


async def onJoinRoom(ctx: ChannelContext, json: dict):
    account = ctx.user.account
    if "roomId" in json:
        # Specify the room ID
        room = roomManager.tryGetRoom(json["roomId"])
        if room is None:
            room = roomManager.newRoom()
            room.joinWith(account)
            await ctx.send(room.toPayload())
        else:
            if room.isInRoom(account):
                return
            elif room.isFull():
                await ctx.send({
                    "reason": JoinRoomFailedReason.roomIsFull
                }, status=ChannelStatus.failed)
            else:
                room.joinWith(account)
                await ctx.send(room.toPayload())
    else:
        # Randomize a room
        room = roomManager.newRoom()
        room.joinWith(account)
        await ctx.send(room.toPayload())


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
