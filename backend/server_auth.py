import json

import transaction
from aiohttp import web
import config
import re
import stroage

from user import User, UserManager

userManager: UserManager
defaultConfig = {
    "ip": "0.0.0.0",
    "port": 8081,
    "database": "runtime_data/auth_db.fs"
}


async def handle(request: web.Request):
    return web.Response(text="Pluwar")


async def handleLogin(request: web.Request):
    payload = await request.json()
    account = payload["account"]
    password = payload["password"]
    usr = userManager.trtGetUserByAccount(account)
    if usr is None:
        reply = {
            "state": "accountOrPasswordIncorrect"
        }
    else:
        if usr.password == password:
            reply = {
                "state": "ok",
                "snowflake": "111111"
            }
        else:
            reply = {
                "state": "accountOrPasswordIncorrect"
            }
    reply = json.dumps(reply)
    return web.Response(text=reply)


# at least 1 digit, 1 lowercase letter
# at least 8 characters
pwdRegex = re.compile(r"^(?=.*?[a-z])(?=.*?[0-9]).{8,}$")


async def handleRegister(request: web.Request):
    payload = await request.json()
    account = payload["account"]
    password = payload["password"]
    if pwdRegex.match(password):
        if userManager.hasUser(account):
            reply = {
                "state": "accountOccupied"
            }
        else:
            userManager.addUser(User(account, password))
            reply = {
                "state": "done"
            }
    else:
        reply = {
            "state": "passwordTooWeek"
        }
    reply = json.dumps(reply)
    return web.Response(text=reply)


def main():
    conf = config.readSync(path="config.game.json", default=defaultConfig)
    connection = stroage.openConnection(conf["database"])
    root = connection.root()
    global userManager
    if "userManager" in root:
        userManager = root["userManager"]
    else:
        userManager = UserManager()
        root["userManager"] = userManager
        transaction.commit()
    app = web.Application()
    app.add_routes([
        web.get('/', handle),
        web.post('/login', handleLogin),
        web.post('/register', handleRegister),
    ])
    web.run_app(app, host=conf["ip"], port=conf["port"])


if __name__ == '__main__':
    main()
