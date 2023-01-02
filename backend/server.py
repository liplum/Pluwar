class Datapack:
    def __init__(self):
        self.channel = ""
        self.data = None

    def fromJson(self, json):
        self.channel = json["channel"]
        self.data = json["data"]
