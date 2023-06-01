 
#include <StratFoundry\BaseStrategy.mqh>

input double PER_TRADE_RISK_PERC = 1;
input int EMA_LEN = 200;
input int COMFIRM_CANDLES = 2;

class MAHolderStrategy : public BaseStrategy {

public:

MAHolderStrategy()
{
   lastTradeType = TradeOp::NONE;
   setUpdateSignalsAt(EV_TICK);
   //setUpdateSignalsAt(EV_CLOSE_CANDLE);

   //setPerTradeRiskPerc(PER_TRADE_RISK_PERC);
}

bool EMALongConditionMeets(double emaLen, int barLevel = 2)
{
   bool allAbobe = true;
   
   for (int i = 0; i < barLevel; i++)
   {
      double currEma = iMA(Symbol(), PERIOD_CURRENT, emaLen, 0, MODE_EMA, PRICE_CLOSE, i );
      
      if (Close[i] < currEma)
         allAbobe = false;  
   }
   
   return allAbobe;
}

bool EMAShortConditionMeets(double emaLen, int barLevel = 2)
{
   bool allBellow = true;
   for (int i = 0; i < barLevel; i++)
   {
      double currEma = iMA(Symbol(), PERIOD_CURRENT, emaLen, 0, MODE_EMA, PRICE_CLOSE, i );
      
      if (Close[i] > currEma)
         allBellow = false;  
   }
   
   return allBellow;
}

void OnShortSignal() override
{
   if(lastTradeType == TradeOp::SHORT)
      return;

   CloseAllTrades(getContextUID());
   
   if(CanPlaceTrades())
   {
      lastTradeType = TradeOp::SHORT;
      StrategyOpAbs(TradeOp::SHORT, 0, 0, AccountBalance());
   }
}

void OnLongSignal() override
{
   if(lastTradeType == TradeOp::LONG)
      return;

   CloseAllTrades(getContextUID());
   
   if(CanPlaceTrades())
   {
      lastTradeType = TradeOp::LONG;
      StrategyOpAbs(TradeOp::LONG, 0, 0, AccountBalance());
   }
}

void UpdateSignals() override
{
   if(EMALongConditionMeets(EMA_LEN, COMFIRM_CANDLES))
   {
      OnLongSignal(); 
      printf("EMA Long Met");
   }  
	else if(EMAShortConditionMeets(EMA_LEN, COMFIRM_CANDLES))
	{
	   printf("EMA Short Met");
	   OnShortSignal();
	}
}

private:

TradeOp lastTradeType;

};

int OnInit()
{
   InitStrategy<MAHolderStrategy>();

   return (INIT_SUCCEEDED); 
}
void Deinit(const int reason)
{
   DeinitStrategy();
}

double OnTester()
{
   return MathMax(0, TesterStatistics(STAT_PROFIT)) - TesterStatistics(STAT_EQUITY_DD);
}

void OnTick()
{
   StrategyOnTick();
}