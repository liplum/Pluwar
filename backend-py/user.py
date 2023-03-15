import persistent
import transaction

from BTrees.OOBTree import OOBTree
from datetime import datetime


class User(persistent.Persistent):
    def __init__(self, account: str, password: str):
        self.account = account
        self.password = password


class AuthUser(persistent.Persistent):
    def __init__(self, user: User, token: str, timestamp: datetime, expired: datetime):
        self.user = user
        self.token = token
        self.timestamp = timestamp
        self.expired = expired
        """
        When expired
        """

    @property
    def account(self) -> str:
        return self.user.account

    @property
    def password(self) -> str:
        return self.user.password


class UserManager(persistent.Persistent):
    def __init__(self):
        self.account2User = OOBTree()
        """
        account:str to User
        """
        self.token2Auth = OOBTree()
        """
        token:str to AuthUser
        """
        self.account2Auth = OOBTree()
        """
        account:str to AuthUser
        """

    def trtGetUserByAccount(self, account: str) -> User | None:
        if account in self.account2User:
            return self.account2User[account]
        else:
            return None

    def trtGetAuthUserByAccount(self, account: str) -> AuthUser | None:
        if account in self.account2Auth:
            return self.account2Auth[account]
        else:
            return None

    def trtGetAuthUserByToken(self, token: str) -> AuthUser | None:
        if token in self.token2Auth:
            return self.token2Auth[token]
        else:
            return None

    def authorize(self, user: AuthUser):
        self.account2Auth[user.account] = user
        self.token2Auth[user.token] = user
        transaction.commit()

    def unauthorize(self, user: AuthUser):
        token = user.token
        if token in self.token2Auth:
            self.token2Auth.pop(token)
        account = user.account
        if account in self.account2User:
            self.token2Auth.pop(account)
        transaction.commit()

    def hasUser(self, account: str) -> bool:
        return account in self.account2User

    def addUser(self, usr: User):
        self.account2User[usr.account] = usr
        transaction.commit()


def getUserManagerService(connection):
    root = connection.root()
    if "userManager" in root:
        return root["userManager"]
    else:
        userManager = UserManager()
        root["userManager"] = userManager
        transaction.commit()
        return userManager
