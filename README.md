# SafeScam - Another Safe token on Binance Smart Chain

## Why?
It's been a quiet, boring Saturday night so I have decided, "why not write some token contract for fun?".

## System Explanation

SafeScam is ponzinomics taken to a level of extremity. It is a useless token that anyone can mint and it 
can be redeemed for BUSD held by the SafeScam contract. To mint SafeScam, you can call `claim()` on the contract.
You will be minted SSCAM proportional to your BELUGA holdings, hold 1 BELUGA, get 1 SSCAM. A total of 1k SSCAM can
be minted through claiming. Now you may be asking one question "Can't this be sybiled" and you are very correct. This
is why you can only claim SSCAM once per address and you MUST be holding a minimum of 2 BELUGA or else your claim will
not go through.

You can also redeem your SSCAM tokens for BUSD. To do this, you can call the `redeem()` function. This will redeem your
SSCAM tokens for BUSD based on this formula: `BUSD in contract / SSCAM Supply`. SSCAM also has a function called `swapHeld()` 
which allows the owner of the contract (Chainvisions) to swap any airdrops sent to the contract into BUSD, giving rewards to 
SSCAM holders.