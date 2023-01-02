async def gameLoop(ctx):
    turnNumber = 0
    while await ctx.checkGameEnd():
        first, second = await ctx.judgeActionOrder()
        # Action from first player
        firstAction = await first.awaitAction(ctx)  # if timeout, select the first available action
        await ctx.settleAction(firstAction)
        # Action from second player
        secondAction = await second.awaitAction(ctx)
        await ctx.settleAction(secondAction)
        turnNumber += 1
    await ctx.onGameEnd()
