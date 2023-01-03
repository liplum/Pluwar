import persistent
import transaction

from BTrees.OOBTree import OOBTree
from datetime import datetime


class User(persistent.Persistent):
    def __init__(self, account: str, password: str):
        self.account = account
        self.password = password


class AuthUser(persistent.Persistent):
    def __init__(self, user: User, timestamp: datetime, expiration: datetime):
        self.user = user
        self.timestamp = timestamp
        self.expiration = expiration
        """
        When expired
        """


class UserManager(persistent.Persistent):
    def __init__(self):
        self.users = OOBTree()
        """
        account:str to User(account:str,password:str)
        """
        self.tokens = OOBTree()
        """
        token:str to AuthUser(user:User,timestamp:datetime)
        """

    def trtGetUserByAccount(self, account: str) -> User | None:
        if account in self.users:
            return self.users[account]
        else:
            return None

    def hasUser(self, account: str) -> bool:
        return account in self.users

    def addUser(self, usr: User):
        self.users[usr.account] = usr
        transaction.commit()
