from datetime import datetime, timedelta
import json
import uuid

import transaction
from aiohttp import web
import config
import re
import stroage

from user import User, UserManager, AuthUser

userManager: UserManager
defaultConfig = {
    "ip": "0.0.0.0",
    "port": 8081,
    "database": "runtime_data/auth_db.fs"
}


async def handle(request: web.Request):
    return web.Response(text="Pluwar")


def getExpiredTimestamp(timestamp):
    return timestamp + timedelta(hours=2)


async def handleLogin(request: web.Request):
    payload = await request.json()
    account = payload["account"]
    password = payload["password"]
    authUser = userManager.trtGetAuthUserByAccount(account)
    if authUser is not None:
        if authUser.password == password:
            ts = datetime.utcnow()
            authUser.timestamp = ts
            authUser.expired = getExpiredTimestamp(ts)
            reply = {
                "status": "ok",
                "token": authUser.token,
                "expired": authUser.expired.isoformat(),
            }
        else:
            reply = {
                "status": "incorrectCredential"
            }
    else:
        # Not yet auth
        usr = userManager.trtGetUserByAccount(account)
        if usr is not None and usr.password == password:
            token = uuid.uuid4().hex
            ts = datetime.utcnow()
            expired = getExpiredTimestamp(ts)
            authed = AuthUser(usr, token, ts, expired)
            userManager.authorize(authed)
            reply = {
                "status": "ok",
                "token": token,
                "expired": expired.isoformat()
            }
        else:
            reply = {
                "status": "incorrectCredential"
            }
    reply = json.dumps(reply)
    return web.Response(text=reply)


# at least 1 digit, 1 letter
# at least 8 characters
pwdRegex = re.compile(r"^(?=.*?[A-Z,a-z])(?=.*?[0-9]).{6,}$")


async def handleRegister(request: web.Request):
    payload = await request.json()
    account = payload["account"]
    password = payload["password"]
    if pwdRegex.match(password):
        if userManager.hasUser(account):
            reply = {
                "status": "accountOccupied"
            }
        else:
            userManager.addUser(User(account, password))
            reply = {
                "status": "done"
            }
    else:
        reply = {
            "status": "passwordTooWeek"
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
