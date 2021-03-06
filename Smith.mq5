//+------------------------------------------------------------------+
//|                                                        Smith.mq5 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Trade\AccountInfo.mqh> ///https://www.mql5.com/ru/articles/481
#include <Trade\Trade.mqh> //https://www.mql5.com/ru/docs/standardlibrary/tradeclasses/ctrade
#include "Include\GetLoteSize.mqh" //get lot size
#include "Include\Lib_CisNewBar.mqh" //detecrint new bar
//встроенные функции //https://www.mql5.com/ru/articles/481

CisNewBar current_chart; // экземпляр класса CisNewBar: текущий график
ENUM_TIMEFRAMES Prev_Period;
input int StopLoss=55;
input int TakeProfit=125;

/*H4
input int StopLoss=130;
input int TakeProfit=400;*/
input int Slippage=5;
input bool Debug=true;
input double Lots=0.1;
input bool CalculateLot = true;
input double Risk=1;


input bool Par1=true;
input bool Par2=true;
input bool Par3=true;
input bool Par4=true;
input bool Par5=true;
input bool Par6=true;
input bool Par7=true;
input bool Par8=true;
input bool Par9=true;
input bool Par10=true;
input bool Par11=true;
input bool Par12=true;
input bool Par13=true;
input bool Par14=true;
input bool Par15=true;
input bool Par16=true;

   double OsMa=0;
   double OsMa_max1=0;
   double OsMa_max2=0;
   double OsMa_max3=0;
   double OsMa_min1=0;
   double OsMa_min2=0;
   double OsMa_min3=0;

   double Price=0;
   double Price_max1=0;
   double Price_max2=0;
   double Price_max3=0;
   double Price_min1=0;
   double Price_min2=0;
   double Price_min3=0;

   double MACD=0;
   double MACD_max1=0;
   double MACD_max2=0;
   double MACD_max3=0;
   double MACD_min1=0;
   double MACD_min2=0;
   double MACD_min3=0;

   double Stoch=0;
   double Stoch_max1=0;
   double Stoch_max2=0;
   double Stoch_max3=0;
   double Stoch_min1=0;
   double Stoch_min2=0;
   double Stoch_min3=0;

   int pos_max1=0;
   int pos_max2=0;
   int pos_max3=0;
   int pos_min1=0;
   int pos_min2=0;
   int pos_min3=0;


int Close_Osma_MacdPrice;
ENUM_TIMEFRAMES Close_Osma_MacdPrice_Period;
double trade_volume=0.1;
int    OsMA_handle_M1,OsMA_handle_M5,OsMA_handle_M15,OsMA_handle_M30,OsMA_handle_H1,OsMA_handle_H4,OsMA_handle_D1,OsMA_handle_W1;
int    MACD_handle_M1,MACD_handle_M5,MACD_handle_M15,MACD_handle_M30,MACD_handle_H1,MACD_handle_H4,MACD_handle_D1,MACD_handle_W1;
int    Stochastic_handle_M1,Stochastic_handle_M5,Stochastic_handle_M15,Stochastic_handle_M30,Stochastic_handle_H1,Stochastic_handle_H4,Stochastic_handle_D1,Stochastic_handle_W1;
CTrade trade;
int    MA_handle_H4;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);
   current_chart.isNewBar();
   Prev_Period=Period();
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   Comment("Symbol: ",Symbol(),"\n"
           //"Digits: ",(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS),"\n",
           //"Spread: ",(int)SymbolInfoInteger(_Symbol,SYMBOL_SPREAD),"\n",
           // "Trend: ",Min_Max_OsMA(Period()),"\n",
           //"Ask: ",SymbolInfoDouble(_Symbol,SYMBOL_ASK),"\n",
           //"Bid: ",SymbolInfoDouble(_Symbol,SYMBOL_BID)
           );//}
//---
   if(Prev_Period!=Period())
     {//при смене периода переопределяем период в CisNewBar
      current_chart.SetPeriod(Period());
      current_chart.isNewBar();
      Prev_Period=Period();
      Print("Period has been changed: ",EnumToString(Period()));
     }

   if(current_chart.isNewBar()>0)
     {
      //   Print   

      //   Print("Новый бар: ",TimeToString(TimeCurrent(),TIME_SECONDS)," Symbol: ",Symbol()," Таймфрейм: ",Description_TimeFrame(Period()));
      //Min_Max_OsMA(Period());

      //int Osma_MacdPrice(ENUM_TIMEFRAMES Test_period,string my_symbol) // http://take.ms/owrE8

      //продажа по Osma_MacdPrice

      if(Debug)
        {
           Osma_MacdPrice2Ekstr(PERIOD_H1,Symbol());
        }
      else
        {
         Osma_MacdPrice2Ekstr(PERIOD_M5,Symbol());
         Osma_MacdPrice2Ekstr(PERIOD_M15,Symbol());
         Osma_MacdPrice2Ekstr(PERIOD_M30,Symbol());
         Osma_MacdPrice2Ekstr(PERIOD_H1,Symbol());
         Osma_MacdPrice2Ekstr(PERIOD_H4,Symbol());
         Osma_MacdPrice2Ekstr(PERIOD_D1,Symbol());

         Osma_MacdPrice3Ekstr(PERIOD_M5,Symbol());
         Osma_MacdPrice3Ekstr(PERIOD_M15,Symbol());
         Osma_MacdPrice3Ekstr(PERIOD_M30,Symbol());
         Osma_MacdPrice3Ekstr(PERIOD_H1,Symbol());
         Osma_MacdPrice3Ekstr(PERIOD_H4,Symbol());
         Osma_MacdPrice3Ekstr(PERIOD_D1,Symbol());
        }

      //  Osma_MacdPrice(PERIOD_H4,"EURUSD");      
      //  Osma_MacdPrice(PERIOD_D1,"EURUSD");   
/*   //продажа по Osma_MacdPrice
      if((PositionSelect("EURUSD")==0) && (result_Osma_MacdPrice<0))
        {
         trade.PositionOpen("EURUSD",ORDER_TYPE_SELL,trade_volume,SymbolInfoDouble("EURUSD",SYMBOL_BID),SymbolInfoDouble("EURUSD",SYMBOL_ASK)+StopLoss*_Point,SymbolInfoDouble("EURUSD",SYMBOL_BID)-TakeProfit*_Point,
                            "Osma_MacdPrice PERIOD_M30 ORDER_TYPE_SELL");
        }
      //покупка по Osma_MacdPrice
      if((PositionSelect("EURUSD")==0) && (result_Osma_MacdPrice>0))
        {
         trade.PositionOpen("EURUSD",ORDER_TYPE_BUY,volume,SymbolInfoDouble("EURUSD",SYMBOL_ASK),SymbolInfoDouble("EURUSD",SYMBOL_BID)-StopLoss*_Point,SymbolInfoDouble("EURUSD",SYMBOL_ASK)+TakeProfit*_Point,
                            "Osma_MacdPrice PERIOD_M30 ORDER_TYPE_BUY");
        }
        
       result_Osma_MacdPrice=Osma_MacdPrice(PERIOD_H1,"EURUSD");

      //продажа по Osma_MacdPrice
      if((PositionSelect("EURUSD")==0) && (result_Osma_MacdPrice<0))
        {
         trade.PositionOpen("EURUSD",ORDER_TYPE_SELL,volume,SymbolInfoDouble("EURUSD",SYMBOL_BID),SymbolInfoDouble("EURUSD",SYMBOL_ASK)+StopLoss*_Point,SymbolInfoDouble("EURUSD",SYMBOL_BID)-TakeProfit*_Point,
                            "Osma_MacdPrice PERIOD_H1 ORDER_TYPE_SELL");
        }
      //покупка по Osma_MacdPrice
      if((PositionSelect("EURUSD")==0) && (result_Osma_MacdPrice>0))
        {
         trade.PositionOpen("EURUSD",ORDER_TYPE_BUY,volume,SymbolInfoDouble("EURUSD",SYMBOL_ASK),SymbolInfoDouble("EURUSD",SYMBOL_BID)-StopLoss*_Point,SymbolInfoDouble("EURUSD",SYMBOL_ASK)+TakeProfit*_Point,
                            "Osma_MacdPrice PERIOD_H1 ORDER_TYPE_BUY");
        }
        */


      //******************* закрываем сделки
/*   if(PositionSelect("EURUSD")!=0)
        { //есть открытые сделки по евродоллар
         string comment=PositionGetString(POSITION_COMMENT);
         
         if((PositionGetDouble(POSITION_PROFIT)>0)&&(StringFind(comment,"Osma_MacdPrice")!=-1))//сделки были открыты в Osma_MacdPrice
           {            Osma_MacdPrice_Close("EURUSD");           }
        }*/
     }
  }
  
  
//Return previous or next period 
ENUM_TIMEFRAMES PeriodPlusMinus(ENUM_TIMEFRAMES OldPeriod,int PlusMinus)
  {
   switch(PlusMinus)
     {
      case 1: switch(OldPeriod)
        {
         case PERIOD_M1: return(PERIOD_M5);break;
         case PERIOD_M5: return (PERIOD_M15);break;
         case PERIOD_M15: return (PERIOD_M30);break;
         case PERIOD_M30: return (PERIOD_H1);break;
         case PERIOD_H1: return (PERIOD_H4);break;
         case PERIOD_H4: return (PERIOD_D1);break;
         case PERIOD_D1: return (PERIOD_W1);break;
        }
      break;
      case -1: switch(OldPeriod)
        {

         case PERIOD_M5: return (PERIOD_M1);break;
         case PERIOD_M15: return (PERIOD_M5);break;
         case PERIOD_M30: return (PERIOD_M15);break;
         case PERIOD_H1: return (PERIOD_M30);break;
         case PERIOD_H4: return (PERIOD_H1);break;
         case PERIOD_D1: return (PERIOD_H4);break;
         case PERIOD_W1: return (PERIOD_D1);break;
        }
     }
   return(0);
  }
//три убывающих максимума по цене в экстремумах OSma
//во втором максимуме цена и MACD не дают максимума - продаем
// 1. если MACD и цена идут на убывание, то возвращает -1
// 2. если выполняетя условие 1 и второй минимум Osma меньше первого, то возвращает -2
// TO DO закрывать при появлении 2-х минимумов сигнальной стохастика, если минимумы возрастают на периоде меньше чем период открытия сделки
int Osma_MacdPrice3Ekstr(ENUM_TIMEFRAMES Test_period,string my_symbol) // http://take.ms/owrE8
  {
   if(PositionSelect(my_symbol)!=0) {return(0);};

   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(my_symbol,Test_period,0,100,rates);
   if(copied==-1){Print("Ошибка копирования цены в Osma_MacdPrice");return(0);}

   double Array_OsMA[],Array_MACD[],Array_Stoch[];
   int OsMA_handle=iOsMA(my_symbol,Test_period,12,26,9,PRICE_CLOSE);
   int MACD_handle=iMACD(my_symbol,Test_period,12,26,9,PRICE_CLOSE);
   int Stoch_handle=iStochastic(my_symbol,Test_period,5,3,3,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(OsMA_handle,0,0,100,Array_OsMA);
   CopyBuffer(MACD_handle,0,0,100,Array_MACD);
   CopyBuffer(Stoch_handle,0,0,100,Array_Stoch);
   ArraySetAsSeries(Array_OsMA,true);
   ArraySetAsSeries(Array_MACD,true);
   ArraySetAsSeries(Array_Stoch,true);

  

   int Bars_After=2;
   for(int i=Bars_After;i<=95;i++)
     {
      //ищем максимумы первый от текущей точки влево, потом второй и третий
      if((Array_OsMA[i]>Array_OsMA[i+1]) && (Array_OsMA[i]>Array_OsMA[i+2]) && (Array_OsMA[i]>Array_OsMA[i+3]) && (Array_OsMA[i]>Array_OsMA[i-1]) && (Array_OsMA[i]>Array_OsMA[i-Bars_After]))
        {
         if(pos_max1==0){OsMa_max1=Array_OsMA[i];pos_max1=i;}else if(pos_max2==0) {OsMa_max2=Array_OsMA[i];pos_max2=i;} else if(pos_max3==0) {OsMa_max3=Array_OsMA[i];pos_max3=i;}
        }
      //ищем минимумы первый от текущей точки влево, потом второй и третий
      if((Array_OsMA[i]<Array_OsMA[i+1]) && (Array_OsMA[i]<Array_OsMA[i+2]) && (Array_OsMA[i]<Array_OsMA[i+3]) && (Array_OsMA[i]<Array_OsMA[i-1]) && (Array_OsMA[i]<Array_OsMA[i-Bars_After]))
        {
         if(pos_min1==0){OsMa_min1=Array_OsMA[i];pos_min1=i;}else if(pos_min2==0) {OsMa_min2=Array_OsMA[i];pos_min2=i;} else if(pos_min3==0) {OsMa_min3=Array_OsMA[i];pos_min3=i;}
        }
      if(( pos_max1!=0) && (pos_max2!=0) && (pos_max3!=0) && (pos_min1!=0) && (pos_min2!=0) && (pos_min3!=0)){break;}//выход если нашли все экстремумы
     }
//проверяем убываение
//сравниваем максимум цены (открытия/закрытия) +1 бар вперед и 2 назад от экстремума


   Price_max1=MathMax(MathMax(rates[pos_max1].open,rates[pos_max1].close),MathMax(MathMax(rates[pos_max1+1].open,rates[pos_max1+1].close),MathMax(rates[pos_max1+2].open,rates[pos_max1+2].close)));
   Price_max2=MathMax(MathMax(rates[pos_max2].open,rates[pos_max2].close),MathMax(MathMax(rates[pos_max2+1].open,rates[pos_max2+1].close),MathMax(rates[pos_max2+2].open,rates[pos_max2+2].close)));
   Price_max3=MathMax(MathMax(rates[pos_max3].open,rates[pos_max3].close),MathMax(MathMax(rates[pos_max3+1].open,rates[pos_max3+1].close),MathMax(rates[pos_max3+2].open,rates[pos_max3+2].close)));

   Price_min1=MathMin(MathMin(rates[pos_min1].open,rates[pos_min1].close),MathMin(MathMin(rates[pos_min1+1].open,rates[pos_min1+1].close),MathMin(rates[pos_min1+2].open,rates[pos_min1+2].close)));
   Price_min2=MathMin(MathMin(rates[pos_min2].open,rates[pos_min2].close),MathMin(MathMin(rates[pos_min2+1].open,rates[pos_min2+1].close),MathMin(rates[pos_min2+2].open,rates[pos_min2+2].close)));
   Price_min3=MathMin(MathMin(rates[pos_min3].open,rates[pos_min3].close),MathMin(MathMin(rates[pos_min3+1].open,rates[pos_min3+1].close),MathMin(rates[pos_min3+2].open,rates[pos_min3+2].close)));

//MACD
   MACD_max1=MathMax(MathMax(Array_MACD[pos_max1],Array_MACD[pos_max1+1]),Array_MACD[pos_max1+2]);
   MACD_max2=MathMax(MathMax(Array_MACD[pos_max2],Array_MACD[pos_max2+1]),Array_MACD[pos_max2+2]);
   MACD_max3=MathMax(MathMax(Array_MACD[pos_max3],Array_MACD[pos_max3+1]),Array_MACD[pos_max3+2]);
   MACD_min1=MathMin(MathMin(Array_MACD[pos_min1],Array_MACD[pos_min1+1]),Array_MACD[pos_min1+2]);
   MACD_min2=MathMin(MathMin(Array_MACD[pos_min2],Array_MACD[pos_min2+1]),Array_MACD[pos_min2+2]);
   MACD_min3=MathMin(MathMin(Array_MACD[pos_min3],Array_MACD[pos_min3+1]),Array_MACD[pos_min3+2]);

//Stoch
   Stoch=Array_Stoch[1];
   Stoch_max1=MathMax(MathMax(Array_Stoch[pos_max1],Array_Stoch[pos_max1+1]),Array_Stoch[pos_max1+2]);
   Stoch_max2=MathMax(MathMax(Array_Stoch[pos_max2],Array_Stoch[pos_max2+1]),Array_Stoch[pos_max2+2]);
   Stoch_max3=MathMax(MathMax(Array_Stoch[pos_max3],Array_Stoch[pos_max3+1]),Array_Stoch[pos_max3+2]);
   Stoch_min1=MathMin(MathMin(Array_Stoch[pos_min1],Array_Stoch[pos_min1+1]),Array_Stoch[pos_min1+2]);
   Stoch_min2=MathMin(MathMin(Array_Stoch[pos_min2],Array_Stoch[pos_min2+1]),Array_Stoch[pos_min2+2]);
   Stoch_min3=MathMin(MathMin(Array_Stoch[pos_min3],Array_Stoch[pos_min3+1]),Array_Stoch[pos_min3+2]);

//Osma
   OsMa_max1=MathMax(MathMax(Array_OsMA[pos_max1],Array_OsMA[pos_max1+1]),Array_OsMA[pos_max1+2]);
   OsMa_max2=MathMax(MathMax(Array_OsMA[pos_max2],Array_OsMA[pos_max2+1]),Array_OsMA[pos_max2+2]);
   OsMa_max3=MathMax(MathMax(Array_OsMA[pos_max3],Array_OsMA[pos_max3+1]),Array_OsMA[pos_max3+2]);
   OsMa_min1=MathMin(MathMin(Array_OsMA[pos_min1],Array_OsMA[pos_min1+1]),Array_OsMA[pos_min1+2]);
   OsMa_min2=MathMin(MathMin(Array_OsMA[pos_min2],Array_OsMA[pos_min2+1]),Array_OsMA[pos_min2+2]);
   OsMa_min3=MathMin(MathMin(Array_OsMA[pos_min3],Array_OsMA[pos_min3+1]),Array_OsMA[pos_min3+2]);
   
   if(TimeTradeServer()==D'2017.02.06 00:05:00')
        {
         Print("@@@@@@@@@@ Osma_MacdPrice3Ekstr @@@@@@@@@@");
         Print("pos_max1=",pos_max1," Price=",Price_max1," MACD=",DoubleToString(MACD_max1)," OsMa=",DoubleToString(OsMa_max1)," Stoch=",DoubleToString(Stoch_max1));
         Print("pos_max2=",pos_max2," Price=",Price_max2," MACD=",DoubleToString(MACD_max2)," OsMa=",DoubleToString(OsMa_max2)," Stoch=",DoubleToString(Stoch_max2));
         Print("pos_min1=",pos_min1," Price=",Price_min1," MACD=",DoubleToString(MACD_min1)," OsMa=",DoubleToString(OsMa_min1)," Stoch=",DoubleToString(Stoch_min1));
         Print("pos_min2=",pos_min2," Price=",Price_min2," MACD=",DoubleToString(MACD_min2)," OsMa=",DoubleToString(OsMa_min2)," Stoch=",DoubleToString(Stoch_min2));
         // 
        }

   if((Price_min2<Price_min1) && // цена идет в рост
      (MACD_min2<MACD_min1) && (MACD_max2<MACD_max1) && (MACD_min1<0) && // MACD ростет и ниже нуля
      // (pos_min1<pos_max1) && //торгуем от минимума
      //(OsMa_max1>OsMa_max2) && //максимумы в рост (фильтр для M30 2014.01.03
      (OsMa_min2<OsMa_min1) && // OSMA в рост 
      //  (pos_min1>2) && (pos_min1<10)&&//нарисовался минимум 
      (Stoch_min1<20) && (Stoch_max1>70) // стохастик выше 80, в минимуме меньше 30
      && (Stoch<10) //текущая стохастик < 10
      && (OsMa_max1<-1*OsMa_min2)
      //     && (OsMa_max1>OsMa_max2) //максимумы идут по возрастанию
      && (OsMa_max2>0) //&& (OsMa_min1<0)
      && (rates[0].open>Price_min1) && (rates[0].close>Price_min1))
     {
      
      trade.PositionOpen(my_symbol,ORDER_TYPE_BUY,trade_volume,SymbolInfoDouble(my_symbol,SYMBOL_ASK),SymbolInfoDouble(my_symbol,SYMBOL_BID)-StopLoss*_Point,SymbolInfoDouble(my_symbol,SYMBOL_ASK)+TakeProfit*_Point,
                         "Osma_MacdPrice "+EnumToString(Test_period));

      return(2);
     }

/*  if  (TimeTradeServer()== D'2014.01.03 04:00:00'){
     Print("@@@@@@@@@@ Osma_MacdPrice Return -2 @@@@@@@@@@"); 
      Print("pos_max1=",pos_max1," Price=",Price_max1," MACD=",DoubleToString(MACD_max1)," OsMa=",DoubleToString(OsMa_max1)," Stoch=",DoubleToString(Stoch_max1)," pos_max2=",pos_max2);
      Print("pos_max2=",pos_max2," Price=",Price_max2," MACD=",DoubleToString(MACD_max2)," OsMa=",DoubleToString(OsMa_max2)," Stoch=",DoubleToString(Stoch_max2));
      Print("pos_min1=",pos_min1," Price=",Price_min1," MACD=",DoubleToString(MACD_min1)," OsMa=",DoubleToString(OsMa_min1)," Stoch=",DoubleToString(Stoch_min1));
      Print("pos_min2=",pos_min2," Price=",Price_min2," MACD=",DoubleToString(MACD_min2)," OsMa=",DoubleToString(OsMa_min2)," Stoch=",DoubleToString(Stoch_min2));
      Print ("Stoch=",Stoch);
      for (int i=0;i<10;i++){  Print("rates=",rates[i].open," i=",i);};
     }*/
   if((Price_max2>Price_max1) // цена идет на убывание
      && (MACD_max2>MACD_max1) && (MACD_min2>MACD_min1) && (MACD_max1>0) // MACD убывание и выше нуля
      // && (pos_max1<pos_min1)  //торгуем от максимума.
      && (OsMa_max2>OsMa_max1) // OSMA на убывание 
      //  && (pos_max1>2) && (pos_max1<10) //нарисовался максимум 
      && (Stoch_max1>80) && (Stoch_min1<30) // стохастик выше 80, в минимуме меньше 30
      && (Stoch>80) //текущая стохастик больше 80
      && ((-1*OsMa_min1)>OsMa_max2) //минимум1 по амплитуде больше максимума2.
      //  && (OsMa_min1<OsMa_min2) //минимумы идут по убыванию
      && (OsMa_min2<0)
      && (rates[0].open<Price_max1) && (rates[0].close<Price_max1))
     {

      trade.PositionOpen(my_symbol,ORDER_TYPE_SELL,trade_volume,SymbolInfoDouble(my_symbol,SYMBOL_BID),SymbolInfoDouble(my_symbol,SYMBOL_ASK)+StopLoss*_Point,SymbolInfoDouble(my_symbol,SYMBOL_BID)-TakeProfit*_Point,
                         "Osma_MacdPrice "+EnumToString(Test_period));

      return(-2);
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Osma_MacdPrice_Close(string my_symbol)// передаем валюту, определяем период и закрываем. экстремумы по стохастику.
                                           // если была продажа, то ищем два минимума, первый больше второго (считаем справа налево)
// первый минимум по времени должен быть после открытия сделки.минимумы должны быть меньше 50
  {

   ENUM_TIMEFRAMES close_period;
   int Stoch_handle;
   double Array_Stoch[];



   if(PositionSelect(my_symbol)!=0)
     {
      //получаю коммент и опредеяю на каком периоде он был открыт
      close_period=PERIOD_M5;
      string comment=PositionGetString(POSITION_COMMENT);
      //  if(StringFind(comment,EnumToString(PERIOD_M5) !=-1)) close_period=PERIOD_M5;
      if(StringFind(comment,EnumToString(PERIOD_M15))!=-1) close_period=PERIOD_M5;
      if(StringFind(comment,EnumToString(PERIOD_M30))!=-1) close_period=PERIOD_M15;
      if(StringFind(comment,EnumToString(PERIOD_H1)) !=-1) close_period=PERIOD_M30;
      if(StringFind(comment,EnumToString(PERIOD_H4)) !=-1) close_period=PERIOD_H1;
      if(StringFind(comment,EnumToString(PERIOD_D1)) !=-1) close_period=PERIOD_H4;

      //уменьшаем период
      //ENUM_TIMEFRAMES PeriodPlusMinus(ENUM_TIMEFRAMES OldPeriod,int PlusMinus)
      close_period=PeriodPlusMinus(close_period,-1);

      Stoch_handle=iStochastic(my_symbol,close_period,5,3,3,MODE_SMA,STO_LOWHIGH);
      CopyBuffer(Stoch_handle,1,0,100,Array_Stoch);//буфер 1 - сигнальная
      ArraySetAsSeries(Array_Stoch,true);

      long OrderOpenTime=PositionGetInteger(POSITION_TIME);
      //Print("время открытия позиции ",OrderOpenTime );

      int i=2;
      while((pos_min1==0) || (pos_min2==0))//выполняем пока не найдем 2 минимума
        {
         if((Array_Stoch[i]<Array_Stoch[i+1]) && (Array_Stoch[i]<Array_Stoch[i-1]))
           {
            if(pos_min1==0){pos_min1=i;Stoch_min1=Array_Stoch[i];}else{pos_min2=i;Stoch_min2=Array_Stoch[i];}
           }
         i++;
        }

      i=2;
      while((pos_max1==0) || (pos_max2==0))//выполняем пока не найдем 2 максимума
        {
         if((Array_Stoch[i]>Array_Stoch[i+1]) && (Array_Stoch[i]>Array_Stoch[i-1]))
           {
            if(pos_max1==0){pos_max1=i;Stoch_max1=Array_Stoch[i];}else{pos_max2=i;Stoch_max2=Array_Stoch[i];}
           }
         i++;
        }

      if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_SELL)
        {
         datetime tm[]; // массив, в котором возвращается время баров
         CopyTime(my_symbol,close_period,pos_min2,1,tm);
         if((pos_min2!=0) && (Stoch_min1>Stoch_min2) && (OrderOpenTime<tm[0]))//закрываем сделку 
           {
            Print("Close Sell by 2 min. Order's open time ",OrderOpenTime," time pos_min2 ",tm[0]);
            if(trade.PositionClose(my_symbol,Slippage))//,"Закрываем по 2-му минимуму "+EnumToString(close_period)))
              {Print("Error during closing trade");} //ENUM_POSITION_PROPERTY_INTEGER
           }
        }

      if(PositionGetInteger(POSITION_TYPE)==ORDER_TYPE_BUY)
        {
         datetime tm[]; // массив, в котором возвращается время баров
         CopyTime(my_symbol,close_period,pos_max2,1,tm);
         if((pos_max2!=0) && (Stoch_max1<Stoch_max2) && (OrderOpenTime<tm[0]))//закрываем сделку 
           {
            Print("Close Buy by 2 max. Order opern time ",OrderOpenTime," time pos_min2 ",tm[0]);
            if(trade.PositionClose(my_symbol,Slippage))//,"Закрываем по 2-му максимуму "+EnumToString(close_period)))
              {Print("Error during closing trade");} //ENUM_POSITION_PROPERTY_INTEGER
           }
        }

     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Min_Max_OsMA(ENUM_TIMEFRAMES Test_period)
  {
   double Array_OsMA[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   switch(Test_period)
     {
      case PERIOD_M1: CopyBuffer(OsMA_handle_M1, 0,0,100,Array_OsMA);break;
      case PERIOD_M5: CopyBuffer(OsMA_handle_M5, 0,0,100,Array_OsMA);break;
      case PERIOD_M15:CopyBuffer(OsMA_handle_M15,0,0,100,Array_OsMA);break;
      case PERIOD_M30:CopyBuffer(OsMA_handle_M30,0,0,100,Array_OsMA);break;
      case PERIOD_H1: CopyBuffer(OsMA_handle_H1, 0,0,100,Array_OsMA);break;
      case PERIOD_H4: CopyBuffer(OsMA_handle_H4, 0,0,100,Array_OsMA);break;
      case PERIOD_D1: CopyBuffer(OsMA_handle_D1, 0,0,100,Array_OsMA);break;
      case PERIOD_W1: CopyBuffer(OsMA_handle_W1, 0,0,100,Array_OsMA);break;
     };

//--- задаём порядок индексации массива MA[] как в MQL4
   ArraySetAsSeries(Array_OsMA,true);

  

   for(int i=1;i<=95;i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      //ищем максимум
      if((Array_OsMA[i]>Array_OsMA[i+1]) && (Array_OsMA[i]>Array_OsMA[i+2]) && (Array_OsMA[i]>Array_OsMA[i+3]) && (Array_OsMA[i]>Array_OsMA[i-1]))
        {
         if(pos_max1==0){OsMa_max1=Array_OsMA[i];pos_max1=i;}else if(pos_max2==0) {OsMa_max2=Array_OsMA[i];pos_max2=i;}
        }
      //ищем минимум
      if((Array_OsMA[i]<Array_OsMA[i+1]) && (Array_OsMA[i]<Array_OsMA[i+2]) && (Array_OsMA[i]<Array_OsMA[i+3]) && (Array_OsMA[i]<Array_OsMA[i-1]))
        {
         if(pos_min1==0){OsMa_min1=Array_OsMA[i];pos_min1=i;}else if(pos_min2==0) {OsMa_min2=Array_OsMA[i];pos_min2=i;}
        }
     }
   Print("Max1: ",DoubleToString(OsMa_max1),", Pos_max1: ",IntegerToString(pos_max1),", Max2: ",DoubleToString(OsMa_max2),", Pos_max2: ",IntegerToString(pos_max2));
   Print("Min1: ",DoubleToString(OsMa_min1),", Pos_min1: ",IntegerToString(pos_min1),", Min2: ",DoubleToString(OsMa_min2),", Pos_min2: ",IntegerToString(pos_min2));

   if(OsMa_max1>0 && OsMa_max2>0 && OsMa_max1>OsMa_max2 && OsMa_min1<0 && OsMa_min2<0 && OsMa_min1>OsMa_min2 ){return("Trend goes UP");}
   if(OsMa_max1>0 && OsMa_max2>0 && OsMa_max1<OsMa_max2 && OsMa_min1<0 && OsMa_min2<0 && OsMa_min1<OsMa_min2 ){return("Trend goes DOWN");}
   return ("Trend is not defined");
  }
//+------------------------------------------------------------------+
void divergere_MA_MACD(ENUM_TIMEFRAMES Test_period) //дивергенция плавающей средней и MACD
                                                    //находим 3 минимума по MA с периодом 2
//находим минимум цены и MACD в точках минимума. Сравниваем. Если дивергенция, то торгуем.
// первый минимум 
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool open_Sell()
  {
 if (CalculateLot){
 trade_volume=trade_volume*last_deal();
 //trade_volume=NormalizeDouble(trade_volume,2);
 if (trade_volume==0){trade_volume=GetLotSize(Symbol(),Risk);}
 }
   return trade.PositionOpen(Symbol(),ORDER_TYPE_SELL,trade_volume,SymbolInfoDouble(Symbol(),SYMBOL_BID),SymbolInfoDouble(Symbol(),SYMBOL_ASK)+StopLoss*_Point,SymbolInfoDouble(Symbol(),SYMBOL_BID)-TakeProfit*_Point);
  }
  
bool open_Buy()
  {
 if (CalculateLot){
 trade_volume=trade_volume*last_deal();
 //trade_volume=NormalizeDouble(trade_volume,2);
 if (trade_volume==0){trade_volume=GetLotSize(Symbol(),Risk);}
 }
   return trade.PositionOpen(Symbol(),ORDER_TYPE_BUY,trade_volume,SymbolInfoDouble(Symbol(),SYMBOL_ASK),SymbolInfoDouble(Symbol(),SYMBOL_BID)-StopLoss*_Point,SymbolInfoDouble(Symbol(),SYMBOL_ASK)+TakeProfit*_Point);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool if_Osma_MacdPrice2Ekstr(ENUM_TIMEFRAMES Test_period,string my_symbol)
  {
   if(Osma_MacdPrice2Ekstr(Test_period,my_symbol)<0)
      return open_Sell();
   return false;

  }
//два убывающих максимума по цене в экстремумах OSma 09,09,2016
/*определяю 2 максимума по Osma - убывают
в максимумах стохастик тоже убывает. стохастик вверху и меньше предыдущего максимума на столько же, 
на сколько предыдущий меньш пред предыдущего
цена не дает новый максимум
продаем со стопом выше пердыдущего максимума
*/
//во втором максимуме цена и MACD не дают максимума - продаем
// 1. если MACD и цена идут на убывание, то возвращает -1
// 2. если выполняется условие 1 и второй минимум Osma меньше первого, то возвращает -2
// TO DO закрывать при появлении 2-х минимумов сигнальной стохастика, если минимумы возрастают на периоде меньше чем период открытия сделки
int Osma_MacdPrice2Ekstr(ENUM_TIMEFRAMES Test_period,string my_symbol) // http://take.ms/owrE8
  {
   if(PositionSelect(my_symbol)!=0) {return(0);};
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(my_symbol,Test_period,0,100,rates);
   if(copied==-1){Print("Ошибка копирования цены в Osma_MacdPrice");return(0);}

   double Array_OsMA[],Array_MACD[],Array_Stoch[];
   int OsMA_handle=iOsMA(my_symbol,Test_period,12,26,9,PRICE_CLOSE);
   int MACD_handle=iMACD(my_symbol,Test_period,12,26,9,PRICE_CLOSE);
   int Stoch_handle=iStochastic(my_symbol,Test_period,5,3,3,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(OsMA_handle,0,0,100,Array_OsMA);
   CopyBuffer(MACD_handle,0,0,100,Array_MACD);
   CopyBuffer(Stoch_handle,0,0,100,Array_Stoch);
   ArraySetAsSeries(Array_OsMA,true);
   ArraySetAsSeries(Array_MACD,true);
   ArraySetAsSeries(Array_Stoch,true);



   int Bars_After=2;
   for(int i=Bars_After;i<=95;i++)
     {
      //ищем максимумы по OsMA первый от текущего бара влево, потом второй и третий
      if((Array_OsMA[i]>Array_OsMA[i+1]) && (Array_OsMA[i]>Array_OsMA[i+2]) && (Array_OsMA[i]>Array_OsMA[i+3]) && (Array_OsMA[i]>Array_OsMA[i-1]) && (Array_OsMA[i]>Array_OsMA[i-Bars_After]))
        {
         if(pos_max1==0){OsMa_max1=Array_OsMA[i];pos_max1=i;}
         else if(pos_max2==0) {OsMa_max2=Array_OsMA[i];pos_max2=i;}
         else if(pos_max3==0) {OsMa_max3=Array_OsMA[i];pos_max3=i;}
        }
      //ищем минимумы первый по OsMA от текущей бара влево, потом второй и третий
      if((Array_OsMA[i]<Array_OsMA[i+1]) && (Array_OsMA[i]<Array_OsMA[i+2]) && (Array_OsMA[i]<Array_OsMA[i+3]) && (Array_OsMA[i]<Array_OsMA[i-1]) && (Array_OsMA[i]<Array_OsMA[i-Bars_After]))
        {
         if(pos_min1==0){OsMa_min1=Array_OsMA[i];pos_min1=i;}
         else if(pos_min2==0) {OsMa_min2=Array_OsMA[i];pos_min2=i;}
         else if(pos_min3==0) {OsMa_min3=Array_OsMA[i];pos_min3=i;}
        }
      if(( pos_max1!=0) && (pos_max2!=0) && (pos_max3!=0) && (pos_min1!=0) && (pos_min2!=0) && (pos_min3!=0)){break;}//выход если нашли все экстремумы
     }
//проверяем убываение
//сравниваем максимум цены (открытия/закрытия) +1 бар вперед и 2 назад от экстремума

   Price=rates[0].close;
   Price_max1=MathMax(MathMax(MathMax(MathMax(MathMax(MathMax(MathMax(rates[pos_max1].open,rates[pos_max1].close),rates[pos_max1+1].open),rates[pos_max1+1].close),rates[pos_max1+2].open),rates[pos_max1+2].close),rates[pos_max1+3].open),rates[pos_max1+3].close);
   Price_max2=MathMax(MathMax(MathMax(MathMax(MathMax(MathMax(MathMax(rates[pos_max2].open,rates[pos_max2].close),rates[pos_max2+1].open),rates[pos_max2+1].close),rates[pos_max2+2].open),rates[pos_max2+2].close),rates[pos_max2+3].open),rates[pos_max2+3].close);
   Price_max3=MathMax(MathMax(MathMax(MathMax(MathMax(MathMax(MathMax(rates[pos_max3].open,rates[pos_max3].close),rates[pos_max3+1].open),rates[pos_max3+1].close),rates[pos_max3+2].open),rates[pos_max3+2].close),rates[pos_max3+3].open),rates[pos_max3+3].close);

   Price_min1=MathMin(MathMin(rates[pos_min1].open,rates[pos_min1].close),MathMin(MathMin(rates[pos_min1+1].open,rates[pos_min1+1].close),MathMin(rates[pos_min1+2].open,rates[pos_min1+2].close)));
   Price_min2=MathMin(MathMin(rates[pos_min2].open,rates[pos_min2].close),MathMin(MathMin(rates[pos_min2+1].open,rates[pos_min2+1].close),MathMin(rates[pos_min2+2].open,rates[pos_min2+2].close)));
   Price_min3=MathMin(MathMin(rates[pos_min3].open,rates[pos_min3].close),MathMin(MathMin(rates[pos_min3+1].open,rates[pos_min3+1].close),MathMin(rates[pos_min3+2].open,rates[pos_min3+2].close)));

//MACD
   MACD=Array_MACD[0];
   MACD_max1=MathMax(MathMax(Array_MACD[pos_max1],Array_MACD[pos_max1+1]),Array_MACD[pos_max1+2]);
   MACD_max2=MathMax(MathMax(Array_MACD[pos_max2],Array_MACD[pos_max2+1]),Array_MACD[pos_max2+2]);
   MACD_max3=MathMax(MathMax(Array_MACD[pos_max3],Array_MACD[pos_max3+1]),Array_MACD[pos_max3+2]);
   MACD_min1=MathMin(MathMin(Array_MACD[pos_min1],Array_MACD[pos_min1+1]),Array_MACD[pos_min1+2]);
   MACD_min2=MathMin(MathMin(Array_MACD[pos_min2],Array_MACD[pos_min2+1]),Array_MACD[pos_min2+2]);
   MACD_min3=MathMin(MathMin(Array_MACD[pos_min3],Array_MACD[pos_min3+1]),Array_MACD[pos_min3+2]);

//Stoch
   Stoch=Array_Stoch[0];
   Stoch_max1=MathMax(MathMax(MathMax(MathMax(Array_Stoch[pos_max1],Array_Stoch[pos_max1+1]),Array_Stoch[pos_max1+2]),Array_Stoch[pos_max1-2]),Array_Stoch[pos_max1-1]);
   Stoch_max2=MathMax(MathMax(MathMax(MathMax(Array_Stoch[pos_max2],Array_Stoch[pos_max2+1]),Array_Stoch[pos_max2+2]),Array_Stoch[pos_max2-2]),Array_Stoch[pos_max2-1]);
   Stoch_max3=MathMax(MathMax(MathMax(MathMax(Array_Stoch[pos_max3],Array_Stoch[pos_max3+1]),Array_Stoch[pos_max3+2]),Array_Stoch[pos_max3-2]),Array_Stoch[pos_max3-1]);
   Stoch_min1=MathMin(MathMin(MathMin(MathMin(Array_Stoch[pos_min1],Array_Stoch[pos_min1+1]),Array_Stoch[pos_min1+2]),Array_Stoch[pos_min1-2]),Array_Stoch[pos_min1-1]);
   Stoch_min2=MathMin(MathMin(MathMin(MathMin(Array_Stoch[pos_min2],Array_Stoch[pos_min2+1]),Array_Stoch[pos_min2+2]),Array_Stoch[pos_min2-2]),Array_Stoch[pos_min2-1]);
   Stoch_min3=MathMin(MathMin(MathMin(MathMin(Array_Stoch[pos_min3],Array_Stoch[pos_min3+1]),Array_Stoch[pos_min3+2]),Array_Stoch[pos_min3-2]),Array_Stoch[pos_min3-1]);

//Osma
   OsMa=Array_OsMA[0];
   OsMa_max1=MathMax(MathMax(Array_OsMA[pos_max1],Array_OsMA[pos_max1+1]),Array_OsMA[pos_max1+2]);
   OsMa_max2=MathMax(MathMax(Array_OsMA[pos_max2],Array_OsMA[pos_max2+1]),Array_OsMA[pos_max2+2]);
   OsMa_max3=MathMax(MathMax(Array_OsMA[pos_max3],Array_OsMA[pos_max3+1]),Array_OsMA[pos_max3+2]);
   OsMa_min1=MathMin(MathMin(Array_OsMA[pos_min1],Array_OsMA[pos_min1+1]),Array_OsMA[pos_min1+2]);
   OsMa_min2=MathMin(MathMin(Array_OsMA[pos_min2],Array_OsMA[pos_min2+1]),Array_OsMA[pos_min2+2]);
   OsMa_min3=MathMin(MathMin(Array_OsMA[pos_min3],Array_OsMA[pos_min3+1]),Array_OsMA[pos_min3+2]);




//  Print("TimeTradeServer",TimeTradeServer());
 /*  if(TimeTradeServer()==D'2017.02.06 00:05:00')
     {
      Print("@@@@@@@@@@ Osma_MacdPrice2Ekstr @@@@@@@@@@");
      Print("Price=",Price," Stoch=",Stoch," OsMa=",OsMa," MACD=",MACD);
      Print("pos_max1=",pos_max1," Price=",Price_max1," MACD=",DoubleToString(MACD_max1)," OsMa=",DoubleToString(OsMa_max1)," Stoch=",DoubleToString(Stoch_max1));
      Print("pos_max2=",pos_max2," Price=",Price_max2," MACD=",DoubleToString(MACD_max2)," OsMa=",DoubleToString(OsMa_max2)," Stoch=",DoubleToString(Stoch_max2));
      Print("pos_max3=",pos_max3," Price=",Price_max3," MACD=",DoubleToString(MACD_max3)," OsMa=",DoubleToString(OsMa_max3)," Stoch=",DoubleToString(Stoch_max3));
      Print("pos_min1=",pos_min1," Price=",Price_min1," MACD=",DoubleToString(MACD_min1)," OsMa=",DoubleToString(OsMa_min1)," Stoch=",DoubleToString(Stoch_min1));
      Print("pos_min2=",pos_min2," Price=",Price_min2," MACD=",DoubleToString(MACD_min2)," OsMa=",DoubleToString(OsMa_min2)," Stoch=",DoubleToString(Stoch_min2));
      Print("pos_min3=",pos_min3," Price=",Price_min3," MACD=",DoubleToString(MACD_min3)," OsMa=",DoubleToString(OsMa_min3)," Stoch=",DoubleToString(Stoch_min3));
     }
*/

if(
((OsMa_max1<OsMa_max2)||(Par1))
//&&((OsMa<OsMa_max1)||(Par2))
//&&((OsMa_max1>0)||(Par3))
&&((OsMa_max2>0)||(Par4))
&&((OsMa_min1<OsMa_min2)||(Par5))
//&&((Price_max1>Price)||(Par6))
&&((MACD>0)||(Par7))
&&((MACD_max1>0)||(Par8))
//&&((MACD_max2>0)||(Par9))
//&&((MACD_min1>0)||(Par10))
//&&((MACD_max1>MACD_max2)||(Par10))
//&&((MACD_min3<0)||(Par12))
//&&((Stoch>50)||(Par13))
&&((Stoch_max1>80)||(Par14))
//&&((Stoch_min1<20)||(Par15))
//&&((pos_min1<pos_max1)||(Par16))
   )
{
open_Sell();
}
return 0;

if(
((OsMa_min1>OsMa_min2)||(Par1))
//&&((OsMa<OsMa_max1)||(Par2))
//&&((OsMa_max1>0)||(Par3))
&&((OsMa_min2<0)||(Par4))
&&((OsMa_max1>OsMa_max2)||(Par5))
//&&((Price_max1>Price)||(Par6))
&&((MACD<0)||(Par7))
&&((MACD_min1<0)||(Par8))
//&&((MACD_max2>0)||(Par9))
//&&((MACD_min1>0)||(Par10))
//&&((MACD_max1>MACD_max2)||(Par10))
//&&((MACD_min3<0)||(Par12))
//&&((Stoch>50)||(Par13))
&&((Stoch_min1<20)||(Par14))
//&&((Stoch_min1<20)||(Par15))
//&&((pos_min1<pos_max1)||(Par16))
   )
{
open_Buy();
}
return 0;



   if((Stoch>Stoch_max1-(Stoch_max2-Stoch_max1)) && (Stoch_max1<Stoch_max2) && (Stoch_max2<Stoch_max3)
      && (OsMa_max1<OsMa_max2) && (OsMa_max2<OsMa_max3) && (OsMa_max1>0)
      && (Price<Price_max1) && (Price_max1<Price_max2)
      && (MACD>0) && (MACD_max1*1000>1) && (MACD_max2*1000>1)
      )
     {
      Print("***Сделка на продажу***",EnumToString(Test_period));
      Print("Price=",Price," Stoch=",Stoch);
      Print("pos_max1=",pos_max1," Price=",Price_max1," MACD=",DoubleToString(MACD_max1)," OsMa=",DoubleToString(OsMa_max1)," Stoch=",DoubleToString(Stoch_max1));
      Print("pos_max2=",pos_max2," Price=",Price_max2," MACD=",DoubleToString(MACD_max2)," OsMa=",DoubleToString(OsMa_max2)," Stoch=",DoubleToString(Stoch_max2));
      Print("pos_max3=",pos_max3," Price=",Price_max3," MACD=",DoubleToString(MACD_max3)," OsMa=",DoubleToString(OsMa_max3)," Stoch=",DoubleToString(Stoch_max3));

      return(-1);
     }

   if((Stoch<Stoch_min1+(Stoch_min2-Stoch_min1)) && (Stoch_min1>Stoch_min2) && (Stoch_min2>Stoch_min3)
      && (OsMa_min1>OsMa_min2) && (OsMa_min2>OsMa_min3) && (OsMa_min1<0)
      && (Price>Price_min1) && (Price_min1>Price_min2)
      && (MACD<0) && (MACD_min1*1000<-1) && (MACD_min2*1000<-1)
      )
     {
      Print("***Сделка на покупку***",EnumToString(Test_period));
      Print("Price=",Price," Stoch=",Stoch);
      Print("pos_min1=",pos_min1," Price=",Price_min1," MACD=",DoubleToString(MACD_min1)," OsMa=",DoubleToString(OsMa_min1)," Stoch=",DoubleToString(Stoch_min1));
      Print("pos_min2=",pos_min2," Price=",Price_min2," MACD=",DoubleToString(MACD_min2)," OsMa=",DoubleToString(OsMa_min2)," Stoch=",DoubleToString(Stoch_min2));
      Print("pos_min2=",pos_min3," Price=",Price_min3," MACD=",DoubleToString(MACD_min3)," OsMa=",DoubleToString(OsMa_min3)," Stoch=",DoubleToString(Stoch_min3));

trade_volume=GetLotSize(my_symbol,50);

      trade.PositionOpen(my_symbol,ORDER_TYPE_BUY,trade_volume,SymbolInfoDouble(my_symbol,SYMBOL_ASK),SymbolInfoDouble(my_symbol,SYMBOL_BID)-StopLoss*_Point,SymbolInfoDouble(my_symbol,SYMBOL_ASK)+TakeProfit*_Point,
                         "Osma_MacdPrice "+EnumToString(Test_period));
      return(2);
     }

   if((Price_min2<Price_min1) && // цена идет в рост
      (MACD_min2<MACD_min1) && (MACD_max2<MACD_max1) && (MACD_min1<0) && // MACD ростет и ниже нуля
      // (pos_min1<pos_max1) && //торгуем от минимума
      //(OsMa_max1>OsMa_max2) && //максимумы в рост (фильтр для M30 2014.01.03
      (OsMa_min2<OsMa_min1) && // OSMA в рост 
      //  (pos_min1>2) && (pos_min1<10)&&//нарисовался минимум 
      (Stoch_min1<20) && (Stoch_max1>70) // стохастик выше 80, в минимуме меньше 30
      && (Stoch<10) //текущая стохастик < 10
      && (OsMa_max1<-1*OsMa_min2)
      //     && (OsMa_max1>OsMa_max2) //максимумы идут по возрастанию
      && (OsMa_max2>0) //&& (OsMa_min1<0)
      && (rates[0].open>Price_min1) && (rates[0].close>Price_min1))
     {
      // */
      // trade.PositionOpen(my_symbol,ORDER_TYPE_BUY,trade_volume,SymbolInfoDouble(my_symbol,SYMBOL_ASK),SymbolInfoDouble(my_symbol,SYMBOL_BID)-StopLoss*_Point,SymbolInfoDouble(my_symbol,SYMBOL_ASK)+TakeProfit*_Point,
      //                        "Osma_MacdPrice "+EnumToString(Test_period));

      return(2);
     }

   return(0);
  }

