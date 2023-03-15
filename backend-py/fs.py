import os.path
import aiofiles
import json


async def readAsync(path: str, default: dict) -> dict:
    if os.path.isfile(path):
        async with aiofiles.open(path, mode='r') as f:
            content = await f.read()
            return json.loads(content)
    else:
        return default


def readSync(path: str, default: dict) -> dict:
    if os.path.isfile(path):
        with open(path, mode='r') as f:
            content = f.read()
            return json.loads(content)
    else:
        return default
