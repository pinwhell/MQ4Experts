#include <StratFoundry\BaseStrategy.mqh>
#include <StratFoundry\HeikenAshi.mqh>

input int PAST_CANDS_TO_SHORT = 6;
input int PAST_CANDS_TO_LONG = 6;

class HeikenAshiFollower : public BaseStrategy {
    public:

   HeikenAshiFollower()
   {
      setUpdateSignalsAt(EV_CLOSE_CANDLE);
      lastTradeType = TradeOp::NONE;
   }
   
   void OnShortSignal() override
   {
      if(lastTradeType == TradeOp::SHORT)
         return;
      
      lastTradeType = TradeOp::SHORT;

      CloseAllTrades(getContextUID());
      
      StrategyOpAbs(TradeOp::SHORT, 0, 0, AccountBalance());
   }

   void OnLongSignal() override
   {
      if(lastTradeType == TradeOp::LONG)
         return;
         
      lastTradeType = TradeOp::LONG;
   
      CloseAllTrades(getContextUID());
      
      StrategyOpAbs(TradeOp::LONG, 0, 0, AccountBalance());
   }


   void UpdateSignals() override
   {   
      if(PastNHACandlesBullish(PAST_CANDS_TO_LONG))
      {
         OnLongSignal(); 
         printf("HeikenAshi Long Met");
      }  
   	else if(PastNHACandlesBearish(PAST_CANDS_TO_SHORT))
   	{
   	   OnShortSignal();
         printf("HeikenAshi Short Met");
   	}
   }
   
   TradeOp lastTradeType;

};

int OnInit()
{
   InitStrategy<HeikenAshiFollower>();

   return (INIT_SUCCEEDED); 
}

void Deinit(const int reason)
{
   DeinitStrategy();
}

void OnTick()
{
   StrategyOnTick();
}