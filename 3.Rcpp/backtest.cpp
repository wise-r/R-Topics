#include <Rcpp.h>
using namespace Rcpp;
using namespace std;

inline int fsign(double x) {
  int s;
  
  if(x < 0) {
    s = -1;
  } else {
    s = x > 0 ? 1:0;
  }
  
  return(s);
}
  
class Trader {
private:
  double cash;
  int position;
  NumericVector balance;
  
public:
  Trader(double initial_cash) {
    cash = initial_cash;
    balance.push_back(cash);
  };
  
  void place_order(int size, double price) {
    cash -= size*price;
    position += size;
  };
  
  double get_position() {
    return(position);
  };
  
  int get_state() {
    return(fsign(position));
  };
  
  void settle(double price) {
    balance.push_back(cash + position*price);
  };
  
  NumericVector get_balance() {
    return(balance);
  };
};

// [[Rcpp::export]]
NumericVector backtest(NumericVector p, List params) {
  Trader trader(1e6);
  int k = params["K"];
  double bk = params["BKRatio"];
  int n = p.size();
  
  for(int i = k; i < n; i++) {
    if(p[i] - p[i-k] > bk && trader.get_position() < 10) {
      trader.place_order(1, p[i]); 
    }
    if(p[i] - p[i-k] < -0.2*bk && trader.get_position() > 0) {
      trader.place_order(-trader.get_position(), p[i]);
    }
    
    trader.settle(p[i]);
  };
  
  return(trader.get_balance());
}