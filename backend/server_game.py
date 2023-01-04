import asyncio
import json
import traceback

import websockets
from websockets.legacy.server import WebSocketServerProtocol
from websockets.connection import State
import fs
import pluwar
import user

defaultConfig = {
    "ip": "0.0.0.0",
    "port": 8080,
    "authDatabase": "runtime_data/auth_db.fs",
    "database": "runtime_data/game_db.fs"
}


async def handle(websocket: WebSocketServerProtocol):
    async for message in websocket:
        if websocket.state == State.OPEN:
            print(f"Msg from {websocket.id}.")
        try:
            datapack = json.loads(message)
            if isinstance(datapack, dict):
                await pluwar.onJsonMessage(websocket, datapack)
        except Exception as e:
            traceback.print_exception(e)
    if websocket.state == State.CLOSED:
        print(f"{websocket.id} is closed.")


async def serve(authConnection, conf: dict | None = None):
    if conf is None:
        conf = await fs.readAsync(path="config.game.json", default=defaultConfig)
    pluwar.config = conf
    pluwar.setupAuth(user.getUserManagerService(authConnection))
    pluwar.setupGame()
    async with websockets.serve(handle, conf["ip"], conf["port"]) as web:
        await asyncio.Future()  # run forever


async def main():
    await serve()


if __name__ == '__main__':
    asyncio.run(main())
