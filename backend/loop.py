import asyncio


class GameLoopContext:
    def __init__(self):
        self.turn = 0
        self.battle = None
        self.channel = None
        self.actionWaitingTime = 15

    async def goNextTurn(self):
        self.turn += 1

    async def checkGameEnd(self) -> bool:
        return self.battle.checkGameEnd()

    async def judgeActionOrder(self) -> tuple["ActorPlayer", "ActorPlayer"]:
        order = self.battle.judgeActionOrder()
        first, second = order
        firstPlayer = ActorPlayer(self, first)
        secondPlayer = ActorPlayer(self, second)
        await self.channel.sendOrder(to=first.id, order=order)
        return firstPlayer, secondPlayer

    async def settleAction(self, action: "GameAction"):
        pass

    async def onGameEnd(self):
        pass


class ActorPlayer:
    def __init__(self, ctx: GameLoopContext, player):
        self.ctx = ctx
        self.player = player

    async def awaitAction(self) -> "GameAction":
        """
        If timeout, select the first available action
        """
        totalTime = self.ctx.actionWaitingTime
        waitingTimeSpan = totalTime / 100
        while totalTime > 0:
            action = self.ctx.channel.tryGetPlayerAction()
            if action is not None:
                return GameAction(self.ctx, self, action)
            totalTime -= waitingTimeSpan
            await asyncio.sleep(waitingTimeSpan)
        # still no action during waiting time
        action = self.ctx.battle.selectTimeoutActionOf(self.player)
        return GameAction(self.ctx, self, action)


class GameAction:
    def __init__(self, ctx: GameLoopContext, player: ActorPlayer, action):
        self.ctx = ctx
        self.player = player
        self.action = action


async def gameLoop(ctx: GameLoopContext):
    while await ctx.checkGameEnd():
        first, second = await ctx.judgeActionOrder()
        # Action from first player
        firstAction = await first.awaitAction()
        await ctx.settleAction(firstAction)
        # Action from second player
        secondAction = await second.awaitAction()
        await ctx.settleAction(secondAction)
        await ctx.goNextTurn()
    await ctx.onGameEnd()
