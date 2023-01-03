import ZODB, ZODB.FileStorage


def openConnection(path: str):
    storage = ZODB.FileStorage.FileStorage(path)
    db = ZODB.DB(storage)
    return db.open()
