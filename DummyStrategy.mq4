 
#include <StratFoundry\BaseStrategy.mqh>

input double PER_TRADE_RISK_PERC = 1;
input int SL_PIPS = 30;
input int TP_PIPS = 90;

class DummyStrategy : public BaseStrategy {
public:

DummyStrategy()
{
   setSlPips(0);
   setTpPips(0);
   setUpdateSignalsAt(EV_CLOSE_CANDLE);
}

void UpdateSignals() override
{
   if(CanPlaceTrades())
      return;

   if(false)
      OnLongSignal();
	else if(false)
	   OnShortSignal();
}

private:

TradeOp nextTradeType;

};

int OnInit()
{
   InitStrategy<DummyStrategy>();

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