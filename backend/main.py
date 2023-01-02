import asyncio
import json
import os.path
import aiofiles
import websockets
from websockets import WebSocketServerProtocol
import pluwar

defaultConfig = {
    "ip": "localhost",
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


async def readConfig() -> dict:
    if os.path.isfile("config.json"):
        async with aiofiles.open('config.json', mode='r') as f:
            content = await f.read()
            return json.loads(content)
    else:
        return defaultConfig


async def serve():
    config = await readConfig()
    pluwar.ctx.config = config
    async with websockets.serve(handle, config["ip"], config["port"]):
        await asyncio.Future()  # run forever


async def eventLoop():
    pass


asyncio.run(serve())
