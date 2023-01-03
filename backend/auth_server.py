from aiohttp import web
import config

defaultConfig = {
    "ip": "0.0.0.0",
    "port": 8081,
    "database": "database.fs"
}


async def handle(request: web.Request):
    name = request.match_info.get('name', "Anonymous")
    text = "Hello, " + name
    return web.Response(text=text)


async def handleLogin(request):
    pass

async def handleRegister(request):
    pass


def main():
    conf = config.readSync(path="config.game.json", default=defaultConfig)
    app = web.Application()
    app.add_routes([
        web.get('/', handle),
        web.post('/login', handleLogin),
    ])
    web.run_app(app, host=conf["ip"], port=conf["port"])


if __name__ == '__main__':
    main()
