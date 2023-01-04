import asyncio
import json
import websockets
from websockets import WebSocketServerProtocol

import fs
import pluwar
import stroage
import user

defaultConfig = {
    "ip": "0.0.0.0",
    "port": 8080,
    "authDatabase": "runtime_data/auth_db.fs",
    "database": "runtime_data/game_db.fs"
}


async def handle(websocket: WebSocketServerProtocol):
    async for message in websocket:
        try:
            datapack = json.loads(message)
            if isinstance(datapack, dict):
                await pluwar.onJsonMessage(datapack)
        except Exception as e:
            print(e)


async def serve():
    conf = await fs.readAsync(path="config.data.json", default=defaultConfig)
    pluwar.config = conf
    authConnection = stroage.openConnection(conf["authDatabase"])
    pluwar.setupAuth(user.getUserManagerService(authConnection))
    async with websockets.serve(handle, conf["ip"], conf["port"]):
        await asyncio.Future()  # run forever


async def main():
    await serve()


asyncio.run(main())
