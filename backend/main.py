from http.server import HTTPServer
import time

from server import GameServer

hostName = "localhost"
serverPort = 8080


def main():
    webServer = HTTPServer((hostName, serverPort), GameServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()


if __name__ == "__main__":
    main()
