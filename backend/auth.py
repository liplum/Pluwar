import json


class AuthDB:
    def __init__(self):
        self.account2Pwd = {}

    def validate(self, account: str, pwd: str):
        if account in self.account2Pwd:
            return self.account2Pwd[account] == pwd
        return False


def readJsonDBFromPath(path: str) -> AuthDB:
    with open(path, mode="r") as f:
        return readJsonDB(f.read())


def readJsonDB(content: str) -> AuthDB:
    db = AuthDB()
    db.account2Pwd = json.loads(content)
    return db
