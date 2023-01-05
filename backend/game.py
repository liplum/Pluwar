from enum import Enum, auto

from core import RoomManager
from foundation import ChannelContext, ChannelStatus

roomManager = RoomManager()

joinRoomRequestTemplate = {
    "roomId": "str | None"
}

queryRoomReplyTemplate = {
    "roomId": "RoomID",
    "status": "waiting",
    "players": [{
        "account": "PlayerA",
        "isReady": False,
    }, {
        "account": "PlayerB",
        "isReady": False,
    }],
}


class JoinRoomFailedReason(Enum):
    noSuchRoom = auto()
    roomIsFull = auto()


joinRoomFailedReplyTemplate = {
    "reason": JoinRoomFailedReason.noSuchRoom
}

# TODO: Broadcast to all players in the same room.
async def onJoinRoom(ctx: ChannelContext, json: dict):
    account = ctx.user.account
    if "roomId" in json:
        # Specify the room ID
        room = roomManager.tryGetRoomById(json["roomId"])
        if room is None:
            room = roomManager.newRoom()
            room.joinWith(account)
            await ctx.send(room.toPayload(), channel="queryRoom")
        else:
            if room.isInRoom(account):
                return
            elif room.isFull():
                await ctx.send({
                    "reason": JoinRoomFailedReason.roomIsFull
                }, status=ChannelStatus.failed)
            else:
                room.joinWith(account)
                await ctx.send(room.toPayload(), channel="queryRoom")
    else:
        # Check if they have joined a room
        room = roomManager.tryGetRoomByAccount(account)
        if room is not None:
            await ctx.send(room.toPayload(), channel="queryRoom")
        else:
            # Create a room
            room = roomManager.newRoom()
            room.joinWith(account)
            await ctx.send(room.toPayload(), channel="queryRoom")


matchQueryRequestTemplate = {
    "roomId": "RoomID"
}


async def onQueryRoom(ctx: ChannelContext, json: dict):
    pass


changeRoomPlayerStatusRequestTemplate = {
    "roomId": "Room ID",
    "status": "ready | unready",
}


def _parseChangRoomPlayerStatus(json: dict):
    if "status" in json:
        return json["status"] == "ready"
    return False


async def changeRoomPlayerStatus(ctx: ChannelContext, json: dict):
    if "roomId" in json:
        roomId = json["roomId"]
        room = roomManager.tryGetRoomById(roomId)
        if room is not None:
            player = room.findPlayer(ctx.user.account)
            if player is not None:
                player.isReady = _parseChangRoomPlayerStatus(json)
                await ctx.send(room.toPayload(), channel="queryRoom")
            else:
                await ctx.send({}, status=ChannelStatus.failed)
        else:
            await ctx.send({}, status=ChannelStatus.failed)
    else:
        await ctx.send({}, status=ChannelStatus.failed)
