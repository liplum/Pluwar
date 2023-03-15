import asyncio

import fs
import logger
import server_auth
import server_game
import stroage

defaultConfig = {
    "auth": {
        "ip": "0.0.0.0",
        "port": 8081,
        "database": "runtime_data/auth_db.fs"
    },
    "game": {
        "ip": "0.0.0.0",
        "port": 8080,
        "database": "runtime_data/game_db.fs"
    },
    "loggingLevel": "verbose"
}


async def main():
    conf = await fs.readAsync(path="config.data.json", default=defaultConfig)
    logger.level = logger.LoggingLevel.byName(conf["loggingLevel"])
    authConnection = stroage.openConnection(conf["auth"]["database"])
    await server_auth.serve(authConnection, conf=conf["auth"])
    await server_game.serve(authConnection, conf=conf["game"])


if __name__ == '__main__':
    asyncio.run(main())
