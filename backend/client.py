import asyncio
import websockets
from aioconsole import ainput


async def hello():
    async with websockets.connect("ws://localhost:8765") as websocket:
        while True:
            msg = await ainput(">>")
            await websocket.send(msg)


asyncio.run(hello())
