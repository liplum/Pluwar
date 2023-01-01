import asyncio
import websockets
from websockets import WebSocketServerProtocol


async def handle(websocket: WebSocketServerProtocol):
    async for message in websocket:
        print(message)


async def main():
    async with websockets.serve(handle, "localhost", 8765):
        await asyncio.Future()  # run forever


asyncio.run(main())
