import os.path

import ZODB, ZODB.FileStorage


def openConnection(path: str):
    parent, file = os.path.split(path)
    if not os.path.exists(parent):
        os.makedirs(parent)
    storage = ZODB.FileStorage.FileStorage(path)
    db = ZODB.DB(storage)
    return db.open()
