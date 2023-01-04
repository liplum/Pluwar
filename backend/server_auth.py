from datetime import datetime, timedelta
import uuid

from aiohttp import web
import fs
import re
import stroage
from encode import jsonEncode

from user import User, UserManager, AuthUser, getUserManagerService

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
            print(f"{account} logged in and refresh expiration until {authUser.expired}.")
            reply = {
                "status": "ok",
                "token": authUser.token,
                "expired": authUser.expired,
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
            print(f"{account} logged in and will be expired after {expired}.")
            reply = {
                "status": "ok",
                "token": token,
                "expired": expired
            }
        else:
            reply = {
                "status": "incorrectCredential"
            }
    reply = jsonEncode(reply)
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
            print(f"{account} signed up.")
            reply = {
                "status": "done"
            }
    else:
        reply = {
            "status": "passwordTooWeek"
        }
    reply = jsonEncode(reply)
    return web.Response(text=reply)


def main():
    conf = fs.readSync(path="config.data.json", default=defaultConfig)
    connection = stroage.openConnection(conf["database"])
    global userManager
    userManager = getUserManagerService(connection)
    app = web.Application()
    app.add_routes([
        web.get('/', handle),
        web.post('/login', handleLogin),
        web.post('/register', handleRegister),
    ])
    web.run_app(app, host=conf["ip"], port=conf["port"])


if __name__ == '__main__':
    main()
