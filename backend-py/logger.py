from enum import IntEnum


class LoggingLevel(IntEnum):
    error = 0
    info = 5
    game = 8
    verbose = 10

    # noinspection PyProtectedMember
    @staticmethod
    def byName(name: str):
        if name in LoggingLevel._member_map_:
            return LoggingLevel._member_map_[name]
        else:
            return LoggingLevel.verbose


level = LoggingLevel.verbose


def v(*args):
    if LoggingLevel.verbose <= level:
        print("[v]", *args)


def g(*args):
    if LoggingLevel.game <= level:
        print("[i]", *args)


def i(*args):
    if LoggingLevel.info <= level:
        print("[i]", *args)


def e(*args):
    if LoggingLevel.error <= level:
        print("[e]", *args)
