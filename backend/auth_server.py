from aiohttp import web
import config

defaultConfig = {
    "ip": "0.0.0.0",
    "port": 8081,
    "database": "database.fs"
}


async def handle(request):
    name = request.match_info.get('name', "Anonymous")
    text = "Hello, " + name
    return web.Response(text=text)


def main():
    conf = config.readSync(path="config.game.json", default=defaultConfig)
    app = web.Application()
    app.add_routes([
        web.get('/', handle),
        web.get('/{name}', handle),
    ])
    web.run_app(app, host=conf["ip"], port=conf["port"])


if __name__ == '__main__':
    main()
