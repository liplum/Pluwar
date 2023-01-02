import asyncio
import json
import os.path
import aiofiles
import websockets
from websockets import WebSocketServerProtocol

defaultConfig = {
    "ip": "localhost",
    "port": 8080,
    "database": "database.fs"
}


async def handle(websocket: WebSocketServerProtocol):
    async for message in websocket:
        print(message)


async def readConfig() -> dict:
    if os.path.isfile("config.json"):
        async with aiofiles.open('config.json', mode='r') as f:
            content = await f.read()
            return json.loads(content)
    else:
        return defaultConfig


async def main():
    config = await readConfig()
    async with websockets.serve(handle, "localhost", 8765):
        await asyncio.Future()  # run forever


asyncio.run(main())
