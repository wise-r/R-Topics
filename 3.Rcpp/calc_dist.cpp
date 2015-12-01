#include <Rcpp.h>
#include <math.h>

using namespace Rcpp;
using namespace std;

double get_dist(double alpha, double x_long, double x_lat, double y_long, double y_lat)
{
  const double trans = cos(alpha*3.1415926/180);
  const double long_length = 111320;
  double dist;
  
  dist = sqrt( pow(x_long*trans - y_long*trans, 2) + pow(x_lat - y_lat, 2) ) * long_length;
  
  return dist;
}

// [[Rcpp::export]]
List get_neighbors(int x_id, double alpha, DataFrame positions)
{
  vector<int> store_id = positions["ID"];
  vector<double> LONG = positions["LONG"];
  vector<double> LAT = positions["LAT"];

  const int store_num = store_id.size();
  double x_long = LONG[x_id];
  double x_lat = LAT[x_id];
  
  double y_long = 0.0;
  double y_lat = 0.0;
  double dist = 999.0;
  vector<int> neighbors;
  
  for(int y_id = 0; y_id < store_num; y_id++)
  {
    y_long = LONG[y_id];
    y_lat = LAT[y_id];
    
    if(y_id == x_id || abs(x_lat - y_lat) > 0.001 || abs(x_long - y_long) > 0.001)
    {
      continue;
    }
    else 
    {
      dist = get_dist(alpha, x_long, x_lat, y_long, y_lat);
      
      if(dist <= 100)
      {
        neighbors.push_back(y_id+1);
      }
    }
  }
  
  return List::create(
    _["ID"] = x_id,
    _["neighbors"] = neighbors
    );
}

