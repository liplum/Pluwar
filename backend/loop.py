class GameLoopContext:
    def __init__(self):
        self.turn = 0

    async def goNextTurn(self):
        self.turn += 1

    async def checkGameEnd(self) -> bool:
        pass

    async def judgeActionOrder(self) -> tuple["ActorPlayer", "ActorPlayer"]:
        pass

    async def settleAction(self, action: "GameAction"):
        pass

    async def onGameEnd(self):
        pass


class ActorPlayer:

    async def awaitAction(self, ctx: GameLoopContext) -> "GameAction":
        """
        If timeout, select the first available action
        """
        pass


class GameAction:
    pass


async def gameLoop(ctx: GameLoopContext):
    while await ctx.checkGameEnd():
        first, second = await ctx.judgeActionOrder()
        # Action from first player
        firstAction = await first.awaitAction(ctx)
        await ctx.settleAction(firstAction)
        # Action from second player
        secondAction = await second.awaitAction(ctx)
        await ctx.settleAction(secondAction)
        await ctx.goNextTurn()
    await ctx.onGameEnd()
