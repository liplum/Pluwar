from enum import Enum, auto
import logger
from core import RoomManager, Room, RoomChatEntry
from foundation import ChannelContext, ChannelStatus
from user import AuthUser
from datetime import datetime


def registerChannels(register):
    register("joinRoom", onJoinRoom)
    register("createRoom", onCreateRoom)
    register("checkMyRoom", onCheckMyRoom)
    register("queryRoom", onQueryRoom)
    register("changeRoomPlayerStatus", onChangeRoomPlayerStatus)
    register("leaveRoom", onLeaveRoomPlayerStatus)
    register("chatInRoom", onChatInRoom)
    register("checkChatInRoom", onCheckChatInRoom)


roomManager = RoomManager()

joinRoomRequestTemplate = {
    "roomId": "str | Optional"
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


class RoomFailedReason(Enum):
    noSuchRoom = auto()
    roomIsFull = auto()
    alreadyInRoom = auto()
    noPermission = auto()


joinRoomFailedReplyTemplate = {
    "reason": RoomFailedReason.noSuchRoom
}


def _findBestMatchedRoom(user: AuthUser) -> Room | None:
    for candidate in roomManager.availableRooms():
        return candidate
    return None


async def onJoinRoom(ctx: ChannelContext, json: dict):
    user = ctx.user
    room = roomManager.tryGetRoomByAccount(user.account)
    if room is not None:
        if "roomId" in json:
            # Already joined room
            await ctx.send({
                "reason": RoomFailedReason.alreadyInRoom
            }, status=ChannelStatus.failed)
    else:
        # Not yet joined room
        if "roomId" in json:
            # Specify the room ID
            room = roomManager.tryGetRoomById(json["roomId"])
            if room is None:
                # No such room
                await ctx.send({
                    "reason": RoomFailedReason.noSuchRoom
                }, status=ChannelStatus.failed)
            else:
                if room.isInRoom(user):
                    # If already in room, reply the state
                    await ctx.send(room)
                elif room.isFull():
                    # Player cannot join a full room
                    await ctx.send({
                        "reason": RoomFailedReason.roomIsFull
                    }, status=ChannelStatus.failed)
                else:
                    # Join the room
                    room.joinWith(user)
                    await ctx.sendAll(room, room)
        else:
            # Create a room
            matched = _findBestMatchedRoom(user)
            if matched is None:
                room = roomManager.newRoom()
                room.joinWith(user)
                await ctx.send(room)
            else:
                matched.joinWith(user)
                await ctx.sendAll(matched, matched)


createRoomRequestTemplate = {
    "roomId": "RoomID"
}


async def onCreateRoom(ctx: ChannelContext, json: dict):
    logger.i("NoImpl [onCreateRoom]")


queryRoomRequestTemplate = {
    "roomId": "Room ID"
}


async def onQueryRoom(ctx: ChannelContext, json: dict):
    if "roomId" in json:
        roomId = json["roomId"]
        room = roomManager.tryGetRoomById(roomId)
        if room is None:
            await ctx.send({
                "reason": RoomFailedReason.noSuchRoom
            }, status=ChannelStatus.failed)
        else:
            if room.isInRoom(ctx.user):
                await ctx.send(room)
            else:
                await ctx.send({
                    "reason": RoomFailedReason.noPermission
                }, status=ChannelStatus.failed)


checkMyRoomReplyTemplate = {
    "roomId": "Optional[Room ID]"
}


async def onCheckMyRoom(ctx: ChannelContext, json: dict):
    account = ctx.user.account
    room = roomManager.tryGetRoomByAccount(account)
    if room is None:
        await ctx.send({})
    else:
        await ctx.send({
            "roomId": room.roomId
        })


changeRoomPlayerStatusRequestTemplate = {
    "status": "ready | unready",
}


def _parseChangRoomPlayerStatus(json: dict):
    if "status" in json:
        return json["status"] == "ready"
    return False


async def onChangeRoomPlayerStatus(ctx: ChannelContext, json: dict):
    room = roomManager.tryGetRoomByAccount(ctx.user.account)
    if room is None:
        return
    player = room.findPlayer(ctx.user.account)
    if player is not None:
        player.isReady = _parseChangRoomPlayerStatus(json)
        await ctx.sendAll(room, room)


leaveRoomPlayerRequestTemplate = {
}

leaveRoomPlayerReplyTemplate = {
}


async def onLeaveRoomPlayerStatus(ctx: ChannelContext, json: dict):
    user = ctx.user
    room = roomManager.tryGetRoomByAccount(user.account)
    if room is None:
        return
    if room.isInRoom(user):
        room.leaveRoom(user)
        await ctx.send({}, channel="leaveRoom")
        await ctx.sendAll(room, room, channel="changeRoomPlayerStatus")


chatInRoomRequestTemplate = {
    "content": "balabala..."
}
chatInRoomReplyTemplate = {
    "account": "PlayerA",
    "content": "balabala...",
    "ts": "utc datetime"
}


async def onChatInRoom(ctx: ChannelContext, json: dict):
    if "content" in json:
        content: str = json["content"]
        content = content.strip()
        if len(content) > 0:
            room = roomManager.tryGetRoomByAccount(ctx.user.account)
            if room is not None:
                chat = RoomChatEntry(ctx.user, content, datetime.utcnow())
                room.chats.append(chat)
                await ctx.sendAll(room, chat)


checkChatInRoomRequestTemplate = {
    "chats": [{
        "sender": "Account",
        "content": "balabala...",
        "ts": "utc time"
    }]
}


async def onCheckChatInRoom(ctx: ChannelContext, json: dict):
    room = roomManager.tryGetRoomByAccount(ctx.user.account)
    if room is not None:
        await ctx.send({
            "chats": room.chats
        })
