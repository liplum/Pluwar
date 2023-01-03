import asyncio
import json
import websockets
from websockets import WebSocketServerProtocol

import config
import pluwar

defaultConfig = {
    "ip": "0.0.0.0",
    "port": 8080,
    "database": "database.fs"
}


async def handle(websocket: WebSocketServerProtocol):
    async for message in websocket:
        try:
            datapack = json.loads(message)
            if isinstance(datapack, dict):
                await pluwar.ctx.onJsonMessage(datapack)
        except Exception as e:
            print(e)


async def serve():
    conf = await config.readAsync(path="config.game.json", default=defaultConfig)
    pluwar.ctx.config = conf
    async with websockets.serve(handle, conf["ip"], conf["port"]):
        await asyncio.Future()  # run forever


async def main():
    await serve()


asyncio.run(main())
